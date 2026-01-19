FROM ghcr.io/n8n-io/n8n:latest

USER root
RUN mkdir -p /home/node/.n8n /home/node/.npm-cache \
  && chown -R node:node /home/node/.n8n /home/node/.npm-cache

USER node
ENV HOME=/home/node
ENV NPM_CONFIG_CACHE=/home/node/.npm-cache
WORKDIR /home/node/.n8n

# НЕ скрываем вывод, чтобы видеть ошибку если снова упадет
RUN if [ ! -f package.json ]; then npm init -y; fi \
  && npm install --omit=dev --no-fund --no-audit pdf-lib \
  && npm cache clean --force

WORKDIR /home/node
