from django.contrib import admin
from django.urls import path, include
from .views import healthz, geoip_lookup
from detection.views import dns_results

urlpatterns = [
    path('admin/', admin.site.urls),
    path('', include('accounts.urls')),
    path('healthz/', healthz, name='healthz'),
    path("api/v1/lookup", geoip_lookup, name='geoip_lookup'),
    path("api/v1/dns-leak-test-results/", dns_results, name="dns_results"),
]
