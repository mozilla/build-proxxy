FROM ubuntu:14.04
ENV DEBIAN_FRONTEND noninteractive

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys C300EE8C
ADD ./sources.list /etc/apt/sources.list.d/nginx.list
RUN apt-get update
RUN apt-get install -y nginx

ADD ./sysctl.conf /etc/sysctl.d/60-proxxy.conf

RUN mkdir -p /var/cache/proxxy /var/log/proxxy
ADD . /proxxy
WORKDIR /proxxy

VOLUME ["/var/cache/proxxy", "/var/log/proxxy"]

CMD ["./start.sh"]

EXPOSE 80
