FROM ubuntu:12.04
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update
RUN apt-get install -y python-dev python-pip python-software-properties
RUN add-apt-repository -y ppa:nginx/stable
RUN apt-get update
RUN apt-get install -y nginx
RUN mkdir -p /var/cache/proxxy /var/log/proxxy

ADD . /proxxy
WORKDIR /proxxy
VOLUME ["/var/cache/proxxy"]

RUN pip install -r requirements.txt
RUN ./render.py > /proxxy/nginx.conf

CMD ["./start.sh"]

EXPOSE 80
