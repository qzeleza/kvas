#!/usr/bin/env bats
source ../libs/main

dnsmasq_conf='/opt/etc/dnsmasq.conf'
adblock_bin_file_copy='/opt/apps/kvas/bin/main/adblock'
adblock_bin_file='/opt/apps/kvas/bin/main/adblock'
adblock_src_file=/opt/etc/adblock.sources
adblock_src_file_copy=/opt/apps/kvas/etc/conf/adblock.sources


@test "Отключаем AdGuard Home [cmd_adguardhome_off]" {
	cmd="cmd_adguardhome_off"
	run on_server "${vpn_lib_load} && ${cmd} "
# 	в случае ошибок в тесте - будет вывод основных критериев работы
	print_on_error "${status}" "${output}"
	[ "${status}" -eq 0 ]
	echo "${output}" | grep -q "УСПЕШНО"
}
#-----------------------------------------------------
# 	ТЕСТЫ из библиотеки vpn БЛОКИРОВКА РЕКЛАМЫ
#-----------------------------------------------------
@test "Проверка наличия редактора nano для редактирования списка блокировки рекламы [cmd_ads_edit]" {
	cmd="opkg files nano-full"
	run on_server "${vpn_lib_load} && ${cmd} "

# 	в случае ошибок в тесте - будет вывод основных критериев работы
	print_on_error "${status}" "${output}"

	[ "${status}" -eq 0 ]

	#	Блок проверок то, что точно должно быть при нормальной работе скрипта
	! echo "${output}" | grep -q "not installed"
	echo "${output}" | grep -q "nano"
}

@test "Проверка отключения блокировки рекламы [cmd_ads_protect_off]" {
#	prefix="cmd_adguardhome_status | grep -q 'ВКЛЮЧЕН' && cmd_adguardhome_off"
	prefix="cmd_ads_protect_on | grep -q 'рекламы уже' || cmd_ads_protect_on "
	cmd="cmd_ads_protect_off"

	run on_server "${vpn_lib_load} && ${prefix} && ${cmd}"
	print_on_error "${status}" "${output}"
	[ "${status}" -eq 0 ]

	[[ "${output}" = *"Блокировка рекламы"* ]]
    [[ "${output}" = *"ОТКЛЮЧЕНА"* ]]
    [[ "${output}" = *"Перезапуск службы dnsmasq"* ]]
    [[ "${output}" = *"ГОТОВО"* ]]
}

@test "Проверка включения блокировки рекламы [cmd_ads_protect_on]" {
	prefix="cmd_ads_protect_off"
	cmd="cmd_ads_protect_on"

	run on_server "${vpn_lib_load} && ${prefix} && ${cmd}"
	print_on_error "${status}" "${output}"
	[ "${status}" -eq 0 ]

	[[ "${output}" = *"Блокировка рекламы"* ]]
    [[ "${output}" = *"ВКЛЮЧЕНА"* ]]
    [[ "${output}" = *"Перезапуск службы dnsmasq"* ]]
    [[ "${output}" = *"ГОТОВО"* ]]
}
@test "Проверка включения блокировки рекламы при уже включенном статусе [cmd_ads_protect_on]" {
	cmd="cmd_ads_protect_on"
	run on_server "${vpn_lib_load} && ${cmd}"
	print_on_error "${status}" "${output}"
	[ "${status}" -eq 0 ]

	[[ "${output}" = *"Блокировка рекламы уже "* ]]
}
@test "Проверка статуса блокировки рекламы, если блок подключен [cmd_ads_status]" {
	prefix="new_dn=0; if [ -f ${dnsmasq_conf} ]; then sed -i '/\/opt\/tmp\/adblock/d' ${dnsmasq_conf}; else new_dn=1; fi; \
	 		echo 'addn-hosts=/opt/tmp/adblock' >> ${dnsmasq_conf}; echo 0"
	postfix="[ \${new_dn} = 1 ] && rm ${dnsmasq_conf}"

	cmd="cmd_ads_status"
	run on_server "${vpn_lib_load} && ${prefix} && ${cmd} && ${postfix}"

# 	в случае ошибок в тесте - будет вывод основных критериев работы
	print_on_error "${status}" "${output}"

#	[ "${status}" -eq 0 ]

	#	Блок проверок то, что точно должно быть при нормальной работе скрипта
	echo "${output}" | grep -q "Блокировка рекламы"
	echo "${output}" | grep -q "ВКЛЮЧЕНА"

}

@test "Проверка статуса блокировки рекламы, если файл конфигурации dnsmasq.conf отсутствует [cmd_ads_status]" {
	prefix="! [ -f ${adblock_bin_file} ] && cp ${adblock_bin_file_copy} ${adblock_bin_file}; new_ad=1;\
			  [ -f ${dnsmasq_conf} ] && mv ${dnsmasq_conf} ${dnsmasq_conf}.test || echo 0"

	cmd="cmd_ads_status"
	run on_server "${vpn_lib_load} && ${prefix} && ${cmd}"

# 	в случае ошибок в тесте - будет вывод основных критериев работы
	print_on_error "${status}" "${output}"

	[ "${status}" -eq 0 ]

	#	Блок проверок то, чего точно не должно быть, при нормальной работе скрипта
	echo "${output}" | grep -qo "Отсутствует файл конфигурации"
	postfix="[ \${new_ad} = 1 ] && rm ${adblock_bin_file}; \
		 [ -f ${adblock_bin_file}.test ] && mv ${adblock_bin_file}.test ${adblock_bin_file}; \
		 [ -f ${dnsmasq_conf}.test ] && mv ${dnsmasq_conf}.test ${dnsmasq_conf} || echo 0"
	run on_server "${postfix}"
}

@test "Проверка статуса блокировки рекламы, если скрипт обработки рекламы отсутствует [cmd_ads_status]" {

	prefix="[ -f ${adblock_bin_file} ] && mv ${adblock_bin_file} ${adblock_bin_file}.test || echo 0"
	cmd="cmd_ads_status"
	postfix="[ -f ${adblock_bin_file}.test ] && mv ${adblock_bin_file}.test ${adblock_bin_file}"

	run on_server "${vpn_lib_load} && ${prefix} && ${cmd} && ${postfix}"

# 	в случае ошибок в тесте - будет вывод основных критериев работы
	print_on_error "${status}" "${output}"

	[ "${status}" -eq 0 ]
	#	Блок проверок то, чего точно не должно быть, при нормальной работе скрипта
	echo "${output}" | grep -qo "Скрипт обработки рекламы отсутствует"
}

@test "Проверка активации блокировки рекламы при наличии архива, без его восстановления [ads_request_to_upload]" {
	prefix="[ -f ${adblock_src_file} ] && cp -f ${adblock_src_file} ${adblock_src_file}.kvas  \
			|| cp -f ${adblock_src_file_copy} ${adblock_src_file}.kvas; echo 0"
	cmd="ads_request_to_upload ask"

	run on_server "${vpn_lib_load} && ${prefix} && ${cmd}" <<< n
	print_on_error "${status}" "${output}"
#	[ "${status}" -eq 0 ]

	[[ "${output}" = *"Загрузка источников рекламы"* ]]
    [[ "${output}" = *"УДАЧНО"* ]]

	postfix="[ -f ${adblock_src_file}.kvas ] \
		  && rm -f ${adblock_src_file}.kvas \
		  || rm -f ${adblock_src_file}"
    run on_server "${vpn_lib_load} && ${postfix}"
}

@test "Проверка активации блокировки рекламы при наличии архива с восстановлением [ads_request_to_upload]" {
	prefix="[ -f ${adblock_src_file} ] \
			&& cp -f ${adblock_src_file} ${adblock_src_file}.kvas \
			|| cp -f ${adblock_src_file_copy} ${adblock_src_file}"
	cmd="ads_request_to_upload ask"
	postfix="[ -f ${adblock_src_file}.kvas ] \
			  && rm -f ${adblock_src_file}.kvas \
			  || rm -f ${adblock_src_file}"
	run on_server "${vpn_lib_load} && ${prefix} && ${cmd}" <<< y
	print_on_error "${status}" "${output}"

	[ "${status}" -eq 0 ]
	[[ "${output}" = *"Обнаружен архивный файл"* ]]
    [[ "${output}" = *"УДАЧНО"* ]]
    run on_server "${vpn_lib_load} && ${postfix}"
}

@test "Проверка активации блокировки рекламы при наличии списка хостов [ads_request_to_upload]" {
	host_record='127.0.0.1    ya.ru'
	prefix="{ ([ -f ${adblock_src_file}.kvas ] \
			&& mv -f ${adblock_src_file}.kvas /tmp/adblock.sources.kvas); \
			! [ -f ${adblock_src_file} ] \
			&& ( cp ${adblock_src_file_copy} ${adblock_src_file}; flag=1 );\
			(! [ -f /opt/tmp/adblock/hosts ] \
			&& mkdir -p /opt/tmp/adblock && echo '${host_record}' >> /opt/tmp/adblock/hosts) \
			} || echo 0"
#	prefix="touch /opt/tmp/adblock/hosts"
	cmd="ads_request_to_upload ask"
	run on_server "${vpn_lib_load} && ${prefix} && ${cmd}" <<< y
	print_on_error "${status}" "${output}"

	[ "${status}" -eq 0 ]
	[[ "${output}" = *"Обновить списки блокировки"* ]]
	postfix="[ \$flag = 1 ] && rm -f /opt/etc/adblock.sources; \
			([ -f /tmp/adblock.sources.kvas ] && mv /tmp/adblock.sources.kvas ${adblock_src_file}.kvas); \
			(grep -q '${host_record}' /opt/tmp/adblock/hosts && rm /opt/tmp/adblock/hosts)"
	run on_server "${postfix}"
	echo "output=${output}"
}

@test "Проверка работы файла обновления списков рекламы из источников [/opt/apps/kvas/bin/main/adblock]" {
#	нужно сделать копию данных и затем восстановить их
	prefix="[ -f ${adblock_src_file} ] \
			&& mv ${adblock_src_file} ${adblock_src_file}.test; \
			echo -e 'https://raw.githubusercontent.com/tiuxo/hosts/master/ads\n' > ${adblock_src_file}; \
			[ -f /opt/tmp/adblock/hosts ] \
			&& mv /opt/tmp/adblock/hosts /opt/tmp/adblock/hosts.test || echo 0"

	cmd="ads_request_to_upload"
	run on_server "${vpn_lib_load} && ${prefix} && ${cmd}"

	print_on_error "${status}" "${output}"

	[ "${status}" -eq 0 ]

#	Блок проверок то, чего точно не должно быть, при нормальной работе скрипта
	! echo "${output}" | grep -qo "Файл с ссылками на списки блокировки рекламы отсутствует"
	! echo "${output}" | grep -qo "Следующие ссылки не корректны и содержат HTML код"
	! echo "${output}" | grep -qo "ОШИБКИ"
	! echo "${output}" | grep -qEo "Скачено хостов для блокировки рекламы.*0"
	! echo "${output}" | grep -qEo "Добавлено всего хостов для блокировки рекламы.*0"

#	Блок проверок то, что точно должно быть при нормальной работе скрипта
	echo "${output}" | grep -q "100%"
	echo "${output}" | grep -q "Сортировка и удаление дубликатов"
	echo "${output}" | grep -q "Скачено хостов для блокировки рекламы"
	echo "${output}" | grep -q "Количество удаленных дубликатов"
	echo "${output}" | grep -q "Исключено записей из списка блокировки"
	echo "${output}" | grep -q "Добавлено всего хостов для блокировки рекламы"

	postfix="[ -f /opt/tmp/adblock/hosts.test ] && mv /opt/tmp/adblock/hosts.test /opt/tmp/adblock/hosts; \
			[ -f ${adblock_src_file}.test ] && mv ${adblock_src_file}.test ${adblock_src_file}"

	run on_server "${postfix}"
	echo "output=${output}"
}

@test "Проверка работы генерации ipset блока в файле конфигурации dnsmasq [/kvas/bin/main/dnsmasq]" {
	adh_file=/opt/apps/kvas/bin/main/dnsmasq
	run on_server "${adh_file} && cat /opt/etc//kvas.dnsmasq"
# 	в случае ошибок в тесте - будет вывод основных критериев работы
	print_on_error "${status}" "${output}"
	[ "${status}" -eq 0 ]
	ipset_num=$(echo "${output}" | grep -c "ipset")
	unblock_num=$(echo "${output}" | grep -c "unblock")
	[ "${ipset_num}" -gt 1 ] && [ "${ipset_num}" -ge "${unblock_num}" ]
}


@test "Включаем AdGuard Home [cmd_adguardhome_on]" {
	cmd="cmd_adguardhome_on"
	run on_server "${vpn_lib_load} && ${cmd} "
# 	в случае ошибок в тесте - будет вывод основных критериев работы
	print_on_error "${status}" "${output}"
	[ "${status}" -eq 0 ]
	echo "${output}" | grep -q "УСПЕШНО"
}