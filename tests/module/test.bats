#!/usr/bin/env bats
source ../libs/main

#================================================================
# 	Данный файл предназначен для тестирования самих тестов
#	Здесь пишутся сами тесты и затем переносятся в соотвествующие
#	файлы етосв с расширением bats
#================================================================

@test "Проверка установки периода обновления списка разблокировки без аргументов [cmd_set_period_update]" {

	cmd="cmd_set_period_update"
	run on_server "${vpn_lib_load} && ${cmd}"
	print_on_error "${status}" "${output}"
	[ "${status}" -eq 0 ]
	#	Блок проверок то, что точно должно быть при нормальной работе скрипта
	echo "${output}" | grep -q 'Периодичность обновления'
}

@test "Проверка установки периода обновления списка разблокировки с неверным аргументом [cmd_set_period_update]" {

	cmd="cmd_set_period_update 2aa"
	run on_server "${vpn_lib_load} && ${cmd}"
	print_on_error "${status}" "${output}"
	[ "${status}" -eq 0 ]
	#	Блок проверок то, что точно должно быть при нормальной работе скрипта
	echo "${output}" | grep -q 'Указан не верный формат периода'

}

@test "Проверка установки периода обновления списка разблокировки с двойным аргументом [cmd_set_period_update]" {

	cmd="cmd_set_period_update 12h"
	run on_server "${vpn_lib_load} && ${cmd}"
	print_on_error "${status}" "${output}"
	[ "${status}" -eq 0 ]
	#	Блок проверок то, что точно должно быть при нормальной работе скрипта
	echo "${output}" | grep -q 'Период обновления установлен на каждые'

}

#@test "Проверка работы генерации ipset блока в файле конфигурации dnsmasq [/kvas/bin/main/dnsmasq]" {
#	adh_file=/opt/apps/kvas/bin/main/dnsmasq
#	run on_server "${adh_file} && cat /opt/etc/kvas.dnsmasq"
## 	в случае ошибок в тесте - будет вывод основных критериев работы
#	print_on_error "${status}" "${output}"
#	[ "${status}" -eq 0 ]
#	ipset_num=$(echo "${output}" | grep -c "ipset")
#	unblock_num=$(echo "${output}" | grep -c "unblock")
#	[ "${ipset_num}" -gt 1 ] && [ "${ipset_num}" -ge "${unblock_num}" ]
#}
