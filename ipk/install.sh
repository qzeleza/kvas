
last_package_ver=$(curl -s https://github.com/qzeleza/kvas/releases | grep "Версия" | head -1| sed -n 's/.*Версия\(.*\)<\/h.*/\1/p' | tr -d ' ')
file_name=kvas_${last_package_ver}_all.ipk
package_name=https://github.com/qzeleza/kvas/releases/download/v${last_package_ver}/${file_name}

mkdir -p /opt/packages
cd /opt/packages || {
	echo "Невозможно создать папку /opt/packages";
	exit 1
}
echo 'Установка пакета, ждите...'
echo ----------------------------------------------------------------
opkg update && opkg upgrade && opkg install curl iptables &>/dev/null
curl -LsJO "${package_name}"  &>/dev/null
opkg install "./${file_name}" && clear && kvas setup
