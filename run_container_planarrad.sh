#!/bin/bash

docker run -it --net host --cpuset-cpus 0 -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=unix$DISPLAY -v $HOME:$HOME marrabld/planarrad # --name  planarrad planarrad
