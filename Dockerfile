FROM ghcr.io/n8n-io/n8n:latest

USER root
RUN mkdir -p /home/node/.n8n /home/node/.npm-cache \
  && chown -R node:node /home/node/.n8n /home/node/.npm-cache

USER node
ENV HOME=/home/node
ENV NPM_CONFIG_CACHE=/home/node/.npm-cache
WORKDIR /home/node/.n8n

# Создаём package.json вручную (npm init в .n8n падает из-за invalid name)
RUN if [ ! -f package.json ]; then \
      printf '%s\n' \
        '{' \
        '  "name": "n8n-user-data",' \
        '  "private": true,' \
        '  "version": "1.0.0",' \
        '  "description": "n8n user data deps",' \
        '  "dependencies": {}' \
        '}' > package.json; \
    fi

RUN npm install --omit=dev --no-fund --no-audit pdf-lib \
  && npm cache clean --force

WORKDIR /home/node
