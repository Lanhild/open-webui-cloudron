#!/bin/bash
set -eu

echo "=> Creating directories"
mkdir -p /app/data/

if [[ ! -f /app/data/.webui_secret_key ]]; then
    echo "==> Create WebUI secret key"
    echo $(head -c 12 /dev/random | base64) > /app/data/.webui_secret_key
fi

echo "Loading WEBUI_SECRET_KEY from key file"
export WEBUI_SECRET_KEY="$(cat /app/data/.webui_secret_key)"

export PORT="8080"
export DATA_DIR="/app/data/"
export OLLAMA_API_BASE_URL="https://example.com/api"

if [[ ! -f /app/data/env ]]; then
    cat > /app/data/env << EOF
# Add custom environment variables in this file
WEBUI_SECRET_KEY=${WEBUI_SECRET_KEY}
PORT=${PORT}
DATA_DIR=${DATA_DIR}
# Ollama URL for the backend to connect
OLLAMA_API_BASE_URL=${OLLAMA_API_BASE_URL}

# Optional, used to connect to OpenAI
OPENAI_API_BASE_URL=
OPENAI_API_KEY=

EOF
fi

echo "==> Starting Ollama WebUI"
cd /app/code/ollama-webui/backend
WEBUI_SECRET_KEY="$WEBUI_SECRET_KEY" DATA_DIR="$DATA_DIR" exec uvicorn main:app --host 0.0.0.0 --port "${PORT}" --forwarded-allow-ips '*'
