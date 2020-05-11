FROM alpine

COPY entrypoint.sh /entrypoint.sh

# Install bash, git and curl
RUN apk update && apk add bash git curl

# Install node and npm
RUN apk add --update nodejs npm

ENTRYPOINT ["/entrypoint.sh"]