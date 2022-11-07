---
title: 'hls-stream'

---

{{< code file="/files/docs/configurations/nginx/hls-stream.conf" language="nginx" download="true" >}}

```bash
docker run --detach --name nginx-hls-stream \
    --volume "${PWD}/hls-stream.conf:/etc/nginx/nginx.conf" \
    --publish "1935:1935" \
    --workdir "/usr/share/nginx/" \
    nginx
telnet localhost 1935
docker stop nginx-hls-stream
docker rm nginx-hls-stream
```

```bash
KEY='stream1'
streamlink --stdout --url "${VIDEO_URL}" --default-stream '720p,480p' | \
ffmpeg -re -i 'pipe:' -async 1 -vsync 1 \
    -c:v libx264 -c:a aac -b:v 1024k -b:a 128k -vf "scale=960:trunc(ow/a/2)*2" -tune zerolatency -preset veryfast -crf 23 -strict -2 -f flv "rtmp://localhost/show/${KEY}_high" \
    -c:v libx264 -c:a aac -b:v 768k -b:a 96k -vf "scale=720:trunc(ow/a/2)*2" -tune zerolatency -preset veryfast -crf 23 -strict -2 -f flv "rtmp://localhost/show/${KEY}_mid" \
    -c:v libx264 -c:a aac -b:v 256k -b:a 32k -vf "scale=480:trunc(ow/a/2)*2" -tune zerolatency -preset veryfast -crf 23 -strict -2 -f flv "rtmp://localhost/show/${KEY}_low" \
    -c:v libx264 -c:a aac -strict -2 -f flv "rtmp://localhost/show/${KEY}_src"
```
