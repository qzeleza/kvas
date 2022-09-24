#!/usr/bin/env bats
source ../libs/main
#
# Проверка запуска всех файлов в папке ./kvas/bin/main/,
# кроме файлов dnsmasq и adblock (их проверяем в модуле adblock.bats)
#
@test "Проверка создания таблицы unblock в ipset при запуске /opt/apps/kvas/bin/main/ipset" {
	adh_file=/opt/apps/kvas/bin/main/ipset
#	run on_server "/opt/sbin/ipset flush unblock"
	run on_server "/opt/apps/kvas/bin/main/ipset &"
	run on_server "sleep 5"
	run on_server "/opt/sbin/ipset list unblock "
# 	в случае ошибок в тесте - будет вывод основных критериев работы
	print_on_error "${status}" "${output}"
	[ "${status}" -eq 0 ]
	[ "$(echo "${output}" | grep -vEi '^[a-z]' | wc -l)" -gt 2 ]
}


@test "Проверка создания блока ipset в файле конфигурации AdGuard Home [/opt/apps/kvas/bin/main/adguard]" {
	adh_file=/opt/apps/kvas/bin/main/adguard
	run on_server "${adh_file} && cat /opt/etc/AdGuardHome/AdGuardHome.yaml | sed -n '/ipset/,/filtering_enabled/p' "
# 	в случае ошибок в тесте - будет вывод основных критериев работы
	print_on_error "${status}" "${output}"
	[ "${status}" -eq 0 ]
	echo "${output}" | grep "ipset" -A10 | grep -Eq "\/unblock"
}

