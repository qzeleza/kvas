#!/usr/bin/env bats
source ../tests_lib
#================================================================
# 	Данный файл предназначен для тестирования самих тестов
#	Здесь пишутся сами тесты и затем переносятся в соотвествующие
#	файлы етосв с расширением bats
#================================================================

lib_load=". /opt/bin/kvas_lib_vpn"
dnsmasq_conf='/opt/etc/dnsmasq_conf.conf'

@test "Проверка установки сервиса AdGuardHome [adguardhome_setup]" {
	cmd="adguardhome_setup "
	run on_server "${lib_load} && ${cmd} "
	print_on_error "${status}" "${output}"

	[ "${status}" -eq 0 ]

	cmd="ipv6_inface_status ${TEST_EXIST_INTERFACE}"
	run on_server "${lib_load} && ${cmd} "
	print_on_error "${status}" "${output}"

	echo "${output}" | grep -q "ПОДКЛЮЧЕН"

}
