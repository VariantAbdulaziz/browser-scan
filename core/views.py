from django.contrib.gis.geoip2 import GeoIP2
from django.conf import settings

from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework.decorators import api_view
from rest_framework.response import Response
import os

@api_view(['GET'])
def healthz(request):
    return Response({"status": "ok"}, status=200)


@api_view(['GET'])
def geoip_lookup(request):
    """
    Returns the country and city for the request's IP.
    """
    # Get client IP (handles X-Forwarded-For if behind a proxy)
    ip = request.META.get('HTTP_X_FORWARDED_FOR', request.META.get('REMOTE_ADDR', None))
    if ip and ',' in ip:  # sometimes X-Forwarded-For can be a list
        ip = ip.split(',')[0].strip()

    # Initialize GeoIP2 using path from environment
    geoip_path = settings.GEOIP_DIR
    g = GeoIP2(path=geoip_path)

    try:
        country = g.country(ip)
        city = g.city(ip)
    except Exception:
        country = {"country_name": "Unknown", "country_code": "XX"}
        city = {"city": "Unknown", "region": "", "latitude": None, "longitude": None}

    return Response({
        "ip": ip,
        "country": country,
        "city": city
    }, status=200)
