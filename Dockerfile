FROM ubuntu:16.04

ADD https://github.com/openfaas/faas/releases/download/0.7.2/fwatchdog /usr/local/bin
RUN apt-get update -q && apt-get install -qy git bash curl bats \
  && apt-get clean && apt-get purge \
  && chmod +x /usr/local/bin/fwatchdog \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV fprocess=/bin/run

VOLUME ["/input", "/output", "/cache", "/ssh", "/log"]
CMD ["/usr/local/bin/fwatchdog"]
COPY . /
