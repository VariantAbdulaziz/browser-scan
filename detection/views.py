import json
from django.conf import settings
from django.contrib.gis.geoip2 import GeoIP2
from rest_framework.decorators import api_view
from rest_framework.response import Response
from .models import DNSLog

@api_view(['GET'])
def dns_results(request):
    token = request.GET.get("token")
    if not token:
        return Response({"error": "Missing token"}, status=400)

    expected_isp = request.GET.get("expected_isp")  # optional for DNS leak check

    logs = DNSLog.objects.filter(token=token).order_by("-timestamp")
    results = []
    leak_detected = False

    for q in logs:
        entry = {
            "resolver_ip": q.resolver_ip,
            "qname": q.qname,
            "qtype": q.qtype,
            "timestamp": q.timestamp.isoformat(),
            "geo": q.geo
        }
        if expected_isp and q.geo and q.geo.get("isp") != expected_isp:
            leak_detected = True
        results.append(entry)

    return Response({
        "count": len(results),
        "dns_leak": leak_detected,
        "results": results
    })
