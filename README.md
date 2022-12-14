![GitHub Repo stars](https://img.shields.io/github/stars/qzeleza/kvas?color=orange) ![GitHub closed issues](https://img.shields.io/github/issues-closed/qzeleza/kvas?color=success) ![GitHub last commit](https://img.shields.io/github/last-commit/qzeleza/kvas) ![GitHub commit activity](https://img.shields.io/github/commit-activity/y/qzeleza/kvas) ![GitHub top language](https://img.shields.io/github/languages/top/qzeleza/kvas) ![GitHub code size in bytes](https://img.shields.io/github/languages/code-size/qzeleza/kvas) 
# [КВАС](https://forum.keenetic.com/topic/14415-пробуем-квас-shadowsocks-и-другие-vpn-клиенты/?do=findComment&comment=152234) - выборочный обход блокировок #

#### VPN и SHADOWSOCKS клиент для [роутеров Keenetic](https://keenetic.ru/ru/)

---

## Описание

Пакет представляет собой обвязку или интерфейс командной строки для работы с "**Белым списком**".
Данный пакет позволяет осуществлять
контроль и поддерживать в актуальном состоянии 
список разблокировки хостов или "**Белый список**". 
При обращении к любому хосту из этого списка, 
весь трафик будет идти через фактические любое 
**VPN** соединение, заранее настроенное на роутере, 
или через **Shadowsocks** соединение. 


## Возможности
1. Квас работает на всех **роутерах Keenetic** ввиду легковесности задействованных пакетов (начиная с версии **0.9 beta 9** работает на всех платформах: **mips, mipsel, aarch64**)
2. Квас использует **dnsmasq**, ***с поддержкой регулярных выражений***, а это в свою очередь дает одно, но большое преимущество: можно работать с соцсетями и прочими высоко-нагруженными сайтами, добавив лишь корневые домены по этим сайтам.
3. Квас позволяет **просматривать/добавлять/удалять/очищать/обновлять/импортировать и экспортировать** доменные имена списка разблокировки или белого списка.
4. Квас позволяет **отображать статус/отключать/включать** блокировку рекламы
5. Квас позволяет **отображать статус/отключать/включать** шифрование DNS
6. Квас позволяет тестировать и выводить отладочную информацию по всем элементам связки **ipset + vpn | shadowsocks + [ dnsmasq + dnscrypt-proxy2 ] | AdGuardHome**
7. Начиная с версии 1.0 beta 8, добавлена возможность подключения AdGuardHome в качестве DNS сервера вместо связки [ dnsmasq + dnscrypt-proxy2 ].

## Документация по проекту
- [Перейти по cсылке](https://github.com/qzeleza/kvas/wiki).

---

- Разработка проекта ведется на IDE от компании [JetBrains](https://www.jetbrains.com/ru-ru/). 
- Для проведения тестов, в проекте используется пакет [BATS](https://github.com/bats-core/bats-core/blob/master/LICENSE.md) от нескольких [АВТОРОВ](https://github.com/bats-core/bats-core/blob/master/AUTHORS). 
