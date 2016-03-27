FROM alpine
RUN apk add --no-cache bash curl ncurses openssh openssl jq
COPY . .
CMD ["bash", "deploy.sh"]