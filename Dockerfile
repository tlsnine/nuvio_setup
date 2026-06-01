FROM node:20-alpine AS builder
WORKDIR /app
RUN apk add --no-cache git
RUN git clone https://github.com/ParticularCatch449/Nuvio.git .
RUN npm install
RUN npm run build

FROM caddy:latest
COPY --from=builder /app/dist /usr/share/caddy
COPY Caddyfile /etc/caddy/Caddyfile
EXPOSE 80
HEALTHCHECK --interval=30s --timeout=3s --start-period=10s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost/ || exit 1
CMD ["caddy", "run", "--config", "/etc/caddy/Caddyfile"]
