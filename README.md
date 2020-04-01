# docker-kodi

Kodi running within a docker container.

This image allows running the latest version of Kodi in a sandbox.

A script is provided to ease launching.

## Launching

### Through the script

Just run the included script from an X-Window session and it should pick up valid values.

```
$ kodi-docker.mk
```

### Manually

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

## Local build

The script can also build the image locally if you prefer that over pulling it from Docker Hub:

```
./kodi-docker.mk build
```