# Navidrome docker image with latest ffmpeg

This image contains the latest [Navidrome](https://www.navidrome.org/) and the latest ffmpeg on Debian.

Use `ishotihadus/navidrome:latest` or `ishotihadus/navidrome:v[navidrome version]-v[ffmpeg version]` (such as `ishotihadus/navidrome:v0.49.3-v6.0`).

In this image, the following audio codecs are supported:

- libfdk_aac
- libvorbis
- libmp3lame
- libopus

The recommended transcoding options are the following.

- `ffmpeg -i %s -map 0:0 -b:a %bk -v 0 -c:a libopus -f opus -`
- `ffmpeg -i %s -map 0:0 -b:a %bk -v 0 -f mp3 -`
- `ffmpeg -i %s -map 0:0 -b:a %bk -v 0 -c:a libfdk_aac -f adts -`
- `ffmpeg -i %s -map 0:0 -b:a %bk -v 0 -c:a libvorbis -f ogg -`
