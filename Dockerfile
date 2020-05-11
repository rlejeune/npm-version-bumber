FROM alpine

COPY entrypoint.sh /entrypoint.sh

RUN apk update && apk add bash git node

ENTRYPOINT ["/entrypoint.sh"]