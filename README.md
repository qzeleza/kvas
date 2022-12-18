![GitHub Repo stars](https://img.shields.io/github/stars/qzeleza/kvas?color=orange) ![GitHub closed issues](https://img.shields.io/github/issues-closed/qzeleza/kvas?color=success) ![GitHub last commit](https://img.shields.io/github/last-commit/qzeleza/kvas) ![GitHub commit activity](https://img.shields.io/github/commit-activity/y/qzeleza/kvas) ![GitHub top language](https://img.shields.io/github/languages/top/qzeleza/kvas) ![GitHub code size in bytes](https://img.shields.io/github/languages/code-size/qzeleza/kvas) 
# [КВАС](https://forum.keenetic.com/topic/14415-пробуем-квас-shadowsocks-и-другие-vpn-клиенты) - выборочный обход блокировок #

### VPN и SHADOWSOCKS клиент для [роутеров Keenetic](https://keenetic.ru/ru/)

#### Пакет представляет собой обвязку или интерфейс командной строки для работы с белым списком.

> Данный пакет позволяет осуществлять контроль и поддерживать в актуальном состоянии 
> список разблокировки хостов или "Белый список". При обращении к любому хосту из этого списка, 
> весь трафик будет идти через фактические любое VPN соединение, заранее настроенное на роутере, 
> или через Shadowsocks соединение. 

#### В пакете реализуется связка: **ipset** + **vpn** | **shadowsocks** + [ **dnsmasq (wildcard)** + **dnscrypt-proxy2** ] | **AdGuardHome**.

> В связи с использованием в пакете утилиты dnsmasq с **wildcard**, можно работать с любыми доменными именами третьего и выше уровней. 
> Т.е. в белый список достаточно добавить ***domen.com** и маршрутизация трафика 
> будет идти как к **sub1.domen.com**, так и к любому другому поддоменному имени типа **subN.domen.com**.



## Возможности
1. Квас работает на всех платформах произведенных **Keenetic** устройств, ввиду легковесности задействованных пакетов: **mips, mipsel, aarch64**.
2. Квас использует **dnsmasq**, ***с поддержкой регулярных выражений***, а это в свою очередь дает одно, но большое преимущество: можно работать с соцсетями и прочими высоко-нагруженными сайтами, добавив лишь корневые домены по этим сайтам.
3. Квас позволяет **просматривать/добавлять/удалять/очищать/обновлять/импортировать и экспортировать** доменные имена списка разблокировки или Белого списка.
4. Квас позволяет **отображать статус/отключать/включать** блокировку рекламы
5. Квас позволяет **отображать статус/отключать/включать** шифрование DNS
6. Квас позволяет тестировать и выводить отладочную информацию по всем элементам связки **ipset + vpn | shadowsocks + ( dnsmasq + dnscrypt-proxy2 ) | AdGuardHome**
7. Квас позволяет подключить AdGuard Home в качестве DNS сервера, вместо связки **dnsmasq + dnscrypt-proxy2**.
8. Квас позволяет подключить любые гостевые сети к доступу через установленное VPN соединение [команда bridge].
9. Квас позволяет оперировать со списком исключений при блокировки рекламы, добавляет и удаляет домены в этом списке.

## Используемые в проекте продукты
- Разработка проекта ведется на IDE от компании [JetBrains](https://www.jetbrains.com/ru-ru/).
- Для проведения тестов, в проекте используется пакет [BATS](https://github.com/bats-core/bats-core/blob/master/LICENSE.md) от нескольких [АВТОРОВ](https://github.com/bats-core/bats-core/blob/master/AUTHORS).


## Документация по проекту
- [Перейти по cсылке](https://github.com/qzeleza/kvas/wiki).
