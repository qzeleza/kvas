#!/bin/sh

if [ "${1}" = 'start' ] ; then
	. /opt/apps/kvas/bin/libs/ndm

	# стартуем ipset'ы, используемые DNS-серверами
	# до старта самих DNS-серверов
	ip4__ipset__create_list
fi
