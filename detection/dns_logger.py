import os
import json
from dnslib.server import BaseResolver
from dnslib import RR, QTYPE, A
from .models import DNSLog
from django.contrib.gis.geoip2 import GeoIP2
from django.conf import settings
from django.utils import timezone

class LoggingResolver(BaseResolver):
    """
    DNS Resolver that logs queries directly to the DB and also writes each
    query as a JSON line in ./logs folder.
    Extracts token from subdomain: <token>-<i>.test.<main-domain>
    """
    def __init__(self):
        self.geoip = GeoIP2(path=settings.GEOIP_DIR)
        self.log_dir = os.path.join(settings.BASE_DIR, "logs")
        os.makedirs(self.log_dir, exist_ok=True)

    def resolve(self, request, handler):
        qname = str(request.q.qname).rstrip(".")  # e.g., abc123-0.test.api.mutation.cc
        qtype = QTYPE[request.q.qtype]
        resolver_ip = handler.client_address[0]

        # Extract token from subdomain
        parts = qname.split(".")
        if len(parts) > 3:  # e.g., abc123-0.test.api.mutation.cc
            token_label = parts[0]          # abc123-0
            token = token_label.split("-")[0]  # abc123
        else:
            token = "default_token"

        # GeoIP lookup
        try:
            country = self.geoip.country(resolver_ip)
            city = self.geoip.city(resolver_ip)
            try:
                isp = self.geoip.org(resolver_ip)
            except Exception:
                isp = "Unknown"
        except Exception:
            country = {"country_code": "XX", "country_name": "Unknown"}
            city = {"city": "Unknown", "latitude": None, "longitude": None}
            isp = "Unknown"

        geo_info = {
            "country": country,
            "city": city,
            "isp": isp
        }

        timestamp = timezone.now()
        
        # Save to database
        DNSLog.objects.create(
            token=token,
            resolver_ip=resolver_ip,
            qname=qname,
            qtype=qtype,
            geo=geo_info,
            timestamp=timestamp
        )

        # Also write to file
        log_entry = {
            "timestamp": timestamp.isoformat(),
            "token": token,
            "resolver_ip": resolver_ip,
            "qname": qname,
            "qtype": qtype,
            "geo": geo_info
        }
        log_file_path = os.path.join(self.log_dir, f"{token}.log")
        with open(log_file_path, "a", encoding="utf-8") as f:
            f.write(json.dumps(log_entry) + "\n")

        # Return dummy DNS answer
        reply = request.reply()
        reply.add_answer(RR(qname, QTYPE.A, rdata=A("16.170.184.147"), ttl=60))
        return reply
