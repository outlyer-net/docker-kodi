# docker-kodi

Kodi running within a docker container.

This image allows running the latest version of Kodi in a sandbox.

A script is provided to ease launching.

[![Docker Pulls](https://img.shields.io/docker/pulls/outlyernet/kodi.svg)][dockerhub]
[![Image Size](https://images.microbadger.com/badges/image/outlyernet/kodi.svg)][microbadger]

## Information

**PLEASE NOTE** this is a work-in-progress, it will probably not work completely and properly yet

* [Docker Hub][dockerhub]
* [Github][github]

## Launching through the included script

Just run the included script from an X-Window session and it should pick up valid values.

```
$ kodi-docker.mk
```

## Launching manually

Kodi will need to pick up at the very least:
- The X11 socket (`/tmp/.X11-unix/`)
- The `DISPLAY` environment variable
- The sound device (e.g. `/dev/snd/`)

Additionally you probably want it to have to correct timezone so that times are displayed properly (`/etc/localtime`).

That's what the script will pass by default, here is an equivalent command line:

```
$ docker run --rm -it \
	    -v /tmp/.X11-unix/:/tmp/.X11-unix/:ro \
		-v /etc/localtime:/etc/localtime:ro \
    	-e DISPLAY \
    	--device /dev/snd \
    	outlyernet/kodi
```

### Persisting configuration and installed plugins

You probably want status to persist between runs, mounting a Docker volume on `/root/.kodi` will achieve that, i.e.:

```
$ docker run --rm -it \
	    -v /tmp/.X11-unix/:/tmp/.X11-unix/:ro \
		-v /etc/localtime:/etc/localtime:ro \
        -v kodi_data:/root/.kodi \`
    	-e DISPLAY \
    	--device /dev/snd \
    	outlyernet/kodi
```

(NOTE that Docker will create the volume if it didn't exist)

### Enabling hardware accelerated decoding

To enable hardware decoding of video, pass the DRI device to the container:

```
... --device /dev/dri
```

### Accessing local media

To access local media you'll have to mount the appropriate directories with additional `-v ...` arguments.

The included script mounts the home directory (read-only) of the user launching it, but doesn't try to guess any other mount points.\
It is mounted in `/root/<username>-home`, so that within Kodi it's easily reachable as "*Home folder*" → "*&lt;username&gt;-home*".

## Local build

The script can also build the image locally if you prefer that over pulling it from Docker Hub:

```
./kodi-docker.mk build
```


[dockerhub]: https://hub.docker.com/r/outlyernet/kodi/
[github]: https://github.com/outlyer-net/docker-kodi
[microbadger]: https://microbadger.com/images/outlyernet/kodi
