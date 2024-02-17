FROM cloudron/base:4.2.0@sha256:46da2fffb36353ef714f97ae8e962bd2c212ca091108d768ba473078319a47f4

RUN mkdir -p /app/code
WORKDIR /app/code

RUN git clone https://github.com/open-webui/open-webui /app/code

RUN wget "https://chroma-onnx-models.s3.amazonaws.com/all-MiniLM-L6-v2/onnx.tar.gz" -O - | \
    tar -xzf - -C /app/code && \
    mkdir -p /run/cloudron.cache/chroma/onnx_models/all-MiniLM-L6-v2 && \
    mv /app/code/onnx /run/cloudron.cache/chroma/onnx_models/all-MiniLM-L6-v2/onnx

RUN npm ci && \
    npm run build && \
    rm -rf node_modules/.cache 

# Free up space by deleting unused files
# RUN shopt -s extglob && \
#     rm -rf !(backend|build) && \
#     rm -rf .!(backend|build)

ENV ENV=prod
ENV PORT ""

ENV OLLAMA_API_BASE_URL "/ollama/api"

ENV OPENAI_API_BASE_URL ""
ENV OPENAI_API_KEY ""

ENV WEBUI_SECRET_KEY ""

ENV SCARF_NO_ANALYTICS true
ENV DO_NOT_TRACK true

WORKDIR /app/code/backend

RUN pip3 install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cpu --no-cache-dir
RUN pip3 install -r requirements.txt

RUN apt-get update && \
    apt-get install -y pandoc netcat-openbsd && \
    rm -rf /var/cache/apt /var/lib/apt/lists

COPY start.sh /app/pkg/

CMD ["/app/pkg/start.sh"]