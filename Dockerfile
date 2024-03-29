FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update -qy \
  && apt-get upgrade -qy \
  && apt-get install -qy git bash curl bats \
  && apt-get update -qy \
  && apt-get clean && apt-get purge \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  && ln -s /usr/test /test

VOLUME ["/input", "/output", "/cache", "/ssh", "/log"]
CMD ["/bin/run"]
# NOTE: /bin and /lib are symlinks to /usr/bin and /usr/lib
COPY . /usr/
