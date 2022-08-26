#!/usr/bin/env bats
source ../tests_lib
lib_load=". /opt/bin/kvas_lib_vpn"
dnsmasq_conf='/opt/etc/dnsmasq_conf.conf'
adblock_bin_file_copy='/opt/apps/kvas/files/bin/kvas_adblock'
adblock_bin_file='/opt/bin/kvas_adblock'
adblock_src_file=/opt/etc/adblock.sources
adblock_src_file_copy=/opt/apps/kvas/files/etc/conf/adblock.sources


TEST_NoN_IPv6_INTERFACE=Wireguard0
TEST_IPv6_INTERFACE=OpenVPN0
TEST_NOT_EXIST_INTERFACE=Wireguard8
TEST_EXIST_INTERFACE=OpenVPN0


@test "Проверка включения IPv6 на существующем интерфейсе ${TEST_EXIST_INTERFACE} CLI в системе [ipv6_inface_status]" {
	cmd="ipv6_inface_on ${TEST_EXIST_INTERFACE}"
	run on_server "${lib_load} && ${cmd} "
	print_on_error "${status}" "${output}"

	[ "${status}" -eq 0 ]

	cmd="ipv6_inface_status ${TEST_EXIST_INTERFACE}"
	run on_server "${lib_load} && ${cmd} "
	print_on_error "${status}" "${output}"

	[ "${status}" -eq 0 ]
	echo "${output}" | grep -q "ПОДКЛЮЧЕНА"

}
@test "Проверка отключения IPv6 на существующем интерфейсе ${TEST_NOT_EXIST_INTERFACE} CLI в системе [ipv6_inface_status]" {
	cmd="ipv6_inface_off ${TEST_EXIST_INTERFACE}"
	run on_server "${lib_load} && ${cmd} "
	print_on_error "${status}" "${output}"

	[ "${status}" -eq 0 ]

	cmd="ipv6_inface_status ${TEST_NOT_EXIST_INTERFACE}"
	run on_server "${lib_load} && ${cmd} "
	print_on_error "${status}" "${output}"

	[ "${status}" -eq 0 ]
	echo "${output}" | grep -q "НЕ ВОЗМОЖНА"

}
@test "Проверка наличия несуществующего интерфейса ${TEST_NOT_EXIST_INTERFACE} CLI в системе [ipv6_inface_status]" {
	cmd="ipv6_inface_status ${TEST_NOT_EXIST_INTERFACE}"
	run on_server "${lib_load} && ${cmd} "
	print_on_error "${status}" "${output}"

	[ "${status}" -eq 0 ]
	echo "${output}" | grep -q "НЕ ВОЗМОЖНА"

}

