#!/bin/bash
set -eu

echo "=> Ensure directories"
mkdir -p /app/data/

if [[ ! -f /app/data/.webui_secret_key ]]; then
    echo "=> Creating WebUI secret key"
    echo $(head -c 12 /dev/random | base64) > /app/data/.webui_secret_key
fi

echo "=> Loading configuration"
export WEBUI_SECRET_KEY="$(cat /app/data/.webui_secret_key)"
export PORT="8080"
export DATA_DIR="/app/data"
export DOCS_DIR="$DATA_DIR/uploads"
export OLLAMA_API_BASE_URL="https://example.com/api"

if [[ ! -f /app/data/.env ]]; then
    cat > /app/data/.env << EOF
# Add custom environment variables in this file
WEBUI_SECRET_KEY=${WEBUI_SECRET_KEY}
PORT=${PORT}
DATA_DIR=${DATA_DIR}
DOCS_DIR=${DOCS_DIR}
# Ollama URL for the backend to connect
OLLAMA_API_BASE_URL=${OLLAMA_API_BASE_URL}

# Optional, used to connect to OpenAI
# OPENAI_API_BASE_URL=
# OPENAI_API_KEY=

# DO NOT TRACK
SCARF_NO_ANALYTICS=true
DO_NOT_TRACK=true

EOF
fi

echo "=> Setting permissions"
chown -R cloudron:cloudron /app/data

source /app/data/.env

echo "=> Starting Open WebUI"
cd /app/code/backend
WEBUI_SECRET_KEY="$WEBUI_SECRET_KEY" DATA_DIR="$DATA_DIR" exec gosu cloudron:cloudron uvicorn main:app --host 0.0.0.0 --port "${PORT}" --forwarded-allow-ips '*'
