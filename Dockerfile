FROM debian:bookworm-slim AS builder

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# hadolint ignore=DL3008
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    curl ca-certificates && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /build

RUN curl -fL --retry 3 \
    https://huggingface.co/mozilla-ai/TinyLlama-1.1B-Chat-v1.0-llamafile/resolve/7987d30e0e838e208982c36518039821c096d9ab/TinyLlama-1.1B-Chat-v1.0.Q4_K_M.llamafile \
    -o model.llamafile && \
    echo "c870ac0e927f9162a5849bb886c5de7160e86406d745d54849c408f0708d679e  model.llamafile" | sha256sum -c - && \
    chmod 755 model.llamafile

FROM debian:bookworm-slim

WORKDIR /app

COPY --from=builder /build/model.llamafile /app/model.llamafile

ENV HOME=/tmp
ENV THREADS=2

USER 10001:10001

EXPOSE 8080

ENTRYPOINT ["/bin/sh", "-c", "exec /bin/sh /app/model.llamafile --server --nobrowser --host 0.0.0.0 --port 8080 -t \"$THREADS\""]
