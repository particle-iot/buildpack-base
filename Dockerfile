FROM multiarch/alpine:x86-v3.3

RUN apk add --update git bash curl && rm -rf /var/cache/apk/*
RUN git clone https://github.com/sstephenson/bats.git && \
  cd bats && ./install.sh /usr/local && cd .. && \
  rm -r bats
# Install glibc
RUN curl -o glibc-bin.tar.gz -sSL https://github.com/spark/docker-glibc-builder/releases/download/2.23-0_x86/glibc-bin.tar.gz && \
  tar xzf glibc-bin.tar.gz && ln -s /usr/glibc-compat/lib/ld-linux.so.2 /lib && \
  rm glibc-bin.tar.gz
ENV LANG=C.UTF-8

COPY . /
VOLUME ["/input", "/output", "/cache", "/ssh", "/log"]
CMD ["/bin/run"]
