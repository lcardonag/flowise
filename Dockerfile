FROM node:18-alpine

USER root

# Arguments that can be passed at build time
ARG FLOWISE_PATH=/usr/local/lib/node_modules/flowise
ARG BASE_PATH=/root/.flowise
ARG DATABASE_PATH=$BASE_PATH
ARG APIKEY_PATH=$BASE_PATH
ARG SECRETKEY_PATH=$BASE_PATH
ARG LOG_PATH=$BASE_PATH/logs
ARG BLOB_STORAGE_PATH=$BASE_PATH/storage

# Install dependencies
RUN apk add --no-cache git python3 py3-pip make g++ build-base cairo-dev pango-dev chromium

ENV PUPPETEER_SKIP_DOWNLOAD=true
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser

# Change ownership and permissions of logs directory
RUN chown -R root:root /usr/local/lib/node_modules/flowise/logs
RUN chmod -R 755 /usr/local/lib/node_modules/flowise/logs

# Install Flowise globally
RUN npm install -g flowise

# Configure Flowise directories using the ARG
RUN mkdir -p $LOG_PATH $FLOWISE_PATH/uploads && chmod -R 777 $LOG_PATH $FLOWISE_PATH

WORKDIR /data

VOLUME /usr/local/lib/node_modules/flowise/logs

# Mount a volume for the logs directory
VOLUME /usr/local/lib/node_modules/flowise/logs

CMD ["npx", "flowise", "start"]
