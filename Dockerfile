FROM ubuntu:20.04

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get upgrade && apt-get install -y tzdata 
RUN apt-get install locales && apt-get install -y language-pack-ru

RUN echo "Europe/Moscow" > /etc/timezone && \
    dpkg-reconfigure -f noninteractive tzdata && \
    sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    sed -i -e 's/# ru_RU.UTF-8 UTF-8/ru_RU.UTF-8 UTF-8/' /etc/locale.gen && \
    echo 'LANG="ru_RU.UTF-8"'>/etc/default/locale && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=ru_RU.UTF-8

ENV LANG ru_RU.UTF-8
ENV LANGUAGE ru_RU.UTF-8
ENV LC_ALL ru_RU.UTF-8

RUN apt-get install -y \
 xfce4 \
 xfce4-clipman-plugin \
 xfce4-cpugraph-plugin \
 xfce4-netload-plugin \
 xfce4-screenshooter \
 xfce4-taskmanager \
 xfce4-terminal \
 xfce4-xkb-plugin 

RUN apt-get install -y \
 sudo \
 wget \
 xorgxrdp \
 xrdp && \
 apt remove -y light-locker xscreensaver && \
 apt autoremove -y && \
 rm -rf /var/cache/apt /var/lib/apt/lists

COPY ./build/ubuntu-run.sh /usr/bin/
RUN mv /usr/bin/ubuntu-run.sh /usr/bin/run.sh
RUN chmod +x /usr/bin/run.sh

RUN mkdir /var/run/dbus && \
 cp /etc/X11/xrdp/xorg.conf /etc/X11 && \
 sed -i "s/console/anybody/g" /etc/X11/Xwrapper.config && \
 sed -i "s/xrdp\/xorg/xorg/g" /etc/xrdp/sesman.ini && \
 echo "xfce4-session" >> /etc/skel/.Xsession

EXPOSE 3389
EXPOSE 22

ENTRYPOINT ["/usr/bin/run.sh"]