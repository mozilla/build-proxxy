proxxy
======


Usage
-----

1. Copy `config.example.json` to `config.json` and modify it as needed.
2. Build a Docker image and give it some name, e.g. `laggyluke/proxxy`:

        docker build -t laggyluke/proxxy .

3. Run a Docker container based on that image:

        docker run --name proxxy -d -p 80:80 laggyluke/proxxy

4. Make a request via proxxy:

        curl http://localhost/ftp.mozilla.org

5. See the logs:

        docker logs proxxy
