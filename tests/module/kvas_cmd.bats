#!/usr/bin/env bats
source ../libs/main

#================================================================
# 	Данный файл предназначен для тестирования самих тестов
#	Здесь пишутся сами тесты и затем переносятся в соотвествующие
#	файлы етосв с расширением bats
#================================================================
@test "Проверка по отображению списка разблокировки при отсутствии списка [cmd_show_list]" {

	cmd="mv /opt/etc/hosts.list /opt/etc/.kvas/backup/hosts.list.bat && mv /opt/etc/.kvas/backup/hosts.list /opt/etc/.kvas/backup/hosts.list.bak"
	run on_server "${cmd} "
	print_on_error "${status}" "${output}"

	cmd="cmd_show_list"
	run on_server "${vpn_lib_load} && ${cmd} "
	print_on_error "${status}" "${output}"

	[ "${status}" -eq 0 ]

	#	Блок проверок то, что точно должно быть при нормальной работе скрипта
	echo "${output}" | grep -q "Списка разблокировки не существует"

}
@test "Проверка по отображению списка разблокировки при пустом списке [cmd_show_list]" {

	cmd="touch /opt/etc/hosts.list"
	run on_server "${vpn_lib_load} && ${cmd} "
	print_on_error "${status}" "${output}"

	cmd="cmd_show_list"
	run on_server "${vpn_lib_load} && ${cmd} "
	print_on_error "${status}" "${output}"

	[ "${status}" -eq 0 ]

	#	Блок проверок то, что точно должно быть при нормальной работе скрипта
	echo "${output}" | grep -q "Список разблокировки пуст!"

}

@test "Проверка отображения списка разблокировки [cmd_show_list]" {
	cmd="mv /opt/etc/.kvas/backup/hosts.list.bat /opt/etc/hosts.list && mv /opt/etc/.kvas/backup/hosts.list.bak /opt/etc/.kvas/backup/hosts.list"
	run on_server "${cmd} "
	print_on_error "${status}" "${output}"

	cmd="cmd_show_list"
	run on_server "${vpn_lib_load} && ${cmd} "
	print_on_error "${status}" "${output}"

	[ "${status}" -eq 0 ]

	#	Блок проверок то, что точно должно быть при нормальной работе скрипта
	[ "$(echo "${output}" | wc -l)" -gt 1 ]

}

@test "Проверка по отображению справки о пакете [cmd_help]" {

	cmd="cmd_help"
	run on_server "${vpn_lib_load} && ${cmd} "
	print_on_error "${status}" "${output}"

	[ "${status}" -eq 0 ]

	#	Блок проверок то, что точно должно быть при нормальной работе скрипта
	echo "${output}" | grep -q "Примеры использования:"

}

@test "Проверка отображения версии пакета [APP_VERSION]" {

	cmd="cat < /opt/apps/kvas/bin/kvas | grep APP_VERSION= | cut -d'=' -f2"
	run on_server "${cmd}"
	print_on_error "${status}" "${output}"
	[ "${status}" -eq 0 ]
	#	Блок проверок то, что точно должно быть при нормальной работе скрипта
	echo "${output}" | grep -Ex '[0-9]{1,2}.[0-9]{1,2}'


}
@test "Проверка отображения релиза пакета [APP_RELEASE]" {

	cmd="cat < /opt/apps/kvas/bin/kvas | grep APP_RELEASE= | cut -d'=' -f2"
	run on_server "${cmd}"
	print_on_error "${status}" "${output}"
	[ "${status}" -eq 0 ]
	#	Блок проверок то, что точно должно быть при нормальной работе скрипта
	echo "${output}" | grep -Ex '[0-9]{1,2}.[0-9]{1,3}|beta-[0-9]{1,3}'

}

@test "Проверка работы обновления правил ipset [cmd_kvas_init ]" {

	cmd="cmd_kvas_init "
	run on_server "${vpn_lib_load} && ${cmd}"
	print_on_error "${status}" "${output}"
	[ "${status}" -eq 0 ]
	#	Блок проверок то, что точно должно быть при нормальной работе скрипта
	echo "${output}" | grep -q 'ГОТОВО'

}

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

@test "Проверка установки периода обновления списка разблокировки с аргументом на 12 часов [cmd_set_period_update]" {

	cmd="cmd_set_period_update 12h"
	run on_server "${vpn_lib_load} && ${cmd}"
	print_on_error "${status}" "${output}"
	[ "${status}" -eq 0 ]
	#	Блок проверок то, что точно должно быть при нормальной работе скрипта
	echo "${output}" | grep -q 'Период обновления установлен на каждые'

}

