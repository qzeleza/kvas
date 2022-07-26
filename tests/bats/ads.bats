#!/opt/apps/kvas/bats/bin/bats
. lib

#-----------------------------------------------------
# 	ТЕСТЫ из библиотеки kvas_lib_vpn
#-----------------------------------------------------
#@test "Проверка активации блока борьбы с рекламой при наличии архива [ads_request_to_upload]" {
#	lib_load=". /opt/bin/kvas_lib_vpn"
#	prefix="[ -f /opt/etc/adblock.sources ] \
#			&& cp -f /opt/etc/adblock.sources /opt/etc/adblock.sources.kvas \
#			|| cp -f /opt/apps/kvas/files/etc/conf/adblock.sources /opt/etc/adblock.sources"
#	cmd="ads_request_to_upload"
#	postfix="[ -f /opt/etc/adblock.sources.kvas ] \
#			  && rm -f /opt/etc/adblock.sources.kvas \
#			  || rm -f /opt/etc/adblock.sources"
#	run on_server "${lib_load} && ${prefix} && ${cmd} ask" <<< y
#	echo "status=${status}"
#	echo "output=${output}"
#	[ "${status}" -eq 0 ]
#    [[ "${output}" == *"УДАЧНО"* ]]
#    run on_server "${lib_load} && ${postfix}"
#}
@test "Проверка активации блока борьбы с рекламой при наличии архива [ads_request_to_upload]" {
	lib_load=". /opt/bin/kvas_lib_vpn"
	prefix="[ -f /opt/etc/adblock.sources ] \
			&& cp -f /opt/etc/adblock.sources /opt/etc/adblock.sources.kvas \
			|| cp -f /opt/apps/kvas/files/etc/conf/adblock.sources /opt/etc/adblock.sources"
	cmd="ads_request_to_upload"
	postfix="[ -f /opt/etc/adblock.sources.kvas ] \
			  && rm -f /opt/etc/adblock.sources.kvas \
			  || rm -f /opt/etc/adblock.sources"
	run on_server "${lib_load} && ${prefix} && ${cmd} ask" <<< y
	echo "status=${status}"
	echo "output=${output}"
	[ "${status}" -eq 0 ]
	[[ "${output}" == *"Обнаружен архивный файл"* ]]
    [[ "${output}" == *"УДАЧНО"* ]]
    run on_server "${lib_load} && ${postfix}"
}
