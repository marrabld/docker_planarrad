# Run Chrome in a container
#
# docker run -it \
#	--net host \ # may as well YOLO
#	--cpuset-cpus 0 \ # control the cpu
#	--memory 512mb \ # max memory it can use
#	-v /tmp/.X11-unix:/tmp/.X11-unix \ # mount the X11 socket
#	-e DISPLAY=unix$DISPLAY \
#	-v $HOME/Downloads:/home/chrome/Downloads \
#	-v $HOME/.config/google-chrome/:/data \ # if you want to save state
#	--security-opt seccomp=$HOME/chrome.json \
#	--device /dev/snd \ # so we have sound
#	-v /dev/shm:/dev/shm \
#	--name planarRad \
#	dan/planarRad

# Base docker image
FROM ubuntu:16.04
LABEL maintainer "Daniel Marrable  <marrabld+planarrad@gmail.com>"

ADD http://www.planarrad.com/downloads/planarrad_free_src_0.9.5beta_2015_07_17.tar.gz /src/planarrad_free_src_0.9.5beta_2015_07_17.tar.gz

RUN tar xfvz /src/planarrad_free_src_0.9.5beta_2015_07_17.tar.gz -C /src

# Install planarrad dependencies
RUN apt-get update && apt-get install -y \
        g++ libqt4-dev libsm-dev libjpeg-dev libboost-all-dev build-essential curl git python-scipy python-qt4 python-matplotlib python-seaborn

RUN useradd -ms /bin/bash planarrad

# USER planarrad
WORKDIR /home/planarrad

RUN mkdir -p /home/planarrad/.planarradpy/log/
RUN chown -R planarrad:planarrad /home/planarrad

RUN export INSTALL_DIR=/home/planarrad \
        &&  export JUDE2DIR=$INSTALL_DIR/jude2_install \
        && export LD_LIBRARY_PATH=$JUDE2DIR/lib:$LD_LIBRARY_PATH \
        && export PATH=$JUDE2DIR/bin:$PATH \
	&& echo $JUDE2DIR

# Compile the source doce
RUN     cd /src/planarrad_free_src_0.9.5beta_2015_07_17 \
        && /src/planarrad_free_src_0.9.5beta_2015_07_17/example_build

RUN git clone https://github.com/marrabld/planarradpy.git

USER root

# Cleanup
# RUN apt-get purge --auto-remove -y curl \
#	&& rm -rf /var/lib/apt/lists/* \

#RUN rm -rf /src/*.deb \
#    && rm -rf /src/planarrad_free_src_0.9.5beta_2015_07_17



RUN chown -R planarrad:planarrad /home/planarrad

USER planarrad

CMD [ "/bin/bash" ]