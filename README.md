
# [КВАС](https://forum.keenetic.com/topic/14415-пробуем-квас-shadowsocks-и-другие-vpn-клиенты/?do=findComment&comment=152234) - выборочный обход блокировок #

#### VPN и SHADOWSOCKS клиент для [роутеров Keenetic](https://keenetic.ru/ru/)
![GitHub Repo stars](https://img.shields.io/github/stars/qzeleza/kvas) ![GitHub commit activity](https://img.shields.io/github/commit-activity/m/qzeleza/kvas) ![GitHub top language](https://img.shields.io/github/languages/top/qzeleza/kvas) ![GitHub code size in bytes](https://img.shields.io/github/languages/code-size/qzeleza/kvas) ![GitHub last commit](https://img.shields.io/github/last-commit/qzeleza/kvas)
---
- Разработка проекта ведется на IDE от компании [JetBrains](https://www.jetbrains.com/ru-ru/). 
- Для проведения тестов, в проекте используется пакет [BATS](https://github.com/bats-core/bats-core/blob/master/LICENSE.md) от нескольких [АВТОРОВ](https://github.com/bats-core/bats-core/blob/master/AUTHORS). 

---

#### Пакет представляет собой обвязку или интерфейс командной строки для работы с белым списком.

Данный пакет позволяет осуществлять
контроль и поддерживать в актуальном состоянии 
список разблокировки хостов или "Белый список". 
При обращении к любому хосту из этого списка, 
весь трафик будет идти через фактические любое 
VPN соединение, заранее настроенное на роутере, 
или через Shadowsocks соединение. 

---

В пакете реализуется связка: **ipset** + **vpn** | **shadowsocks** + [ **dnsmasq (wildcard)** + **dnscrypt-proxy2** ] | **AdGuardHome**.

---

В связи с использованием в пакете утилиты dnsmasq с **wildcard**, можно работать с любыми доменными именами третьего и выше уровней. 
Т.е. в белый список достаточно добавить ***domen.com** и маршрутизация трафика 
будет идти как к **sub1.domen.com**, так и к любому другому поддоменному имени типа **subN.domen.com**.

Последние новости о пакете, комментарии и пожелания можно узнать и обсудить на форуме компании Keenetic - [forum.keenetic.com](https://forum.keenetic.com/topic/14415-%D0%BF%D1%80%D0%BE%D0%B1%D1%83%D0%B5%D0%BC-%D0%BA%D0%B2%D0%B0%D1%81-shadowsocks-%D0%B8-%D0%B4%D1%80%D1%83%D0%B3%D0%B8%D0%B5-vpn-%D0%BA%D0%BB%D0%B8%D0%B5%D0%BD%D1%82%D1%8B)

## Возможности
1. Квас работает на всех **роутерах Keenetic** ввиду легковесности задействованных пакетов (начиная с версии **0.9 beta 9** работает на всех платформах: **mips, mipsel, aarch64**)
2. Квас использует **dnsmasq**, ***с поддержкой регулярных выражений***, а это в свою очередь дает одно, но большое преимущество: можно работать с соцсетями и прочими высоко-нагруженными сайтами, добавив лишь корневые домены по этим сайтам.
3. Квас позволяет **просматривать/добавлять/удалять/очищать/обновлять/импортировать и экспортировать** доменные имена списка разблокировки или белого списка.
4. Квас позволяет **отображать статус/отключать/включать** блокировку рекламы
5. Квас позволяет **отображать статус/отключать/включать** шифрование DNS
6. Квас позволяет тестировать и выводить отладочную информацию по всем элементам связки **ipset + vpn | shadowsocks + [ dnsmasq + dnscrypt-proxy2 ] | AdGuardHome**
7. Начиная с версии 1.0 beta 8 добавлена возможность подключения AdGuardHome в качестве DNS сервера вместо связки [ dnsmasq + dnscrypt-proxy2 ].

[Перейти к документации по проекту](https://github.com/qzeleza/kvas/wiki).
