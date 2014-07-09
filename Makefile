DOCKER_NAME = laggyluke/proxxy
PACKER_AWS_ACCOUNT_ID = 5868-8797-7111
PACKER_S3_BUCKET = gmiroshnykov-amis/proxxy

docker-build:
	docker build --tag $(DOCKER_NAME) .

docker-run:
	docker run --tty --interactive --rm --publish 80:80 $(DOCKER_NAME)

packer-build:
	cd packer; packer build \
		-var 's3_bucket=$(PACKER_S3_BUCKET)' \
		-var 'aws_account_id=$(PACKER_AWS_ACCOUNT_ID)' \
		template.json
