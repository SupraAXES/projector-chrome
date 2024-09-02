FROM ubuntu:23.10

LABEL maintainer="supra"
LABEL qa-date="20240715"

RUN apt update && apt install -y --no-install-recommends \
    apt-utils \
    && DEBIAN_FRONTEND=noninteractive apt --reinstall install -y --no-install-recommends \
    apt-utils \
    && DEBIAN_FRONTEND=noninteractive apt install -y --no-install-recommends \
    binutils \
    ca-certificates \
    software-properties-common \
    file \
    curl \
    gnupg2 \
    netcat-openbsd \
    net-tools \
    && rm -rf /var/lib/apt/lists/*


# apt conf generation
COPY apt /etc/apt
RUN apt update && DEBIAN_FRONTEND=noninteractive apt full-upgrade -y \
    && rm -rf /var/lib/apt/lists/*


# add user supra
RUN adduser --disabled-password --gecos "" --uid 1711 supra


# base requiremnts
RUN apt update && DEBIAN_FRONTEND=noninteractive apt install -y --no-install-recommends \
    openbox \
    picom \
    feh \
    xserver-xorg-video-all \
    x11-utils \
    x11-xserver-utils \
    x11-xkb-utils \
    xprintidle \
    xdotool \
    xcvt \
    wmctrl \
    tigervnc-standalone-server \
    libgtk-3-bin \
    locales-all \
    bsdmainutils \
    libglu1-mesa \
    ffmpeg \
    yaru-theme-gtk \
    mesa-utils \
    xdg-user-dirs \
    xdg-user-dirs-gtk \
    google-chrome-stable \
    && rm -rf /var/lib/apt/lists/*

# language support, zh-cn
#RUN apt update && DEBIAN_FRONTEND=noninteractive apt install -y --no-install-recommends \
#    fonts-lyx \
#    latex-cjk-chinese \
#    language-pack-zh* \
#    fonts-noto* \
#    fonts-symbola \
#    && rm -rf /var/lib/apt/lists/*


# audio
RUN apt update && DEBIAN_FRONTEND=noninteractive apt install -y --no-install-recommends \
    pulseaudio \
    && rm -rf /var/lib/apt/lists/*

# confs
COPY pulse/default.pa /etc/pulse/default.pa


COPY supra supra


ENV PATH=/supra/bin:$PATH
ENV XDG_CONFIG_DIRS=/etc/xdg/xdg-ubuntu:/etc/xdg
ENV XDG_CURRENT_DESKTOP=ubuntu:GNOME
ENV XDG_DATA_DIRS=/usr/share/ubuntu:/usr/share/gnome:/usr/local/share/:/usr/share/
ENV XDG_MENU_PREFIX=gnome-
ENV XDG_SESSION_CLASS=user
ENV XDG_SESSION_DESKTOP=ubuntu
ENV XDG_SESSION_TYPE=x11


# entry for docker built-in tini
CMD ["entry.sh"]
