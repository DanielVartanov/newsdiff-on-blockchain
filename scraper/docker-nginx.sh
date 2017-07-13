#!/bin/bash
docker run -v /opt/docker/newsdiff/:/usr/share/nginx/html -p 8080:80 -d nginx
