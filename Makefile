docker-build:
	docker build --tag proxxy ./app

docker-run:
	docker run --tty --interactive --rm --publish 80:80 proxxy

packer-build:
	cd packer; packer build template.json
