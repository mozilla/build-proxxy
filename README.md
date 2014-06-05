proxxy
======


Usage
-----

1. Modify `config.json` as needed.
If you're not using DNS, add proxy hosts to `/etc/hosts`.

2. Build a Docker image and give it some name, e.g. `laggyluke/proxxy`:

        docker build -t laggyluke/proxxy .

3. Run a Docker container based on that image:

        docker run --name proxxy -d -p 80:80 laggyluke/proxxy

4. Make few requests via proxxy, notice `X-Proxxy` header:

        $ curl -i http://ftp.mozilla.org.proxy/
        HTTP/1.1 200 OK
        Server: nginx/1.6.0
        Date: Wed, 04 Jun 2014 07:21:12 GMT
        Content-Type: text/html; charset=UTF-8
        Content-Length: 384
        Connection: keep-alive
        X-Backend-Server: ftp4.dmz.scl3.mozilla.com
        Cache-Control: max-age=300
        Expires: Wed, 04 Jun 2014 07:22:11 GMT
        Access-Control-Allow-Origin: *
        ETag: "4aac806-180-4f7d4142ca525"
        Last-Modified: Fri, 25 Apr 2014 01:42:30 GMT
        X-Cache-Info: cached
        X-Proxxy: MISS
        Accept-Ranges: bytes

        <html>
        <head>
        <title>ftp.mozilla.org / archive.mozilla.org / releases.mozilla.org</title>
        </head>
        <body>
        <p>ftp.mozilla.org / archive.mozilla.org :: files are <a href="http://ftp.mozilla.org/pub/">here</a>.</p>
        <p>releases.mozilla.org sends you to the CDN (origin is still ftp.mo), which will result in faster downloads, so use releases.mozilla.org when possible.</p>
        </body>
        </html>

        $ curl -i http://ftp.mozilla.org.proxy/
        HTTP/1.1 200 OK
        Server: nginx/1.6.0
        Date: Wed, 04 Jun 2014 07:21:15 GMT
        Content-Type: text/html; charset=UTF-8
        Content-Length: 384
        Connection: keep-alive
        X-Backend-Server: ftp4.dmz.scl3.mozilla.com
        Cache-Control: max-age=300
        Expires: Wed, 04 Jun 2014 07:22:11 GMT
        Access-Control-Allow-Origin: *
        ETag: "4aac806-180-4f7d4142ca525"
        Last-Modified: Fri, 25 Apr 2014 01:42:30 GMT
        X-Cache-Info: cached
        X-Proxxy: HIT
        Accept-Ranges: bytes

        <html>
        <head>
        <title>ftp.mozilla.org / archive.mozilla.org / releases.mozilla.org</title>
        </head>
        <body>
        <p>ftp.mozilla.org / archive.mozilla.org :: files are <a href="http://ftp.mozilla.org/pub/">here</a>.</p>
        <p>releases.mozilla.org sends you to the CDN (origin is still ftp.mo), which will result in faster downloads, so use releases.mozilla.org when possible.</p>
        </body>
        </html>

    Please disregard `X-Cache-Info` header as it is provided by upstream server.

5. See the logs:

        docker logs proxxy
