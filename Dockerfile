FROM ghcr.io/n8n-io/n8n:latest

# ставим зависимости в /home/node/.n8n (персистентный каталог для n8n)
USER root
RUN mkdir -p /home/node/.n8n \
  && chown -R node:node /home/node/.n8n

USER node
WORKDIR /home/node/.n8n

# создаём package.json и ставим pdf-lib на этапе build (один раз, без npm на старте)
RUN test -f package.json || npm init -y >/dev/null 2>&1 \
  && npm i --omit=dev pdf-lib \
  && npm cache clean --force >/dev/null 2>&1

# обратно в дефолтный workdir образа
WORKDIR /home/node
