#!/usr/bin/make -f

TAG=latest
IMAGE_NAME=outlyernet/kodi
VOLUME_NAME=kodi

launch:
	@# Possibly useful additional arguments
	@#	--user $(shell id -u):$(shell id -g) \ 
	@#	-v /etc/passwd:/etc/passwd:ro \ 
	exec docker run --rm -it \
	    -v /tmp/.X11-unix/:/tmp/.X11-unix/:ro \
		-v /etc/localtime:/etc/localtime:ro \
		-v $(VOLUME_NAME):/root/.kodi \
		-v $(HOME):/root/$(shell id -un)-home:ro \
		-e DISPLAY \
		--device /dev/snd \
		--device /dev/dri \
		$(IMAGE_NAME):$(TAG)

build:
	docker build -t $(IMAGE_NAME):$(TAG) .

tag: # build # No longer depends on build so that the pulled version can be tagged
	@echo 'Trying to tag with the appropriate version'
	@# The full package version
	@# (Tag names cannot contain plus signs)
	docker tag $(IMAGE_NAME):$(TAG) $(IMAGE_NAME):$(shell docker run --rm \
				--entrypoint /usr/bin/dpkg-query \
				$(IMAGE_NAME) \
				-f='$${Version}' -W kodi \
				| cut -d: -f2- \
				| sed 's/+/-/g')
	@# Major/Minor version
	docker tag $(IMAGE_NAME):$(TAG) $(IMAGE_NAME):$(shell docker run --rm \
				--entrypoint /usr/bin/dpkg-query \
				$(IMAGE_NAME) \
				-f='$${Version}' -W kodi \
				| cut -d: -f2- \
				| cut -d+ -f1 )
	@# Major version
	docker tag $(IMAGE_NAME):$(TAG) $(IMAGE_NAME):$(shell docker run --rm \
				--entrypoint /usr/bin/dpkg-query \
				$(IMAGE_NAME) \
				-f='$${Version}' -W kodi \
				| cut -d: -f2 \
				| cut -d. -f1 )
	@# Tag with (known) codename
	case $(shell docker run --rm \
				--entrypoint /usr/bin/dpkg-query \
				$(IMAGE_NAME) \
				-f='$${Version}' -W kodi \
				| cut -d: -f2- \
				| cut -d. -f1 ) \
	in \
		16) docker tag $(IMAGE_NAME):$(TAG) $(IMAGE_NAME):jarvis ;;\
		17) docker tag $(IMAGE_NAME):$(TAG) $(IMAGE_NAME):krypton ;;\
		18) docker tag $(IMAGE_NAME):$(TAG) $(IMAGE_NAME):leia ;;\
		19) docker tag $(IMAGE_NAME):$(TAG) $(IMAGE_NAME):matrix ;;\
	esac

# Helper rule to build older versions without overwriting :latest
build-tag-%:
	docker build -t $(IMAGE_NAME):$* .

# Launch a shell within a container, helpful for testing changes
shell:
	exec docker run --rm -it \
	    -v /tmp/.X11-unix/:/tmp/.X11-unix/:ro \
		-v /etc/localtime:/etc/localtime:ro \
		-v $(VOLUME_NAME):/root/.kodi \
		-v $(HOME):/root/$(shell id -un)-home:ro \
		-e DISPLAY \
		--device /dev/snd \
		--device /dev/dri \
		--entrypoint /bin/bash \
		$(IMAGE_NAME):$(TAG)
