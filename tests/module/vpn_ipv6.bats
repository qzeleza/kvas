#!/usr/bin/env bats
source ../libs/main

#-----------------------------------------------------
# 	ТЕСТЫ из библиотеки vpn ОБЩИЕ
#-----------------------------------------------------


@test "Проверка наличия файла справки [cmd_help]" {
	cmd="cmd_help"
	run on_server "${vpn_lib_load} && ${cmd} "
	print_on_error "${status}" "${output}"

	[ "${status}" -eq 0 ]

	#	Блок проверок то, что точно должно быть при нормальной работе скрипта
	[ "$(echo "${output}" | grep -c "")" -gt 1 ]

}

@test "Проверка верности получения данных по заданному интерфейсу [get_value_interface_field]" {
	cmd="get_value_interface_field Wireguard0 connected"
	run on_server "${vpn_lib_load} && ${cmd} "
	print_on_error "${status}" "${output}"

	[ "${status}" -eq 0 ]

	#	Блок проверок то, что точно должно быть при нормальной работе скрипта
	echo "${output}" | grep -qE "(no|yes)"

}
@test "Проверка получения интерфейса по умолчанию через который идут в интернет [get_defaultgw_interface]" {
	cmd="get_defaultgw_interface"
	run on_server "${vpn_lib_load} && ${cmd} "
	print_on_error "${status}" "${output}"

	[ "${status}" -eq 0 ]

	#	Блок проверок то, что точно должно быть при нормальной работе скрипта
	[ -n "${output}" ]
}


@test "Проверка исполнения команды по подключению IPv6 интерфейса [ipv6_inface_on]" {
	cmd="ipv6_inface_on ${TEST_IPv6_INTERFACE}"
	run on_server "${vpn_lib_load} && ${cmd} "
	print_on_error "${status}" "${output}"

	[ "${status}" -eq 0 ]

	#	Блок проверок то, что точно должно быть при нормальной работе скрипта
	echo "${output}" | grep -q "УСПЕШНО"

}

@test "Проверка исполнения команды по отключению IPv6 интерфейса [ipv6_inface_off]" {
	cmd="ipv6_inface_off ${TEST_IPv6_INTERFACE}"
	run on_server "${vpn_lib_load} && ${cmd} "
	print_on_error "${status}" "${output}"

	[ "${status}" -eq 0 ]

	#	Блок проверок то, что точно должно быть при нормальной работе скрипта
	echo "${output}" | grep -q "УСПЕШНО"

}

@test "Проверка статуса IPv6 интерфейса: ON [ipv6_inface_on]" {
	cmd="ipv6_inface_on ${TEST_IPv6_INTERFACE}"
	run on_server "${vpn_lib_load} && ${cmd} "
	print_on_error "${status}" "${output}"
	[ "${status}" -eq 0 ]
	cmd="ipv6_status ${TEST_IPv6_INTERFACE}"
	run on_server "${vpn_lib_load} && ${cmd}"
	print_on_error "${status}" "${output}"
	#	Блок проверок то, что точно должно быть при нормальной работе скрипта
	echo "${output}" | grep -q "1"
}

@test "Проверка статуса IPv6 интерфейса: OFF [ipv6_inface_on]" {

	cmd="ipv6_inface_off ${TEST_IPv6_INTERFACE}"
	run on_server "${vpn_lib_load} && ${cmd} "
	print_on_error "${status}" "${output}"
	[ "${status}" -eq 0 ]

	cmd="ipv6_status ${TEST_IPv6_INTERFACE}"
	run on_server "${vpn_lib_load} && ${cmd}"
	print_on_error "${status}" "${output}"
	#	Блок проверок то, что точно должно быть при нормальной работе скрипта
	echo "${output}" | grep -q "1"

}

@test "Проверка статуса IPv6 интерфейса: НЕ СОВМЕСТИМ [ipv6_inface_on]" {

	cmd="ipv6_inface_off ${TEST_NoN_IPv6_INTERFACE}"
	run on_server "${vpn_lib_load} && ${cmd} "
	print_on_error "${status}" "${output}"
	[ "${status}" -eq 0 ]

	cmd="ipv6_status ${TEST_NoN_IPv6_INTERFACE}"
	run on_server "${vpn_lib_load} && ${cmd}"
	print_on_error "${status}" "${output}"
	#	Блок проверок то, что точно должно быть при нормальной работе скрипта
	echo "${output}" | grep -qE "1|2"

}
@test "Проверка статуса IPv6 интерфейса: НЕ ЗАДАН ИНТЕРФЕЙС [ipv6_inface_on]" {

	cmd="ipv6_status"
	run on_server "${vpn_lib_load} && ${cmd}"
	print_on_error "${status}" "${output}"
	#	Блок проверок то, что точно должно быть при нормальной работе скрипта
	echo "${output}" | grep -q "Не задан интерфейс"

}

@test "Проверка наличия интерфейса ${TEST_EXIST_INTERFACE} CLI в системе [is_cli_inface_present]" {
	cmd="is_cli_inface_present ${TEST_EXIST_INTERFACE}"
	run on_server "${vpn_lib_load} && ${cmd} "
	print_on_error "${status}" "${output}"

	[ "${status}" -eq 0 ]

}
@test "Проверка отсутствия интерфейса ${TEST_NOT_EXIST_INTERFACE} CLI в системе [is_cli_inface_present]" {
	cmd="is_cli_inface_present ${TEST_NOT_EXIST_INTERFACE}"
	run on_server "${vpn_lib_load} && ${cmd} "
	print_on_error "${status}" "${output}"

	[ "${status}" -eq 1 ]

}
@test "Проверка отсутствия интерфейса в качестве аргумента [is_cli_inface_present]" {
	cmd="is_cli_inface_present"
	run on_server "${vpn_lib_load} && ${cmd}"
	print_on_error "${status}" "${output}"

	[ "${status}" -eq 0 ]
	echo "${output}" | grep -q "Не задан интерфейс"

}

@test "Проверка включения IPv6 на существующем интерфейсе ${TEST_NOT_EXIST_INTERFACE} CLI в системе [ipv6_inface_status]" {
	cmd="ipv6_inface_on ${TEST_NOT_EXIST_INTERFACE}"
	run on_server "${vpn_lib_load} && ${cmd} "
	print_on_error "${status}" "${output}"

	[ "${status}" -eq 0 ]

	cmd="ipv6_inface_status ${TEST_NOT_EXIST_INTERFACE}"
	run on_server "${vpn_lib_load} && ${cmd} "
	print_on_error "${status}" "${output}"

	echo "${output}" | grep -q "ПОДКЛЮЧЕН"

}
@test "Проверка отключения IPv6 на существующем интерфейсе ${TEST_EXIST_INTERFACE} CLI в системе [ipv6_inface_status]" {
	cmd="ipv6_inface_off ${TEST_EXIST_INTERFACE}"
	run on_server "${vpn_lib_load} && ${cmd} "
	print_on_error "${status}" "${output}"

	[ "${status}" -eq 0 ]

	cmd="ipv6_inface_status ${TEST_EXIST_INTERFACE}"
	run on_server "${vpn_lib_load} && ${cmd} "
	print_on_error "${status}" "${output}"

	echo "${output}" | grep -q "ОТКЛЮЧЕН"

}
@test "Проверка подключения IPV6 на интефейсе без поддержки IPV6 ${TEST_NoN_IPv6_INTERFACE} [ipv6_inface_status]" {
	cmd="ipv6_inface_status ${TEST_NoN_IPv6_INTERFACE}"
	run on_server "${vpn_lib_load} && ${cmd} "
	print_on_error "${status}" "${output}"

	echo "${output}" | grep -q "НЕ ВОЗМОЖЕН"

}

@test "Проверка наличия несуществующего интерфейса ${TEST_NOT_EXIST_INTERFACE} CLI в системе [ipv6_inface_status]" {
	cmd="ipv6_inface_status ${TEST_NOT_EXIST_INTERFACE}"
	run on_server "${vpn_lib_load} && ${cmd} "
	print_on_error "${status}" "${output}"

	echo "${output}" | grep -q "не существует"

}
