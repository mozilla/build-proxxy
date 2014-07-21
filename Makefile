docker-build:
	docker build --tag proxxy ./app

docker-run:
	docker run --tty --interactive --rm --publish 80:80 proxxy

packer-build:
	cd packer; packer build template.json

packer-build-use1:
	cd packer; packer build -only proxxy-use1 template.json

packer-build-usw2:
	cd packer; packer build -only proxxy-usw2 template.json
