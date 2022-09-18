#!/usr/bin/env bats
source ../libs/main

@test "Проверка обнаружения неверного формата при обновлении заданий в cron [cmd_set_period_update]" {
	cmd="cmd_set_period_update 22s"
	run on_server "${lib_load} && ${cmd} "
	print_on_error "${status}" "${output}"

	[ "${status}" -eq 0 ]

	#	Блок проверок то, что точно должно быть при нормальной работе скрипта
	! echo "${output}" | grep -q "not installed"
	echo "${output}" | grep -q "Указан не верный формат периода."

}

