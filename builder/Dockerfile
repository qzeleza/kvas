
FROM	debian:11

ARG	DEBIAN_FRONTEND=noninteractive
ARG USER_NAME=
ARG BUILDING_PATH=/build/entware 
ARG APP_PATH=

RUN \
    apt-get update && \
    apt-get install -y \
    build-essential \
    ccache \
    curl \
    gawk \
    g++-multilib \
    gcc-multilib \
    genisoimage \
    git-core \
    gosu \
    libdw-dev \
    libelf-dev \
    libssl-dev \
    libncurses5-dev \
    locales \
    mc \
    jq \
    pv \
    nano \
    pwgen \
    python \
    python3 \
    python3-pip \
    qemu-utils \
    rsync \
    signify-openbsd \
    subversion \
    sudo \
    swig \
    unzip \
    iputils-ping \
    wget \ 
    zstd && \
    apt-get clean && \
    localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8 && \
    cp /usr/share/zoneinfo/Europe/Moscow /etc/localtime

RUN pip3 install -U pip
RUN pip3 install \
    pyelftools \
    pyOpenSSL \
    service_identity

ENV LANG=en_US.utf8

# RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
# RUN useradd -c "Пользователь для сборки образов Entware " -m -d /home/${USER_NAME} -G sudo -s /bin/bash ${USER_NAME}

# Создание группы и пользователя с корректными ID
RUN groupadd -g 1000 ${USER_NAME} && \
    useradd -u 1000 -g ${USER_NAME} -G sudo -m -s /bin/bash ${USER_NAME} && \
    echo "${USER_NAME} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Создание необходимых директорий и настройка прав
RUN mkdir -p ${BUILDING_PATH} ${APP_PATH} && \
    chown -R ${USER_NAME}:${USER_NAME} ${BUILDING_PATH} && \
    chown -R ${USER_NAME}:${USER_NAME} ${APP_PATH} && \
    chown -R ${USER_NAME}:${USER_NAME} /home/${USER_NAME} && \
    mkdir -p ${BUILDING_PATH} && \
    git clone https://github.com/Entware/Entware.git ${BUILDING_PATH} && \
    cd ${BUILDING_PATH} && \
    git fetch && \
    scripts/feeds update -a  && \
    scripts/feeds install -a && \
    cp -vf configs/aarch64-*.config .config && \
    make defconfig 

USER ${USER_NAME}
WORKDIR ${BUILDING_PATH}

RUN make -j12 toolchain/install || make -j1 V=sc toolchain/install


