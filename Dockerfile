FROM ubuntu:22.04
 
ARG USER="${USER}"
ARG UID="${UID}"
ARG GID="${GID}"
ARG GROUP="${GROUP}"
ARG APP_NAME="${APP_NAME}"
ARG APPS_ROOT="${APPS_ROOT}"
ARG APP_PATH_NAME_TO_MAKE="${APP_PATH_NAME_TO_MAKE}"


ENV LANG en_US.utf8

RUN chmod 1777 /tmp \
    && dpkg --add-architecture i386  \
    && groupadd --gid ${GID} ${USER}  \
    && useradd --create-home --uid ${UID} --gid ${GID} --shell /bin/bash ${USER}  \
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

COPY . ${APPS_ROOT}/${APP_NAME}/

WORKDIR ${APPS_ROOT}
RUN rm -rf /var/lib/apt/lists/* \
    && git clone https://github.com/Entware/Entware.git  \
    && mv Entware/ entware/ && cd ${APPS_ROOT}/entware  \
    && make package/symlinks  \
    && cp `ls /${APPS_ROOT}/entware/configs/mipsel-*` .config \
    && mkdir -p /${APPS_ROOT}/entware/package/utils/${APP_NAME}/ \
    && if [ -n ${APP_PATH_NAME_TO_MAKE} ]; then \
        ln -s ${APPS_ROOT}/${APP_NAME}/${APP_PATH_NAME_TO_MAKE} /${APPS_ROOT}/entware/package/utils/${APP_NAME}/;\
        mv /${APPS_ROOT}/entware/package/utils/${APP_NAME}/opt /${APPS_ROOT}/entware/package/utils/${APP_NAME}/files;\
    else\
            ln -s ${APPS_ROOT}/${APP_NAME} ${APPS_ROOT}/entware/package/utils/${APP_NAME}/;\
            mv ${APPS_ROOT}/entware/package/utils/${APP_NAME} ${APPS_ROOT}/entware/package/utils/${APP_NAME}/files;\
    fi
RUN chown -R ${USER}:${GROUP} ${APPS_ROOT}/entware ${APPS_ROOT}/${APP_NAME} \
    && chmod -R +x ${APPS_ROOT}/${APP_NAME}/build/*.run \
    && git clone https://github.com/bats-core/bats-core.git \
    && cd bats-core \
    && ./install.sh /usr/local \
    && cd .. && rm -rf ./bats-core

WORKDIR ${APPS_ROOT}/${APP_NAME}/
RUN ${APPS_ROOT}/${APP_NAME}/build/Makefile.build

USER ${USER}
RUN ssh-keygen -t rsa -N "" -f ~/.ssh/id_rsa \
    && ${APPS_ROOT}/${APP_NAME}/build/firstrun.build



