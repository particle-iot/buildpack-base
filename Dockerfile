FROM ubuntu:vivid

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update
RUN apt-get -y install git

ADD . /
VOLUME ["/input", "/ouput", "/cache"]
CMD ["/scripts/run.sh"]
