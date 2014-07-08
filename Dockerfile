FROM ubuntu:12.04
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update
RUN apt-get install -y python-dev python-pip python-software-properties
RUN add-apt-repository -y ppa:nginx/stable
RUN apt-get update
RUN apt-get install -y nginx
RUN mkdir -p /var/cache/proxxy /var/log/proxxy

RUN mkdir /proxxy
WORKDIR /proxxy
ADD app/requirements.txt /proxxy/requirements.txt
RUN pip install -r requirements.txt
ADD app /proxxy
RUN ./render.py > /proxxy/nginx.conf

VOLUME ["/var/cache/proxxy", "/var/log/proxxy"]

CMD ["./start.sh"]

EXPOSE 80
