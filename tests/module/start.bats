#!/usr/bin/env bats
source ../tests_lib

#-----------------------------------------------------
# 	ТЕСТЫ из библиотеки vpn
#-----------------------------------------------------
#echo "Проверка наличия всех необходимых файлов для прохождения тестов"
@test "Проверка наличия kvas_adblock" {
	run on_server "[ -f /opt/bin/kvas/adblock ] && exit 0 || exit 1"
# 	в случае ошибок в тесте - будет вывод основных критериев работы
	print_on_error "${status}" "${output}"
	[ "${status}" -eq 0 ]
}
@test "Проверка наличия kvas_adguard" {
	run on_server "[ -f /opt/bin/kvas/adguard ] && exit 0 || exit 1"
# 	в случае ошибок в тесте - будет вывод основных критериев работы
	print_on_error "${status}" "${output}"
	[ "${status}" -eq 0 ]
}
@test "Проверка наличия kvas_dnsmasq" {
	run on_server "[ -f /opt/bin/kvas/update/dnsmasq ] && exit 0 || exit 1"
# 	в случае ошибок в тесте - будет вывод основных критериев работы
	print_on_error "${status}" "${output}"
	[ "${status}" -eq 0 ]
}
@test "Проверка наличия kvas_ipset" {
	run on_server "[ -f /opt/bin/kvas/update/ipset ] && exit 0 || exit 1"
# 	в случае ошибок в тесте - будет вывод основных критериев работы
	print_on_error "${status}" "${output}"
	[ "${status}" -eq 0 ]
}
@test "Проверка наличия kvas_lib_vpn" {
	run on_server "[ -f /opt/bin/kvas/libs/vpn ] && exit 0 || exit 1"
# 	в случае ошибок в тесте - будет вывод основных критериев работы
	print_on_error "${status}" "${output}"
	[ "${status}" -eq 0 ]
}
@test "Проверка наличия kvas_lib_main" {
	run on_server "[ -f /opt/bin/kvas/libs/vpn ] && exit 0 || exit 1"
# 	в случае ошибок в тесте - будет вывод основных критериев работы
	print_on_error "${status}" "${output}"
	[ "${status}" -eq 0 ]
}
@test "Проверка наличия kvas_lib_debug" {
	run on_server "[ -f /opt/bin/kvas/libs/vpn ] && exit 0 || exit 1"
# 	в случае ошибок в тесте - будет вывод основных критериев работы
	print_on_error "${status}" "${output}"
	[ "${status}" -eq 0 ]
}
@test "Проверка наличия kvas_update" {
	run on_server "[ -f /opt/bin/kvas/update/update ] && exit 0 || exit 1"
# 	в случае ошибок в тесте - будет вывод основных критериев работы
	print_on_error "${status}" "${output}"
	[ "${status}" -eq 0 ]
}
