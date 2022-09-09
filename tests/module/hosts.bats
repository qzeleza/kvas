#!/usr/bin/env bats
source ../tests_lib

#-----------------------------------------------------
# 	ТЕСТЫ
#-----------------------------------------------------

@test "Проверка добавления правильного хоста ya.ru" {
	lib_load=". /opt/bin/kvas_lib_vpn"
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

@test "Проверка добавления не верного хоста yay.ruu" {
    run on_server "kvas add yay.ruu"
    [ "${status}" -eq 0 ]
    [[ "${output}" == *"не отвечает"* ]]
    print_on_error "${status}" "${output}"
}

@test "Проверка добавления уже существующего в списке хоста ya.ru" {
    run on_server "kvas add ya.ru"
    [ "${status}" -eq 0 ]
    [[ "${output}" == *"домен уже есть"* ]]
    print_on_error "${status}" "${output}"
}

@test "Проверка добавления не корректного имени yaru" {
    run on_server "kvas add yaru"
    [ "${status}" -eq 0 ]
    [[ "${output}" == *"Некорректно указано"* ]]
    print_on_error "${status}" "${output}"
}

@test "Проверка удаления хоста ya.ru" {
	run on_server "kvas add ya.ru"
    run on_server "kvas del ya.ru"
    [ "${status}" -eq 0 ]
    [[ "${output}" == *"УДАЛЕН"* ]]
    print_on_error "${status}" "${output}"
}

@test "Проверка удаления отсутствующего в списке хоста ya.ru" {
    run on_server "kvas del ya.ru"
    [ "${status}" -eq 0 ]
    [[ "${output}" == *"Такая запись"* ]]
    print_on_error "${status}" "${output}"
}


@test "Проверка удаления всех записей в списке." {
    run on_server "cp /opt/apps/kvas/files/etc/conf/hosts.list /opt/etc/hosts.list"
    run on_server "kvas purge " <<< y
    [ "${status}" -eq 0 ]
    [[ "${output}" == *"ОЧИЩЕН"* ]]
    print_on_error "${status}" "${output}"
#    run on_server "cp /opt/apps/kvas/files/etc/conf/hosts.list /opt/etc/hosts.list"
}

@test "Проверка вывода ошибки при отсутствии списочного файла при удалении всех записей." {
#    skip
	lib_load=". /opt/bin/kvas_lib_vpn"
	prefix="mv -f /opt/etc/hosts.list /opt/etc/hosts.list.test"
	cmd="cmd_clear_list"
	postfix="mv -f /opt/etc/hosts.list.test /opt/etc/hosts.list"
	run on_server "${lib_load} && ${prefix} && ${cmd} && ${postfix}"
	print_on_error "${status}" "${output}"

    [ "${status}" -eq 0 ]
    [[ "${output}" == *"Списочный файл не существует"* ]]

}

@test "Проверка вывода ошибки при отсутствии записей в списочном файле." {
	run on_server "rm /opt/etc/hosts.list && touch /opt/etc/hosts.list"
    run on_server "kvas purge "
    [ "${status}" -eq 0 ]
    [[ "${output}" == *"Список разблокировки не содержит записей"* ]]
    run on_server "cp /opt/apps/kvas/files/etc/conf/hosts.list /opt/etc/hosts.list"
    print_on_error "${status}" "${output}"
}
