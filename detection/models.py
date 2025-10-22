from django.db import models
from django.contrib.postgres.fields import JSONField

class DNSLog(models.Model):
    timestamp = models.DateTimeField(auto_now_add=True)
    resolver_ip = models.GenericIPAddressField()
    qname = models.CharField(max_length=255)
    qtype = models.CharField(max_length=10)
    token = models.CharField(max_length=64, db_index=True)

    geo = models.JSONField(blank=True, null=True)  # store city, country, ASN, ISP

    def __str__(self):
        return f"{self.token} - {self.resolver_ip}"
