FROM alpine:3.3

RUN apk add --update git bash && rm -rf /var/cache/apk/*
RUN git clone https://github.com/sstephenson/bats.git && \
  cd bats && ./install.sh /usr/local && cd .. && \
  rm -r bats

COPY . /
VOLUME ["/input", "/output", "/cache", "/ssh"]
CMD ["/bin/run"]
