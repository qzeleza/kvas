#!/bin/sh

package_name=kvas_all.ipk
package_url=https://github.com/qzeleza/kvas/releases/latest/download/${package_name}
list_backup=/opt/etc/hosts.list.backup

mkdir -p /opt/packages
cd /opt/packages || {
	echo "Невозможно создать папку /opt/packages";
	exit 1
}
clear
echo ----------------------------------------------------------------
echo 'Загрузка пакета, ждите...'
echo ----------------------------------------------------------------
{
	opkg update && opkg upgrade && opkg install curl iptables
} &>/dev/null && {
	echo "ГОТОВО"
	echo ----------------------------------------------------------------
	echo наберите 'kvas setup' для настройки пакета
	echo ----------------------------------------------------------------
}

[ -f /opt/bin/kvas ] && kvas export ${list_backup}
curl -L "${package_url}" -o  ${package_name} &>/dev/null
opkg install "./${package_name}" &>/dev/null
rm -f ./install.sh
