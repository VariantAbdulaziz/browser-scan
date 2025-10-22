from django.apps import AppConfig


class DetectionConfig(AppConfig):
    default_auto_field = 'django.db.models.BigAutoField'
    name = 'detection'

    def ready(self):
        # Prevent multiple starts (especially in dev server reloads)
        if hasattr(self, "dns_logger_started"):
            return

        from .dns_logger import LoggingResolver
        from dnslib.server import DNSServer
     

        resolver = LoggingResolver()
        tcp_server = DNSServer(resolver, port=53, address="0.0.0.0", tcp=True)
        udp_server = DNSServer(resolver, port=53, address="0.0.0.0", tcp=False)

        tcp_server.daemon_threads = True
        udp_server.daemon_threads = True

        tcp_server.start_thread()
        udp_server.start_thread()


        self.dns_logger_started = True
    