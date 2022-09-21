#!/usr/bin/env bats
source ../libs/main

#-----------------------------------------------------
# 	ТЕСТЫ из библиотеки vpn
#-----------------------------------------------------
#echo "Проверка наличия всех необходимых файлов для прохождения тестов"
@test "Проверка наличия /opt/apps/kvas/bin/main/adblock" {
	run on_server "[ -f /opt/apps/kvas/bin/main/adblock ] && exit 0 || exit 1"
# 	в случае ошибок в тесте - будет вывод основных критериев работы
	print_on_error "${status}" "${output}"
	[ "${status}" -eq 0 ]
}
@test "Проверка наличия /opt/apps/kvas/bin/main/update" {
	run on_server "[ -f /opt/apps/kvas/bin/main/update ] && exit 0 || exit 1"
# 	в случае ошибок в тесте - будет вывод основных критериев работы
	print_on_error "${status}" "${output}"
	[ "${status}" -eq 0 ]
}
@test "Проверка наличия /opt/apps/kvas/bin/main/adguard" {
	run on_server "[ -f /opt/apps/kvas/bin/main/adguard ] && exit 0 || exit 1"
# 	в случае ошибок в тесте - будет вывод основных критериев работы
	print_on_error "${status}" "${output}"
	[ "${status}" -eq 0 ]
}
@test "Проверка наличия /opt/apps/kvas/bin/main/dnsmasq" {
	run on_server "[ -f /opt/apps/kvas/bin/main/dnsmasq ] && exit 0 || exit 1"
# 	в случае ошибок в тесте - будет вывод основных критериев работы
	print_on_error "${status}" "${output}"
	[ "${status}" -eq 0 ]
}
@test "Проверка наличия /opt/apps/kvas/bin/main/ipset" {
	run on_server "[ -f /opt/apps/kvas/bin/main/ipset ] && exit 0 || exit 1"
# 	в случае ошибок в тесте - будет вывод основных критериев работы
	print_on_error "${status}" "${output}"
	[ "${status}" -eq 0 ]
}
@test "Проверка наличия /opt/apps/kvas/bin/libs/vpn" {
	run on_server "[ -f /opt/apps/kvas/bin/libs/vpn ] && exit 0 || exit 1"
# 	в случае ошибок в тесте - будет вывод основных критериев работы
	print_on_error "${status}" "${output}"
	[ "${status}" -eq 0 ]
}
@test "Проверка наличия /opt/apps/kvas/bin/libs/main" {
	run on_server "[ -f /opt/apps/kvas/bin/libs/main ] && exit 0 || exit 1"
# 	в случае ошибок в тесте - будет вывод основных критериев работы
	print_on_error "${status}" "${output}"
	[ "${status}" -eq 0 ]
}
@test "Проверка наличия /opt/apps/kvas/bin/libs/debug" {
	run on_server "[ -f /opt/apps/kvas/bin/libs/debug ] && exit 0 || exit 1"
# 	в случае ошибок в тесте - будет вывод основных критериев работы
	print_on_error "${status}" "${output}"
	[ "${status}" -eq 0 ]
}
@test "Проверка наличия /opt/apps/kvas/bin/libs/check" {
	run on_server "[ -f /opt/apps/kvas/bin/libs/check ] && exit 0 || exit 1"
# 	в случае ошибок в тесте - будет вывод основных критериев работы
	print_on_error "${status}" "${output}"
	[ "${status}" -eq 0 ]
}
