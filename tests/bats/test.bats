#!/opt/apps/kvas/bats/bin/bats
source ../tests_lib
lib_load=". /opt/bin/kvas_lib_vpn"
dnsmasq_conf='/opt/etc/dnsmasq_conf.conf'
adblock_bin_file_copy='/opt/apps/kvas/files/bin/kvas_adblock'
adblock_bin_file='/opt/bin/kvas_adblock'
adblock_src_file=/opt/etc/adblock.sources
adblock_src_file_copy=/opt/apps/kvas/files/etc/conf/adblock.sources



@test "Проверка наличия редактора nano для редактирования списка блокировки рекламы [cmd_ads_edit]" {
	cmd="opkg files nano-full"
	run on_server "${lib_load} && ${cmd} "

# 	в случае ошибок в тесте - будет вывод основных критериев работы
	echo "status=${status}"
	echo "output=${output}"

	[ "${status}" -eq 0 ]

	#	Блок проверок то, что точно должно быть при нормальной работе скрипта
	! echo "${output}" | grep -q "not installed"
	echo "${output}" | grep -q "nano"

}
