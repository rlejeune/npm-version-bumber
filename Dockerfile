FROM alpine

COPY entrypoint.sh /entrypoint.sh

# Install bash, git and curl
RUN apk update && apk add bash git curl

# Get NodeJS install script and pass it to execute:
# RUN curl -sL https://deb.nodesource.com/setup_10.x | bash

# Install node
RUN apk add --update nodejs npm

ENTRYPOINT ["/entrypoint.sh"]