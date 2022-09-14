#!/usr/bin/env bats
source ../libs/main
#================================================================
# 	Данный файл предназначен для тестирования самих тестов
#	Здесь пишутся сами тесты и затем переносятся в соотвествующие
#	файлы етосв с расширением bats
#================================================================
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
