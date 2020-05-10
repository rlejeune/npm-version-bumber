FROM alpine

COPY entrypoint.sh /entrypoint.sh

RUN apk update && apk add bash git

ENTRYPOINT ["/entrypoint.sh"]