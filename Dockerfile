FROM cloudron/base:4.2.0@sha256:46da2fffb36353ef714f97ae8e962bd2c212ca091108d768ba473078319a47f4

RUN mkdir -p /app/code/ollama-webui
WORKDIR /app/code/ollama-webui

RUN git clone https://github.com/ollama-webui/ollama-webui /app/code/ollama-webui

RUN npm ci && \
    npm run build && \
    rm -rf node_modules/.cache 

ENV ENV=prod
ENV PORT ""

ENV OLLAMA_API_BASE_URL "/ollama/api"

ENV OPENAI_API_BASE_URL ""
ENV OPENAI_API_KEY ""

ENV WEBUI_SECRET_KEY ""

WORKDIR /app/code/ollama-webui/backend

RUN pip3 install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cpu --no-cache-dir
RUN pip3 install -r requirements.txt

RUN apt-get update && \
    apt-get install -y pandoc netcat-openbsd && \
    rm -rf /var/lib/apt/lists/*

COPY start.sh /app/pkg/

CMD ["/app/pkg/start.sh"]
