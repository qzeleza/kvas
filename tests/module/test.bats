#!/usr/bin/env bats
source ../tests_lib
#================================================================
# 	Данный файл предназначен для тестирования самих тестов
#	Здесь пишутся сами тесты и затем переносятся в соотвествующие
#	файлы етосв с расширением bats
#================================================================

lib_load=". /opt/bin/kvas/libs/vpn"

@test "Проверка отключения сервиса AdGuardHome [cmd_adguardhome_off]" {
	cmd="cmd_adguardhome_off "
	run on_server "${lib_load} && ${cmd} " <<< y
	print_on_error "${status}" "${output}"

	[ "${status}" -eq 0 ]
	echo "${output}" | grep -q "УСПЕШНО"

}
@test "Проверка включения сервиса AdGuardHome [cmd_adguardhome_on]" {
	cmd="cmd_adguardhome_on "
	run on_server "${lib_load} && ${cmd} "
	print_on_error "${status}" "${output}"

	[ "${status}" -eq 0 ]
	echo "${output}" | grep -q "УСПЕШНО"

}
@test "Проверка статуса сервиса AdGuardHome [cmd_adguardhome_status]" {
	cmd="cmd_adguardhome_status "
	run on_server "${lib_load} && ${cmd} "
	print_on_error "${status}" "${output}"

	[ "${status}" -eq 0 ]
	echo "${output}" | grep -q "ВКЛЮЧЕН"

}
