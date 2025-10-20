import os

from channels.auth import AuthMiddlewareStack
from channels.routing import ProtocolTypeRouter, URLRouter
from channels.security.websocket import AllowedHostsOriginValidator
from django.core.asgi import get_asgi_application
from django.urls import re_path, path

os.environ.setdefault("DJANGO_SETTINGS_MODULE", "core.settings")
django_asgi_app = get_asgi_application()

from accounts.consumers import AuthConsumer

application = ProtocolTypeRouter({
    "http": django_asgi_app,

    "websocket": 
        # AllowedHostsOriginValidator(
            # AuthMiddlewareStack(
                URLRouter([
                    path('ws/<str:uuid>/', AuthConsumer.as_asgi()),
                ])
            # )
        # )
})
