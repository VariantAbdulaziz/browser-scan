from django.contrib import admin
from .models import DNSLog

@admin.register(DNSLog)
class DNSLogAdmin(admin.ModelAdmin):
    list_display = ("timestamp", "token", "resolver_ip", "qname", "qtype")
    list_filter = ("qtype", "timestamp")
    search_fields = ("token", "resolver_ip", "qname")
    readonly_fields = ("timestamp",)
    ordering = ("-timestamp",)

