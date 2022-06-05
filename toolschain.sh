#!/bin/bash

ROOT_TOOLS=${1}
if ! [ -d "${ROOT_TOOLS}" ]; then mkdir -p "${ROOT_TOOLS}"; fi
cd "${ROOT_TOOLS}" && cd .. || exit
rm -rf "${ROOT_TOOLS}"
apt update && apt upgrade -y
apt install build-essential gawk gcc-multilib flex git \
			gettext libncurses5-dev libssl-dev \
			python3-distutils zlib1g-dev \
			g++-multilib p7zip-full

# set en_US.UTF-8 locale
if [ -z "${LC_CTYPE}" ]; then
	export LC_CTYPE=en_US.UTF-8
	export LC_ALL=en_US.UTF-8
	dpkg-reconfigure locales
fi

git clone https://github.com/Entware/Entware.git && mv ./Entware ./entware && cd ./entware || exit
#echo 'src-git keendev3x https://github.com/The-BB/keendev-3x.git' >> ./feeds.conf

make package/symlinks
cp "$(ls "${ROOT_TOOLS}"/configs/mipsel-*)" .config

