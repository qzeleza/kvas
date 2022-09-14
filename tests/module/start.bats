#!/usr/bin/env bats
source ../libs/main

#-----------------------------------------------------
# 	ТЕСТЫ из библиотеки vpn
#-----------------------------------------------------
#echo "Проверка наличия всех необходимых файлов для прохождения тестов"
@test "Проверка наличия /opt/bin/kvas/adblock" {
	run on_server "[ -f /opt/bin/kvas/adblock ] && exit 0 || exit 1"
# 	в случае ошибок в тесте - будет вывод основных критериев работы
	print_on_error "${status}" "${output}"
	[ "${status}" -eq 0 ]
}
@test "Проверка наличия /opt/bin/kvas/update" {
	run on_server "[ -f /opt/bin/kvas/update ] && exit 0 || exit 1"
# 	в случае ошибок в тесте - будет вывод основных критериев работы
	print_on_error "${status}" "${output}"
	[ "${status}" -eq 0 ]
}
@test "Проверка наличия /opt/bin/kvas/adguard" {
	run on_server "[ -f /opt/bin/kvas/adguard ] && exit 0 || exit 1"
# 	в случае ошибок в тесте - будет вывод основных критериев работы
	print_on_error "${status}" "${output}"
	[ "${status}" -eq 0 ]
}
@test "Проверка наличия /opt/bin/kvas/dnsmasq" {
	run on_server "[ -f /opt/bin/kvas/dnsmasq ] && exit 0 || exit 1"
# 	в случае ошибок в тесте - будет вывод основных критериев работы
	print_on_error "${status}" "${output}"
	[ "${status}" -eq 0 ]
}
@test "Проверка наличия /opt/bin/kvas/ipset" {
	run on_server "[ -f /opt/bin/kvas/ipset ] && exit 0 || exit 1"
# 	в случае ошибок в тесте - будет вывод основных критериев работы
	print_on_error "${status}" "${output}"
	[ "${status}" -eq 0 ]
}
@test "Проверка наличия /opt/bin/kvas/libs/vpn" {
	run on_server "[ -f /opt/bin/kvas/libs/vpn ] && exit 0 || exit 1"
# 	в случае ошибок в тесте - будет вывод основных критериев работы
	print_on_error "${status}" "${output}"
	[ "${status}" -eq 0 ]
}
@test "Проверка наличия /opt/bin/kvas/libs/main" {
	run on_server "[ -f /opt/bin/kvas/libs/main ] && exit 0 || exit 1"
# 	в случае ошибок в тесте - будет вывод основных критериев работы
	print_on_error "${status}" "${output}"
	[ "${status}" -eq 0 ]
}
@test "Проверка наличия /opt/bin/kvas/libs/debug" {
	run on_server "[ -f /opt/bin/kvas/libs/debug ] && exit 0 || exit 1"
# 	в случае ошибок в тесте - будет вывод основных критериев работы
	print_on_error "${status}" "${output}"
	[ "${status}" -eq 0 ]
}
@test "Проверка наличия /opt/bin/kvas/libs/check" {
	run on_server "[ -f /opt/bin/kvas/libs/check ] && exit 0 || exit 1"
# 	в случае ошибок в тесте - будет вывод основных критериев работы
	print_on_error "${status}" "${output}"
	[ "${status}" -eq 0 ]
}
