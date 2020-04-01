#!/usr/bin/make -f

TAG=latest
IMAGE_NAME=outlyernet/kodi
VOLUME_NAME=kodi

launch:
	@#	--user $(shell id -u):$(shell id -g) \ 
	@#	-v /etc/passwd:/etc/passwd:ro \ 
	exec docker run --rm -it \
	    -v /tmp/.X11-unix/:/tmp/.X11-unix/:ro \
		-v /etc/localtime:/etc/localtime:ro \
		-v $(VOLUME_NAME):/root/.kodi \
    	-e DISPLAY \
    	--device /dev/snd \
    	$(IMAGE_NAME):$(TAG)

build:
	docker build -t $(IMAGE_NAME):$(TAG) .

tag: build
	@echo 'Trying to tag with the appropriate version'
	@# Tag names cannot contain plus signs
	docker tag $(IMAGE_NAME):$(TAG) $(IMAGE_NAME):$(shell docker run --rm \
				--entrypoint /usr/bin/dpkg-query \
				$(IMAGE_NAME) \
				-f='$${Version}' -W kodi \
				| cut -d: -f2- \
				| sed 's/+/-/g')