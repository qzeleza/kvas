#!/opt/apps/kvas/bats/bin/bats
. lib
#-----------------------------------------------------
# 	ТЕСТЫ
#-----------------------------------------------------

#@test "Проверка удаления всех записей в списке." {
#    run server "kvas purge " <<< y
#    [ "${status}" -eq 0 ]
#    [[ "${output}" == *"ОЧИЩЕН"* ]]
#    run server "cp /opt/apps/kvas/files/etc/conf/hosts.list /opt/etc/hosts.list"
#}

#
@test "Проверка добавления правильного хоста ya.ru" {
    run on_server "kvas add ya.ru"
    [ "${status}" -eq 0 ]
    [[ "${output}" == *"ДОБАВЛЕН"* ]]
}

@test "Проверка добавления не верного хоста yay.ruu" {
    run on_server "kvas add yay.ruu"
    [ "${status}" -eq 0 ]
    [[ "${output}" == *"не отвечает"* ]]
}

@test "Проверка добавления уже существующего в списке хоста ya.ru" {
    run on_server "kvas add ya.ru"
    [ "${status}" -eq 0 ]
    [[ "${output}" == *"домен уже есть"* ]]
}

@test "Проверка добавления не корректного имени yaru" {
    run on_server "kvas add yaru"
    [ "${status}" -eq 0 ]
    [[ "${output}" == *"Некорректно указано"* ]]
}

@test "Проверка удаления хоста ya.ru" {
	run on_server "kvas add ya.ru"
    run on_server "kvas del ya.ru"
    [ "${status}" -eq 0 ]
    [[ "${output}" == *"УДАЛЕН"* ]]
}

@test "Проверка удаления отсутствующего в списке хоста ya.ru" {
    run on_server "kvas del ya.ru"
    [ "${status}" -eq 0 ]
    [[ "${output}" == *"Такая запись"* ]]
}


@test "Проверка удаления всех записей в списке." {
    run on_server "cp /opt/apps/kvas/files/etc/conf/hosts.list /opt/etc/hosts.list"
    run on_server "kvas purge " <<< y
    [ "${status}" -eq 0 ]
    [[ "${output}" == *"ОЧИЩЕН"* ]]
#    run on_server "cp /opt/apps/kvas/files/etc/conf/hosts.list /opt/etc/hosts.list"
}

@test "Проверка вывода ошибки при отсутствии списочного файла при удалении всех записей." {
    skip
    run on_server "rm -f /opt/etc/hosts.list && kvas purge"
    echo "${output}"
    [ "${status}" -eq 0 ]
    [[ "${output}" == *"Списочный файл не существует"* ]]
    run on_server "cp /opt/apps/kvas/files/etc/conf/hosts.list /opt/etc/hosts.list"
}

@test "Проверка вывода ошибки при отсутствии записей в списочном файле." {
	run on_server "rm /opt/etc/hosts.list && touch /opt/etc/hosts.list"
    run on_server "kvas purge "
    [ "${status}" -eq 0 ]
    [[ "${output}" == *"Список разблокировки не содержит записей"* ]]
    run on_server "cp /opt/apps/kvas/files/etc/conf/hosts.list /opt/etc/hosts.list"
}
