include $(TOPDIR)/rules.mk

PKG_NAME:=kvas
PKG_VERSION:=1.1.9
PKG_RELEASE:=beta_3
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION)-$(PKG_RELEASE)

include $(INCLUDE_DIR)/package.mk

define Package/kvas
	SECTION:=utils
	CATEGORY:=Keendev
	# DEPENDS:=+jq +curl +knot-dig +libpcre +nano-full +cron +bind-dig +dnsmasq-full +ipset +dnscrypt-proxy2 +iptables +libopenssl +shadowsocks-rust   
	DEPENDS:=+libpcre +jq +curl +knot-dig +nano-full +cron +bind-dig +dnsmasq-full +ipset +dnscrypt-proxy2 +iptables +shadowsocks-libev-ss-redir +shadowsocks-libev-config
	URL:=no
	TITLE:=VPN клиент для обработки запросов по внесению хостов в белый список.
	PKGARCH:=all
endef
# +libstdcpp 
define Package/kvas/description
	Данный пакет позволяет осуществлять контроль и поддерживать в актуальном состоянии
	защищенный список хостов или "Белый список". При обращении к любому хосту из
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
	$(INSTALL_DIR) $(1)/opt/apps/kvas

	$(INSTALL_BIN) opt/etc/ndm/fs.d/100-ipset $(1)/opt/etc/ndm/fs.d
	$(INSTALL_BIN) opt/etc/ndm/netfilter.d/100-proxy-redirect $(1)/opt/etc/ndm/netfilter.d
	$(INSTALL_BIN) opt/etc/ndm/netfilter.d/100-dns-local $(1)/opt/etc/ndm/netfilter.d

	$(INSTALL_BIN) opt/etc/init.d/S96kvas $(1)/opt/etc/init.d
	$(CP) ./opt/. $(1)/opt/apps/kvas
endef

#---------------------------------------------------------------------
# Скрипт создаем, который выполняется после инсталляции пакета
# Задаем в кроне время обновления ip адресов хостов
#---------------------------------------------------------------------
define Package/kvas/postinst

#!/bin/sh

BLUE="\033[36m";
NOCL="\033[m";

print_line()(printf "%83s\n" | tr " " "=")

chmod -R +x /opt/apps/kvas/bin/*
chmod -R +x /opt/apps/kvas/sbin/dnsmasq/*
chmod -R +x /opt/apps/kvas/etc/init.d/*
chmod -R +x /opt/apps/kvas/etc/ndm/*

ln -sf /opt/apps/kvas/bin/kvas /opt/bin/kvas

cp -f /opt/apps/kvas/etc/conf/kvas.conf /opt/etc/kvas.conf
[ -f /opt/etc/hosts.list ] || cp -f /opt/apps/kvas/etc/conf/hosts.list /opt/etc/hosts.list
mkdir -p /opt/etc/adblock /opt/etc/dnsmasq.d
cp -f /opt/apps/kvas/etc/conf/adblock.sources /opt/etc/adblock/sources.list
cp -f /opt/apps/kvas/etc/ndm/ndm /opt/apps/kvas/bin/libs/ndm

sed -i "s/\(APP_VERSION=\).*/\1$(PKG_VERSION)/; s/^,//; s/\,/ /g;" "/opt/etc/kvas.conf"
sed -i "s/\(APP_RELEASE=\).*/\1$(PKG_RELEASE)/; s/^,//; s/\,/ /g;" "/opt/etc/kvas.conf"

print_line
echo -e "Для настройки пакета КВАС наберите \033[36mkvas setup\033[m"
print_line

endef

#---------------------------------------------------------------------
# Создаем скрипт, который выполняется при удалении пакета
# Удаляем из крона запись об обновлении ip адресов
#---------------------------------------------------------------------
define Package/kvas/postrm

#!/bin/sh

endef

$(eval $(call BuildPackage,kvas))
