from django.contrib import admin
from django.urls import path, include
from .views import healthz, geoip_lookup

urlpatterns = [
    path('admin/', admin.site.urls),
    path('', include('accounts.urls')),
    path('healthz/', healthz, name='healthz'),
    path("api/v1/lookup", geoip_lookup, name='geoip_lookup')
]
