import json
import time

from django.conf import settings
from django.contrib.gis.geoip2 import GeoIP2

from rest_framework.decorators import api_view
from rest_framework.response import Response
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


@api_view(["POST"])
def upload_speed_test(request):
    """
    Simulates an upload speed test endpoint.
    Reads raw binary data and sleeps proportionally to data size.
    """
    try:
        # Read binary body (already fully loaded in DRF request)
        data = request.body
        data_length = len(data)

        # Simulate processing time — 10s per MB, capped at 100s
        processing_time = min((data_length / (1024 * 1024)) * 10, 100)
        time.sleep(processing_time)

        return Response(
            {
                "received": data_length,
                "status": "success",
            },
            headers={
                "Cache-Control": "no-cache, no-store, must-revalidate",
            },
            status=200,
        )

    except Exception as e:
        return Response(
            {
                "error": "Upload test failed",
                "details": str(e),
                "status": "error",
            },
            status=500,
        )
