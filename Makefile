DOCKER_NAME = mozilla-releng/proxxy

docker-build:
	docker build --tag $(DOCKER_NAME) .

docker-run:
	docker run --tty --interactive --rm --publish 80:80 $(DOCKER_NAME)

packer-build:
	cd packer; packer build template.json
