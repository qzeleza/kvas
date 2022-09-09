FROM ubuntu

ARG NAME="${NAME}"
ARG UID="${UID}"
ARG GID="${GID}"

RUN groupadd --gid ${GID} ${NAME} && \
    useradd --no-create-home --uid ${UID} --gid ${GID} --shell /bin/bash ${NAME} && \
    apt-get update && apt-get install -y locales && rm -rf /var/lib/apt/lists/* \
	&& localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8 && \
    dpkg --add-architecture i386
ENV LANG en_US.utf8


RUN apt-get install -y \
    libc6:i386 libncurses5:i386 libstdc++6:i386 \
    # ubuntu
    build-essential subversion libncurses5-dev zlib1g-dev gawk  \
    gcc-multilib flex git-core gettext libssl-dev


#   Основные пакеты по учебнику
#    python-dev python-distutils-extra \
#    python3 python3-distutils-extra  \
#    python3-dev python3-setuptools bash binutils bzip2 \
#    flex git-core g++ gcc util-linux gawk \
#    help2man intltool libelf-dev zlib1g-dev make libncurses5-dev libssl-dev patch \
#    perl-modules unzip wget gettext xsltproc zlib1g-dev \
#    \
#    libboost-dev libxml-parser-perl libusb-dev bin86 bcc sharutils \
#    build-essential ccache ecj fastjar file gawk gcc-multilib \
#    gettext git java-propose-classpath libelf-dev libncurses5-dev \
#    libncursesw5-dev libssl-dev  unzip wget rsync subversion \
#    swig time xsltproc zlib1g-dev

#RUN apt-get install -y curl golang python

RUN rm -rf /var/lib/apt/lists/* && \
    mkdir -p /apps/kvas/ && cd /apps && \
    git clone https://github.com/Entware/Entware.git && \
    mv Entware/ entware/ && cd /apps/entware && \
    make package/symlinks && \
    cp `ls /apps/entware/configs/mipsel-*` .config

#RUN mkdir /upload/ && wget -P /upload/ https://go.dev/dl/go1.19.linux-arm64.tar.gz
#RUN tar -C /usr/local -xzf /upload/go1.19.linux-arm64.tar.gz && \
#    export PATH=$PATH:/usr/local/go/bin && \
#    go install github.com/go-bootstrap/go-bootstrap@latest && \
##    $GOPATH/bin/go-bootstrap -dir github.com/{git-user}/{project-name} -template {core|postgresql|mysql} && \
#    GOROOT_BOOTSTRAP=/usr/local/go && \
#    rm -r /upload/

COPY . /apps/kvas/
#RUN chown -R ${UID}:${GID} /apps && \
#    chmod -R +x /apps/kvas/build/*.run && \
#    mkdir -p /apps/entware/package/utils/kvas/files/opt/
COPY ./opt/. /apps/entware/package/utils/kvas/files/opt/

WORKDIR /apps/entware
RUN /apps/kvas/build/make_Makefile.run

USER ${NAME}
RUN /apps/kvas/build/make_app.run

# apt-cache search

