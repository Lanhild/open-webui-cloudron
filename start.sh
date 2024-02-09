#!/bin/bash
set -eu

echo "=> Creating directories"
mkdir -p /app/data/ /run/ollama-webui

# https://github.com/calcom/cal.com/issues/8017
if [[ ! -f /app/data/.webui_secret_key ]]; then
    echo "==> Create WebUI secret key"
    echo $(head -c 12 /dev/random | base64) > /app/data/.webui_secret_key
fi

echo "Loading WEBUI_SECRET_KEY from key file"
export WEBUI_SECRET_KEY="$(cat /app/data/.webui_secret_key)"

if [[ ! -f /app/data/env ]]; then
    cat > /app/data/env << EOF
# Add custom environment variables in this file
WEBUI_SECRET_KEY=${WEBUI_SECRET_KEY}
PORT="8080"

EOF
fi

echo "==> Starting Ollama WebUI"
cd /app/code/ollama-webui/backend
WEBUI_SECRET_KEY="$WEBUI_SECRET_KEY" exec uvicorn main:app --host 0.0.0.0 --port "${PORT}" --forwarded-allow-ips '*'
