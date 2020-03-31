#!/usr/bin/make -f

TAG=latest
IMAGE_NAME=outlyernet/docker-kodi:$(TAG)
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
    	$(IMAGE_NAME)

build:
	docker build -t $(IMAGE_NAME) .
