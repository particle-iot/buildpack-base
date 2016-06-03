FROM ubuntu:16.04

RUN apt-get update -q && apt-get install -qy git bash curl bats \
  && apt-get clean && apt-get purge \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY . /
VOLUME ["/input", "/output", "/cache", "/ssh", "/log"]
CMD ["/bin/run"]
