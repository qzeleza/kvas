#!/opt/apps/kvas/bats/bin/bats
source ../tests_lib

#-----------------------------------------------------
# 	ТЕСТЫ из библиотеки kvas_lib_main
#-----------------------------------------------------
VARIABLE=TEST_99999; VALUE=99999
@test "Проверка записи переменной в файл конфигурации [set_config_value]" {
	lib_load=". /opt/bin/kvas_lib_main"
	cmd="set_config_value ${VARIABLE} ${VALUE}"
	run on_server "${lib_load} && ${cmd}"
	[ "${status}" -eq 0 ]

    run on_server "grep ${VARIABLE} /opt/etc/kvas.conf"
    [ "${status}" -eq 0 ]
    [[ "${output}" == *"${VARIABLE}"* ]]
}

@test "Проверка получения переменной из файла конфигурации [get_config_value]" {
	lib_load=". /opt/bin/kvas_lib_main"
	cmd="get_config_value ${VARIABLE}"
	run on_server "${lib_load} && ${cmd}"

    [ "${status}" -eq 0 ]
    [ "${output}" -eq "${VALUE}" ]

}

@test "Проверка удаления переменной из файла конфигурации [del_config_value]" {
	lib_load=". /opt/bin/kvas_lib_main"
	cmd="del_config_value ${VARIABLE}"
	run on_server "${lib_load} && ${cmd}"
    [ "${status}" -eq 0 ]

    run on_server "grep -co ${VALUE} /opt/etc/kvas.conf"
	[ "${status}" -eq 1 ]
    [ "${output}" = 0 ]
}

@test "Проверка получения списка хостов через разделитель [get_separated_host_list]" {
	lib_load=". /opt/bin/kvas_lib_vpn"
	cmd="get_separated_host_list"
	run on_server "${lib_load} && ${cmd}"

    [ "${status}" -eq 0 ]
    echo "${output}" | grep -Eq "(www|\|)"
    [ "$(echo "${output}" | grep -o "|" | wc -l)" -gt 2 ]

}
@test "Проверка форматирования числа [dig_frm]" {
	lib_load=". /opt/bin/kvas_lib_main"
	cmd="dig_frm 3414321541"
	run on_server "${lib_load} && ${cmd}"
    [ "${status}" -eq 0 ]
    [ "$(echo "${output}" | grep -o " " | wc -l)" -gt 2 ]
}

@test "Проверка получения текущего IP роутера [get_router_ip]" {
#	skip "Непонятная ошибка sh: ip: not found"
	lib_load="source /opt/bin/kvas_lib_main"
	cmd="get_router_ip"
	run on_server "${lib_load} && ${cmd}"
	dots="$(echo "${output}" | tr -d '0-9' | grep -o "." | wc -l)"
    [ "${status}" -eq 0 ]
#    echo "${output} и ${status}"
    echo "${output}"
    [ "${dots}" -eq 3 ]
}


@test "Проверка получения ID интерфейса на заданном IP адресе [get_inface_by_ip]" {
	lib_load=". /opt/bin/kvas_lib_main"
	cmd="get_inface_by_ip 10.130.2.74"
	run on_server "${lib_load} && ${cmd}"
    [ "${status}" -eq 0 ]
	[[ "${output}" == nwg* ]]
}


@test "Проверка получения ID локального интерфейса роутера [get_local_inface]" {
	lib_load=". /opt/bin/kvas_lib_main"
	cmd="get_local_inface"
	run on_server "${lib_load} && ${cmd}"
    [ "${status}" -eq 0 ]
	[[ "${output}" == br* ]]
}
@test "Проверка получения протокола работы WUI роутера [get_router_protocol]" {
	lib_load=". /opt/bin/kvas_lib_main"
	cmd="get_router_protocol"
	run on_server "${lib_load} && ${cmd}"
    [ "${status}" -eq 0 ]
    echo "${output}" | grep -Eq "(http|https)"
}

@test "Проверка получения локального порта WUI роутера [get_router_wui_port]" {
	lib_load=". /opt/bin/kvas_lib_main"
	cmd="get_router_wui_port"
	run on_server "${lib_load} && ${cmd}"
    [ "${status}" -eq 0 ]
    echo "${output}" | grep -Eq "[0-9]{2,4}"
}

@test "Проверка получения локальный хост роутера с протоколом и портом [get_router_host]" {
	lib_load=". /opt/bin/kvas_lib_main"
	cmd="get_router_host"
	run on_server "${lib_load} && ${cmd}"
    [ "${status}" -eq 0 ]
    echo "${output}" | grep -Eq "(http|https)"
    echo "${output}" | grep -Eq "[0-9]{2,4}"
}

@test "Проверка чистки содержимого файла [clear_file]" {
	lib_load=". /opt/bin/kvas_lib_main"
	cmd="clear_file /opt/apps/kvas/files/etc/conf/hosts.list"
	run on_server "${lib_load} && ${cmd}"
    [ "${status}" -eq 0 ]
    echo "${output}" | grep -qv "#"
    echo "${output}" | grep -Eqv "^$"
}

@test "Проверка чистки и сортировки содержимого файла [clear_content]" {
	lib_load=". /opt/bin/kvas_lib_main"
	cmd="clear_content /opt/apps/kvas/files/etc/conf/hosts.list"
	run on_server "${lib_load} && ${cmd}"
    [ "${status}" -eq 0 ]
    echo "${output}" | grep -qv "#"
    echo "${output}" | grep -Eqv "^$"
}


@test "Проверка чистки и сортировки содержимого файла с его заменой [clear_file_content]" {
	lib_load=". /opt/bin/kvas_lib_main"
	tmp_file=/tmp/tmp.test
	conf_file=/opt/apps/kvas/files/etc/conf/hosts.list
	prefix="cp ${conf_file} ${tmp_file}"
	cmd="clear_file_content ${tmp_file}"
	postfix="diff -a -s ${conf_file} ${tmp_file} && rm -f /tmp/tmp.test"
	run on_server "${lib_load} && ${prefix} && ${cmd} && ${postfix}"
    ! echo "${output}" | grep -q "are identical"
}

@test "Проверка подсчета строк в файле [rec_in_file]" {
	lib_load=". /opt/bin/kvas_lib_main"
	conf_file=/opt/apps/kvas/files/etc/conf/hosts.list
	cmd="rec_in_file ${conf_file}"
	run on_server "${lib_load} && ${cmd}"
	[ "${status}" -eq 0 ]
    [ "${output}" -gt 0 ]
    run on_server "${lib_load} && ${cmd} *"
    [ "${status}" -eq 0 ]
    [ "${output}" -gt 0 ]

}

@test "Проверка вывода заголовка при вводе ответа на запрос [read_ynq]" {
	lib_load=". /opt/bin/kvas_lib_main"
	cmd="answer=''; read_ynq 'Проверка ввода' answer"
	run on_server "${lib_load} && ${cmd}" <<< n
	[ "${status}" -eq 0 ]
    [[ "${output}" == *"Проверка ввода"* ]]

}

@test "Проверка ввода ответов на запрос [read_ynq]" {
	lib_load=". /opt/bin/kvas_lib_main"
	cmd="answer=''; read_ynq 'Проверка ввода' answer &> /dev/null && echo \${answer}"
	run on_server "${lib_load} && ${cmd}" <<< n
	[ "${status}" -eq 0 ]
    [ "${output}" = n ]
    run on_server "${lib_load} && ${cmd}" <<< y
	[ "${status}" -eq 0 ]
    [ "${output}" = y ]
    run on_server "${lib_load} && ${cmd}" <<< q
	[ "${status}" -eq 0 ]
    [ "${output}" = n ]
#    run on_server "${lib_load} && ${cmd}" <<< s
#	[ "${status}" -eq 0 ]
#    [[ "${output}" == *"Пожалуйста ответьте на вопрос"* ]]
}

@test "Проверка ввода данных на запрос [read_value]" {
	lib_load=". /opt/bin/kvas_lib_main"
	data=data
	cmd="answer=''; read_value 'Введите данные' answer &>/dev/null && echo \${answer}"
	run on_server "${lib_load} && ${cmd}" <<< ${data}
	[ "${status}" -eq 0 ]
#	echo "status=${status}"
#	echo "output=${output}"
    [ "${output}" = "${data}" ]

}

@test "Проверка получения даты с сервера [get_server_date]" {
	lib_load=". /opt/bin/kvas_lib_main"
	cmd="data=\$(get_config_value DNS_STATIC_1) && get_server_date \${data}"
	run on_server "${lib_load} && ${cmd}"
	[ "${status}" -eq 0 ]
	echo "status=${status}"
	echo "output=${output}"
    echo "${output}" | grep 202 | grep ':' | grep -q GMT

}

@test "Проверка обновления даты с сервера [date_update]" {
	lib_load=". /opt/bin/kvas_lib_main"
	cmd="date_update"
	run on_server "${lib_load} && ${cmd}"
	[ "${status}" -eq 0 ]
	echo "status=${status}"
	echo "output=${output}"
    [[ "${output}" == *"Системное время обновлено"* ]]

}
