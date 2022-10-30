include $(TOPDIR)/rules.mk

PKG_NAME:=kvas
PKG_VERSION:=1.0
PKG_RELEASE:=beta_19
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/kvas
	SECTION:=utils
	CATEGORY:=Keendev
	DEPENDS:=+jq +curl +knot-dig +nano-full +cron +bind-dig +dnsmasq-full +ipset +iptables +shadowsocks-libev-ss-redir +shadowsocks-libev-config +libpcre +dnscrypt-proxy2
	URL:=no
	TITLE:=VPN клиент для обработки запросов по внесению хостов в белый список.
	PKGARCH:=all
endef

define Package/kvas/description
	Данный пакет позволяет осуществлять контроль и поддерживать в актуальном состоянии
	список разблокировки хостов или "Белый список". При обращении к любому хосту из
	этого списка, весь трафик будет идти через любое VPN или через Shadowsocks соединение,
	заранее настроенное на роутере.
endef

define Build/Prepare
endef
define Build/Configure
endef
define Build/Compile
endef

# Во время инсталляции задаем папку в которую будем
# копировать наш скрипт и затем копируем его в эту папку
define Package/kvas/install

	$(INSTALL_DIR) $(1)/opt/etc/init.d
	$(INSTALL_DIR) $(1)/opt/etc/ndm/fs.d
	$(INSTALL_DIR) $(1)/opt/etc/ndm/netfilter.d
	$(INSTALL_DIR) $(1)/opt/"/apps/kvas"

	$(INSTALL_BIN) ./files/etc/ndm/fs.d/100-ipset $(1)/opt/etc/ndm/fs.d
	$(INSTALL_BIN) ./files/etc/ndm/netfilter.d/100-proxy-redirect $(1)/opt/etc/ndm/netfilter.d
	$(INSTALL_BIN) ./files/etc/ndm/netfilter.d/100-dns-local $(1)/opt/etc/ndm/netfilter.d

	$(INSTALL_BIN) ./files/etc/init.d/S96kvas $(1)/opt/etc/init.d
	$(CP) ./files/. $(1)/opt/"/apps/kvas"

endef

#---------------------------------------------------------------------
# Скрипт создаем, который выполняется после инсталляции пакета
# Задаем в кроне время обновления ip адресов хостов
#---------------------------------------------------------------------
define Package/kvas/postinst

#!/bin/sh

# Пишем сообщение в лог роутера о начале устаноки пакета
logger -p err -t "PACKAGE INSTALLATION " "!!!!!! УСТАНОВКА ПАКЕТА КВАС !!!!!!"

# В случае проблем с инсталляцией пакета ставим в значение true
DEBUG=false

chmod -R +x /opt/apps/kvas/bin/*
chmod -R +x /opt/apps/kvas/sbin/dnsmasq/*
chmod -R +x /opt/apps/kvas/etc/init.d/*
chmod -R +x /opt/apps/kvas/etc/ndm/*

ln -sf /opt/apps/kvas/bin/kvas /opt/bin/kvas

cp -f /opt/apps/kvas/etc/conf/kvas.conf /opt/etc/kvas.conf
cp -f /opt/apps/kvas/etc/conf/adblock.sources /opt/etc/adblock.sources

# Делаем копии файлов для того чтобы была возможность
# использовать функции в них в скрипте при удалении пакета
cp -f /opt/apps/kvas/bin/libs/vpn /opt/apps/kvas/bin/libs/.vpn
cp -f /opt/apps/kvas/bin/libs/main /opt/apps/kvas/bin/libs/.main
cp -f /opt/apps/kvas/bin/libs/debug /opt/apps/kvas/bin/libs/.debug
cp -f /opt/apps/kvas/etc/ndm/ndm /opt/apps/kvas/bin/libs/ndm

. /opt/apps/kvas/bin/libs/vpn

mkdir -p "$${KVAS_BACKUP_PATH}"
cat /dev/null > "$${INSTALL_LOG}"

test_status(){
	[ "$${DEBUG}" = true ] && {
		[ -f /opt/etc/init.d/S99adguardhome ] && /opt/etc/init.d/S99adguardhome  status #&> /dev/null
		[ -f /opt/etc/init.d/S56dnsmasq ] && /opt/etc/init.d/S56dnsmasq  status #&> /dev/null
		[ -f /opt/etc/init.d/S09dnscrypt-proxy2 ] && /opt/etc/init.d/S09dnscrypt-proxy2  status
		get_config_value DNS_DEFAULT
		echo "Число строк в AdGuardHome.yaml $$(cat < /opt/etc/AdGuardHome/AdGuardHome.yaml | wc -l)"
			echo "Число записей $$(cat < "$${UNBLOCK_LIST_FILE}" | wc -l)"
	}
}
log_in_file(){
	if [ "$${1}" = line ]; then
		print_line >> "$${INSTALL_LOG}"
	else
		echo "$${1}" >> "$${INSTALL_LOG}"
	fi
}

print_line
welcome="Установка пакета КВАС™ версия 1.0-beta-19"
echo "$${welcome}"
print_line

log_in_file "$${welcome}"
log_in_file line
log_in_file "Начало установки: $$(date "$${DATE_FORMAT}")"
log_in_file line

# Проверяем отключено ли использование DNS провайдера
if ! curl -s "$${LOCALHOST_IP}"':79/rci/opkg/dns-override' | grep -q true ; then
    cli="$$(get_router_host)/a"
    log_in_file "ОШИБКА: Не отключено использование DNS провайдера."
	echo -e "$${RED}Для корректной работы DNS сервера необходимо отключить использование DNS провайдера!$${NOCL}"
	echo -e "С этой целью зайдите в админ панель роутера по адресу: $${GREEN}$${cli}$${NOCL}"
	echo "и выполните последовательно три следующих команды: "
	print_line
	echo -e "1. $${GREEN}opkg dns-override $${NOCL} - отключаем использование DNS провайдера,"
	echo -e "2. $${GREEN}system configuration save $${NOCL}  - сохраняем изменения,"
	echo -e "3. $${GREEN}system reboot $${NOCL} - перегружаем роутер."
	print_line
	exit 1
fi

#------------------------------------------------------
# Отключаем IPv6
#------------------------------------------------------
if [ "$$(ipv6_status)" = 0 ]; then
	ipv6_inface_off "$$(get_defaultgw_interface)"
fi

proxy_port=$$(get_config_value SSR_DNS_PORT)
local_ip=$$(get_router_ip)
inface=$$(get_inface_by_ip "$${local_ip}")
set_config_value DNSMASQ_LISTEN_IP "$${local_ip}"

#------------------------------------------------------
# Сейчас необходимо выбрать VPN интерфейс для работы пакета
#------------------------------------------------------
cmd_interface_change ask
log_in_file "$$(cmd_vpn_status)"
test_status
print_line
#------------------------------------------------------
# AdGuard Home
#------------------------------------------------------
answer_agh=n
if cmd_adguardhome_status | grep -qE "(ВКЛЮЧЕН|ОТКЛЮЧЕН)" ; then
	warning "На роутере обнаружен AdGuard Home "
	read_ynq "Установить AdGuard Home, как основной DNS сервер" answer_agh
	if [ "$${answer_agh}" = y ]; then
		cmd_adguardhome_on
		log_in_file "AdGuard Home НАСТРОЕН, как основной DNS сервер"
	else
		log_in_file "AdGuard Home пропущен."
		cmd_adguardhome_status | grep -q "ВКЛЮЧЕН" && {
			ready "Останавливаем сервис AdGuard Home..."
			/opt/etc/init.d/S99adguardhome stop &> /dev/null
			if /opt/etc/init.d/S99adguardhome status | grep -q dead; then
				when_ok "ГОТОВО"
			else
				when_bad "ОШИБКА"
				mess="Невозможно остановить сервис AdGuard Home"
				error "$${mess}"
				log_in_file "ОШИБКА: $${mess}"
				exit 1
			fi
		}
		cp /opt/etc/AdGuardHome/AdGuardHome.yaml "$${KVAS_BACKUP_PATH}"/AdGuardHome.yaml
	fi
	print_line
fi

test_status
#------------------------------------------------------
# 	ГОТОВИМ ФАЙЛЫ НЕ ЗАВИСЯЩИЕ ОТ КОНФИГУРАЦИИ ПАКЕТА
#------------------------------------------------------
ready "Настройка файлов конфигурации пакета"
[ -f /opt/etc/ndm/netfilter.d/100-dns-local ] \
	&& sed -i "s/@LOCAL_IP/$${local_ip}/g; s/@INFACE/$${inface}/g;" /opt/etc/ndm/netfilter.d/100-dns-local \
	|| {
		log_in_file "ОШИБКА: отсутствует файл /opt/etc/ndm/netfilter.d/100-dns-local"
		error "Отсутствует файл /opt/etc/ndm/netfilter.d/100-dns-local";
		warning "Проблема повторной установки. Удалите и установите пакет заново.";
		exit 1;
	}

[ $$? = 0 ] && when_ok "ГОТОВО" || {
	when_bad "ОШИБКА"
	log_in_file "ОШИБКА: при настройке файлов конфигурации пакета"
	exit 1
}
test_status
#------------------------------------------------------
# ВОССТАНАВЛИВАЕМ ФАЙЛ СО СПИСКОМ РАЗБЛОКИРОВКИ
#------------------------------------------------------
if [ -f "$${UNBLOCK_LIST_FILE}.kvas" ]; then
	warning "Обнаружен список разблокировки от предыдущей установки"
	log_in_file "Список разблокировки ВОССТАНОВЛЕН из архива."
	ready "Список разблокировки восстановлен"
	mv -f "$${UNBLOCK_LIST_FILE}.kvas" "$${UNBLOCK_LIST_FILE}"
	[ $$? = 0 ] && when_ok "УСПЕШНО" || {
		when_bad "ОШИБКА"
		log_in_file "ОШИБКА: при восстановлении списка разблокировки"
		exit 1
	}
else
	log_in_file "УСТАНОВЛЕН список разблокировки ПО УМОЛЧАНИЮ."
	ready "Копируем файл со списком разблокировки по умолчанию"
	cp /opt/apps/kvas/etc/conf/hosts.list "$${UNBLOCK_LIST_FILE}" &>/dev/null
	[ $$? = 0 ] && when_ok "УСПЕШНО" || {
		when_bad "ОШИБКА"
		log_in_file "ОШИБКА: при копировании списка разблокировки по умолчанию"
		exit 1
	}
fi
test_status
#----------------------------------------------------------
#
# 	В случае, если установить AdGuard Home отказались
# 	или не был обнаружен сервис AdGuard Home
# 	AdGuard Home подменяет сразу несколько сервисов
# 	таких как dnsmasq + dnscrypt_proxy2 + блокировка рекламы
#
#----------------------------------------------------------
 
if [ "$${answer_agh}" = n ]; then
	if [ -f "$${ADGUARDHOME_DEMON}" ]; then
		if "$${ADGUARDHOME_DEMON}" status | grep -q alive; then
			"$${ADGUARDHOME_DEMON}" stop &> /dev/null
		fi
	fi
	#------------------------------------------------------
	# DNSMASQ
	#------------------------------------------------------
	dnsmasq_install "install"
	test_status
	#------------------------------------------------------
	# DNSCRYPT-PROXY2
	#------------------------------------------------------
	dns_crypt_install "install"
	log_in_file "Шифрование DNS трафика (dnscrypt-proxy2) ВКЛЮЧЕНО."
	test_status
	#------------------------------------------------------
	# Блокировка рекламы
	#------------------------------------------------------
	log_in_file "Блокировка рекламы НЕ УСТАНОВЛЕНА.."
	print_line
#	fi
	test_status
fi
 

#------------------------------------------------------
# 	УСТАНОВКА ОБНОВЛЕНИЯ ДАННЫХ В CRON
#------------------------------------------------------
ready "Ставим обновление ip адресов по умолчанию - каждые 12 часов..."
cmd_set_period_update "12h" &> /dev/null
[ $$? = 0 ] && when_ok "ГОТОВО" || {
	when_bad "ОШИБКА"
	mess="Проблема при установки задания в cron"
	log_in_file "ОШИБКА: $${mess}"
	exit 1
}
#cmd_update_list
test_status

#  проверяем был ли сделал выбор AdGuard Home в качестве DNS сервера

if [ "$${answer_agh}" = n ]; then
	ready "Запускаем КВАС в работу"
	"$${KVAS_START_FILE}" start &> /dev/null
	[ $$? = 0 ] && when_ok "УСПЕШНО" || {
		when_bad "ОШИБКА"
		mess="Проблема при запуске КВАСа"
		log_in_file "ОШИБКА: $${mess}"
		exit 1
	}
fi

test_status
print_line
#log_in_file "Был произведен запуск диагностики после установки."
#warning "ПРОИЗВОДИМ ТЕСТИРОВАНИЕ УСТАНОВЛЕННОГО VPN СОЕДИНЕНИЯ"
#print_line
#. /opt/apps/kvas/bin/libs/check
#cmd_state_checker
#print_line

#test_status

log_in_file line
log_in_file "Установка завершена: $$(date "$${DATE_FORMAT}")"
echo "Установка КВАСа завершена."
echo -e "Для общей справки наберите $${BLUE}kvas help$${NOCL}"
print_line

endef

#---------------------------------------------------------------------
# Создаем скрипт, который выполняется при удалении пакета
# Удаляем из крона запись об обновлении ip адресов
#---------------------------------------------------------------------
define Package/kvas/postrm

#!/bin/sh

. /opt/apps/kvas/bin/libs/.vpn
. /opt/apps/kvas/bin/libs/ndm
#------------------------------------------------------------------------------
#
#	ПАКЕТ КВАС
#
#------------------------------------------------------------------------------
#
#	Данный файл служит для удаления пакета Квас с роутера
#
# ------------------------------------------------------------------------------
#	Разработчик: mail@zeleza.ru
#	Дата создания: 21/05/2022
#	Лицензия: GPL 2.0
# ------------------------------------------------------------------------------

#------------------------------------------------------
# 	УДАЛЕНИЕ ФАЙЛОВ КОНФИГУРАЦИИ
#------------------------------------------------------
rm_package_files(){

	[ -f /opt/etc/hosts.list ] && mv -f /opt/etc/hosts.list /opt/etc/hosts.list.kvas
	[ -f /opt/etc/adblock.sources ] && mv -f /opt/etc/adblock.sources /opt/etc/adblock.sources.kvas

	[ -f /opt/etc/ndm/fs.d/100-vpn ] && rm -f /opt/etc/ndm/fs.d/100-vpn
	[ -f /opt/etc/ndm/netfilter.d/100-vpn-mark ] && rm -f /opt/etc/ndm/netfilter.d/100-vpn-mark
	[ -f /opt/etc/ndm/ifstatechanged.d/100-unblock-vpn ] && rm -f /opt/etc/ndm/ifstatechanged.d/100-unblock-vpn
	[ -d /opt/tmp/adblock ] && rm -rf /opt/tmp/adblock

	rm -rf /opt/bin/kvas
	rm -fr /opt/etc/kvas*
	rm -f /opt/lib/opkg/info/kvas*
	rm -f /opt/etc/inface_equals
}

print_line
echo -e "Удаление пакета $${GREEN}КВАС™$${NOCL} версия $${GREEN}1.0-beta-19$${NOCL}..."
print_line

answer='y';
# read_ynq "Удалить файлы конфигурации пакета" answer
if [ "$${answer}" = y ]; then
	ready "Удаляем файлы конфигурации..."
	if rm_package_files ; then when_ok "УСПЕШНО"; else when_bad "ОШИБКА"; fi
fi

ready "Удаляем данные из cron..."
sed -i '/ipset/d' /opt/etc/crontab &>/dev/null && when_ok "УСПЕШНО" || when_bad "ОШИБКА"

#------------------------------------------------------
# 	ОЧИЩЕНИЕ ВСЕХ ПРАВИЛ И ТАБЛИЦ
#------------------------------------------------------
ready "Очищаем все правила и таблицы..."
ip4_firewall_flush_all_rules &>/dev/null
ip4_flush_all_tables &>/dev/null
if [ $$? = 0 ]; then when_ok "УСПЕШНО"; else when_bad "ОШИБКА"; fi

print_line
echo "При установке пакета КВАС™ были установлены следующие пакеты:"
warning "shadowsocks-libev-ss-redir knot-dig iptables curl cron libpcre"
warning "shadowsocks-libev-config dnsmasq-full nano-full bind-dig ipset jq"
echo "Если данные пакеты Вами больше не используются, Вы можете их удалить следующей"
echo -e "командой:  $${RED}opkg remove kvas --autoremove$${NOCL} все сразу, либо"
echo -e "командой $${RED}opkg remove <package1 package2 package3...>$${NOCL}."

print_line
echo "Удаление КВАСа завершено."
print_line
# удаляем файлы пакета крайним шагом
rm -fr /opt/apps/kvas

endef

$(eval $(call BuildPackage,kvas))
