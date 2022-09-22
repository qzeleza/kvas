#!/usr/bin/env bats
source ../libs/main

ttt(){
	echo "${1}" | grep -q "ВКЛЮЧЕН" && {
#	run on_server "${vpn_lib_load} && ${cmd} "
	echo 432453454
	}
}
#================================================================
# 	Данный файл предназначен для тестирования самих тестов
#	Здесь пишутся сами тесты и затем переносятся в соотвествующие
#	файлы етосв с расширением bats
#================================================================
@test "Узнаем статус AdGuard Home и отключаем его, если нужно [cmd_adguardhome_off]" {
	cmd="cmd_adguardhome_status"
	run on_server "${vpn_lib_load} && ${cmd} "
# 	в случае ошибок в тесте - будет вывод основных критериев работы
#	print_on_error "${status}" "${output}"
	[ "${status}" -eq 0 ]
	set +e
	cmd="cmd_adguardhome_on"
	! echo "${output}" | grep -q "ОТКЛЮЧЕН"
	if [ $? = 1 ]; then echo '345344'; fi
}
@test "Узнаем статус AdGuard Home и отключаем его, если нужно [cmd_adguardhome_off]" {
	cmd="cmd_adguardhome_status"
	run on_server "${vpn_lib_load} && ${cmd} "
# 	в случае ошибок в тесте - будет вывод основных критериев работы
#	print_on_error "${status}" "${output}"
	[ "${status}" -eq 0 ]

	cmd="cmd_adguardhome_off"
	echo "${output}" | grep -q "ВКЛЮЧЕН" && {
		run on_server "${vpn_lib_load} && ${cmd} "
	}
}
@test "Узнаем статус AdGuard Home и отключаем его, если нужно [cmd_adguardhome_off]" {
	cmd="cmd_adguardhome_status"
	run on_server "${vpn_lib_load} && ${cmd} "
	set -e
# 	в случае ошибок в тесте - будет вывод основных критериев работы
	print_on_error "${status}" "${output}"
	echo "${output}" | grep -q "ВКЛЮЧЕН"
}