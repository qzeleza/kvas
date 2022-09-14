#!/usr/bin/env bats
source ../libs/main

#-----------------------------------------------------
# 	ТЕСТЫ
#-----------------------------------------------------

@test "Проверка добавления правильного хоста ya.ru" {
	domain="ya.ru"
	prefix="cmd_del_one_host ${domain} || echo 0"
	postfix="cmd_del_one_host ${domain} || echo 0"

	cmd="cmd_add_one_host ${domain}"
	run on_server "${lib_load} && ${prefix} && ${cmd} && ${postfix}"

# 	в случае ошибок в тесте - будет вывод основных критериев работы
	print_on_error "${status}" "${output}"

	[ "${status}" -eq 0 ]
#	Блок проверок то, чего точно не должно быть, при нормальной работе скрипта
	echo "${output}" | grep -q "ДОБАВЛЕН"
}

@test "Проверка добавления НЕверного хоста yay.ruu" {

    cmd="cmd_add_one_host yay.ruu"
	run on_server "${lib_load} && ${cmd}"
	print_on_error "${status}" "${output}"

    [ "${status}" -ge 0 ]
    [[ "${output}" = *"не отвечает"* ]]
}


@test "Проверка добавления уже существующего в списке хоста ya.ru" {

    cmd="cmd_add_one_host ya.ru"
	run on_server "${lib_load} && ${cmd}"
	print_on_error "${status}" "${output}"
    [ "${status}" -eq 0 ]
    [[ "${output}" = *"домен уже есть"* ]]
}

@test "Проверка добавления не корректного имени yaru" {
    cmd="cmd_add_one_host yaru"
	run on_server "${lib_load} && ${cmd}"
	print_on_error "${status}" "${output}"
    [ "${status}" -eq 0 ]
    [[ "${output}" = *"Некорректно указано"* ]]
}

@test "Проверка удаления хоста ya.ru" {
	cmd1="cmd_add_one_host ya.ru"
	cmd2="cmd_del_one_host ya.ru"

	run on_server "${lib_load} && ${cmd1}"
    run on_server "${lib_load} && ${cmd2}"
	print_on_error "${status}" "${output}"
    [ "${status}" -eq 0 ]
    [[ "${output}" = *"УДАЛЕН"* ]]
}
@test "Проверка удаления отсутствующего в списке хоста ya.ru" {
    cmd="cmd_del_one_host ya.ru"
    run on_server "${lib_load} && ${cmd}"
	print_on_error "${status}" "${output}"
    [ "${status}" -eq 0 ]
    [[ "${output}" = *"Такая запись"* ]]

}


@test "Проверка удаления всех записей в списке." {
    cmd="cmd_clear_list"
    run on_server "cp /opt/apps/kvas/files/etc/conf/hosts.list /opt/etc/hosts.list"
	run on_server "${lib_load} && ${cmd}" <<< y
	print_on_error "${status}" "${output}"
    [ "${status}" -eq 0 ]
    [[ "${output}" = *"ОЧИЩЕН"* ]]
}

@test "Проверка вывода ошибки при отсутствии списочного файла при удалении всех записей." {
#    skip
	prefix="mv -f /opt/etc/hosts.list /opt/etc/hosts.list.test"
	cmd="cmd_clear_list"
	postfix="mv -f /opt/etc/hosts.list.test /opt/etc/hosts.list"
	run on_server "${lib_load} && ${prefix} && ${cmd} && ${postfix}"
	print_on_error "${status}" "${output}"

    [ "${status}" -eq 0 ]
    [[ "${output}" = *"Списочный файл не существует"* ]]

}
@test "Проверка вывода ошибки при отсутствии записей в списочном файле." {
#    skip
	prefix="rm /opt/etc/hosts.list && touch /opt/etc/hosts.list"
	cmd="cmd_clear_list"
	postfix="cp /opt/apps/kvas/files/etc/conf/hosts.list /opt/etc/hosts.list"
	run on_server "${lib_load} && ${prefix} && ${cmd} && ${postfix}"
	print_on_error "${status}" "${output}"

    [ "${status}" -eq 0 ]
    [[ "${output}" = *"Список разблокировки не содержит записей"* ]]

}
