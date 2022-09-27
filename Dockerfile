FROM ubuntu:22.04
 
ARG NAME="${NAME}"
ARG UID="${UID}"
ARG GID="${GID}"
ARG GROUP="${GROUP}"

ENV LANG en_US.utf8

RUN chmod 1777 /tmp \
    && dpkg --add-architecture i386  \
    && groupadd --gid ${GID} ${NAME}  \
    && useradd --create-home --uid ${UID} --gid ${GID} --shell /bin/bash ${NAME}  \
    && apt-get update \
    && apt-get install -y locales && rm -rf /var/lib/apt/lists/* \
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8 \
    && apt-get update \
    && apt-get install -y \
    libc6:i386 libncurses5:i386 libstdc++6:i386 \
    build-essential subversion libncurses5-dev zlib1g-dev gawk  \
    gcc-multilib flex git-core gettext libssl-dev \
    rsync unzip wget file nano \
    python2 python3 python3-dev python3-distutils-extra

COPY . /apps/kvas/

WORKDIR /apps
RUN rm -rf /var/lib/apt/lists/* \
    && git clone https://github.com/Entware/Entware.git  \
    && mv Entware/ entware/ && cd /apps/entware  \
    && make package/symlinks  \
    && cp `ls /apps/entware/configs/mipsel-*` .config \
    && chown -R ${NAME}:${GROUP} /apps/entware /apps/kvas \
    && chmod -R +x /apps/kvas/build/*.run \
    && mkdir -p /apps/entware/package/utils/kvas/opt/

COPY ./opt/. /apps/entware/package/utils/kvas/opt/

RUN /apps/kvas/build/Makefile.build
USER ${NAME}
RUN /apps/kvas/build/firstrun.build

WORKDIR /apps/kvas/


