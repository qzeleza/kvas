#!/bin/sh

RED="\033[1;31m";
GREEN="\033[1;32m";
NOCL="\033[m";
LENGTH=68
print_line()(printf "%83s\n" | tr " " "-")
diff_len() {
	charlen=$(echo "${1}" | sed -r "s/[\]033\[([0-9]{1,3}(;[0-9]{1,2})?)?[mGK]//g")
	charlen=${#charlen}
	echo $(( LENGTH - charlen ))
}
ready() {
        size=$(diff_len "${1}")
        printf "%b%-${size}s%b" "${1}"
}
when_ok() (echo -e "${GREEN}ГОТОВО${NOCL}")
when_err() (echo -e "${RED}ОШИБКА${NOCL}" )

package_name=kvas_all.ipk
package_url=https://github.com/qzeleza/kvas/releases/latest/download/${package_name}
list_backup=/opt/etc/hosts.list.backup


print_line
ready "${GREEN}Начинаем установку пакета КВАС${NOCL}"
echo
mkdir -p /opt/packages
cd /opt/packages || {
        echo "Невозможно создать папку /opt/packages";
        exit 1
}
print_line
ready 'Обновляем opkg...            '
{
        opkg update && opkg upgrade && opkg install curl iptables
} &>/dev/null && when_ok || when_err

ready 'Загружаем пакет...            '
{
        [ -f /opt/bin/kvas ] && kvas export ${list_backup}
        curl -L "${package_url}" -o  ${package_name}
} &>/dev/null && when_ok || when_err

ready 'Устанавливаем пакет...            '
{
        opkg install "./${package_name}"
} &>/dev/null && when_ok || when_err
print_line
sleep 2
{
	    clear
        kvas setup
} && rm -f ./install.sh

