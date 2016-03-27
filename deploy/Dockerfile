FROM alpine
RUN apk add --no-cache bash curl openssh openssl perl jq
COPY . .
CMD ["bash", "deploy.sh"]