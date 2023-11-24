#!/bin/sh

RED="\033[1;31m";
GREEN="\033[1;32m";
BLUE="\033[36m";
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
when_ready() (echo -e "${GREEN}ГОТОВО${NOCL}")
when_err() (echo -e "${RED}ОШИБКА${NOCL}" )

package_url=$(curl -sH "Accept: application/vnd.github.v3+json" https://api.github.com/repos/qzeleza/kvas/releases/latest | sed -n 's/.*browser_download_url\": "\(.*\)\"/\1/p;'| tr -d ' ' |  sed '/^$/d')
package_name=$(echo "${package_url}" | sed 's/.*\/\(.*ipk\)$/\1/')
list_backup=/opt/etc/hosts.list.backup
host_list=/opt/etc/hosts.list
rm_type="${1}"

clear
print_line
echo -e "${GREEN}Начинаем установку пакета КВАС${NOCL}"

mkdir -p /opt/packages || {
	echo "Невозможно создать папку /opt/packages";
	exit 1
}
print_line
ready 'Обновляем библиотеку пакетов opkg...'
{
	opkg update && opkg upgrade && opkg install curl iptables
} &>/dev/null && when_ready || when_err


ready 'Загружаем пакет...'
{

	cd /opt/packages
	rm -f "/opt/packages/${package_name}"
	curl -sOL "${package_url}"

} &>/dev/null && when_ready || when_err

[ ! -f "${package_name}" ] && {
	echo -e "${RED}Файл пакета не сохранен!${NOCL}"
	echo -e "${RED}Проверьте свое интернет соединение!${NOCL}"
	print_line
	exit 1
}

if [ -f /opt/bin/kvas ] && kvas | grep -q 'Настройка пакета не завершена' ; then
	ready 'Удаляем незавершенную ранее установку пакета...'
	kvas rm "${rm_type}" yes &>/dev/null && when_ready || when_err
else
	ready 'Сохраняем список разблокировки в архив...'
	kvas import "${list_backup}" &>/dev/null && when_ready || when_err
	[ -f /opt/bin/kvas ] && {
		ready 'Удаляем предыдущую версию пакета...'
		kvas rm "${rm_type}" yes &>/dev/null && when_ready || when_err

	}
fi

ver=$(echo "${package_name}" | sed 's/kvas_\(.*\)_all.*/\1/; s/-/ /g; s/_/-/' )
ready "Устанавливаем новую версию пакета [${ver}]..."
{
	opkg install "/opt/packages/${package_name}"

} &>/dev/null && when_ready || when_err

print_line

if [ ! -f /opt/bin/kvas ] ; then
	echo -e "${RED}Пакет установлен некорректно - отсутствуют исполняемые файлы!${NOCL}"
	echo -e "${GREEN}Попробуйте установить пакет вручную командой "
	echo -e "${BLUE}'opkg install /opt/packages/${package_name}'${NOCL}"
	print_line
	exit 1
else
	sleep 1

	clear
	kvas setup update

	[ -f "${list_backup}" ] && {
		ready 'Восстанавливаем список разблокировки из архива...'
		kvas import "${list_backup}" &>/dev/null && when_ready || when_err
	}

	echo 'Тестируем настройки...'
	kvas test
fi

rm -f ./update.sh