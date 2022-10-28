#!/usr/bin/env bats
source ../libs/main

#-----------------------------------------------------
# 	ТЕСТЫ из библиотеки vpn
#-----------------------------------------------------
#echo "Проверка наличия всех необходимых файлов для прохождения тестов"
@test "Проверка работы очищения всех созданных ipset таблиц [ip4_flush_all_tables]" {
	cmd="ip4_flush_all_tables"
	run on_server "${ndm_lib_load} && ${cmd} "
	print_on_error "${status}" "${output}"

	[ "${status}" -eq 0 ]

	#	Блок проверок то, что точно должно быть при нормальной работе скрипта
	! echo "${output}" | grep -q "Возникла ошибка"
}
@test "Проверка работы удаления всех правил iptables для VPN [ip4_firewall_flush_all_rules]" {
	cmd="ip4_firewall_flush_all_rules"
	run on_server "${ndm_lib_load} && ${cmd} "
	print_on_error "${status}" "${output}"

	[ "${status}" -eq 0 ]

	#	Блок проверок то, что точно должно быть при нормальной работе скрипта
	! echo "${output}" | grep -q "Возникла ошибка"
}
