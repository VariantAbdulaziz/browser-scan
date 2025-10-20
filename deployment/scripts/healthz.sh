#!/bin/bash
# Check /healthz endpoint
curl -f http://127.0.0.1/healthz || exit 1
