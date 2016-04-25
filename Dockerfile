FROM alpine:3.3

RUN apk add --update git && rm -rf /var/cache/apk/*

COPY . /
VOLUME ["/input", "/output", "/cache", "/ssh"]
CMD ["/bin/run"]
