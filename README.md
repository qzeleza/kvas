![GitHub Repo stars](https://img.shields.io/github/stars/qzeleza/kvas?color=orange) ![GitHub closed issues](https://img.shields.io/github/issues-closed/qzeleza/kvas?color=success) ![GitHub last commit](https://img.shields.io/github/last-commit/qzeleza/kvas) ![GitHub commit activity](https://img.shields.io/github/commit-activity/y/qzeleza/kvas) ![GitHub top language](https://img.shields.io/github/languages/top/qzeleza/kvas) ![GitHub code size in bytes](https://img.shields.io/github/languages/code-size/qzeleza/kvas) 
# [КВАС](https://forum.keenetic.com/topic/14415-пробуем-квас-shadowsocks-и-другие-vpn-клиенты) - защита ваших подключений #

---

#### Внимание! 
Открыта [группа в Телеграмм](https://t.me/kvas_pro) с целью оперативного обмена информацией по проекту. 

---


### VPN и SHADOWSOCKS клиент для [роутеров Keenetic](https://keenetic.ru/ru/)

#### Пакет представляет собой обвязку или интерфейс командной строки для защиты Вашего соединения при обращении к определенным доменам.

#### В пакете реализуется связка: **ipset** + один из вариантов связки DNS сервера:
- **dnsmasq (с поддержкой wildcard)** + **dnscrypt-proxy2** + блокировщик рекламы **adblock** или
- **AdGuardHome** (уже всключает в себя и шифрование **DNS** трафика и блокировщик рекламы).

> В связи с использованием в пакете утилиты dnsmasq с **wildcard**, можно работать с любыми доменными именами третьего и выше уровней. 
> Т.е. в белый список достаточно добавить ***domen.com** и маршрутизация трафика 
> будет идти как к **sub1.domen.com**, так и к любому другому поддоменному имени типа **subN.domen.com**.


## Возможности
1. **Квас** работает на всех платформах произведенных **Keenetic** устройств, ввиду легковесности задействованных пакетов: **mips, mipsel, aarch64**.
2. **Квас** использует **dnsmasq**, ***с поддержкой регулярных выражений***, а это в свою очередь дает одно, но большое преимущество: можно работать с соцсетями и прочими высоко-нагруженными сайтами, добавив лишь корневые домены по этим сайтам.
3. **Квас** позволяет **отображать статус/отключать/включать** блокировку рекламы (модуль **adblock** + **dnsmasq**);
4. **Квас** позволяет **отображать статус/отключать/включать** шифрование **DNS** (пакет **dnscrypt-proxy2**);
5. **Квас** позволяет тестировать и выводить отладочную информацию по всем элементам связки **ipset +  ( dnsmasq + dnscrypt-proxy2 ) | AdGuardHome**
6. **Квас** позволяет подключить **AdGuardHome** в качестве **DNS** сервера, вместо связки **dnsmasq + dnscrypt-proxy2 + adblock**.
7**Квас** позволяет оперировать со списком исключений при блокировки рекламы, добавляет и удаляет домены в этом списке.

## Установка пакета 
1. Зайдите в **entware** своего роутера и введите команду `curl -sOfL http://kvas.zeleza.ru/install && sh install`. 
2. Далее, следуйте инструкциям на экране.
3. Подробности читайте [здесь](https://github.com/qzeleza/kvas/wiki/Установка-пакета)

## Используемые в проекте продукты
- Для проведения тестов, в проекте используется пакет [BATS](https://github.com/bats-core/bats-core/blob/master/LICENSE.md) от нескольких [АВТОРОВ](https://github.com/bats-core/bats-core/blob/master/AUTHORS).

## Помощь проекту
Помочь можно переводом средств на [этот кошелек ЮМани](https://yoomoney.ru/to/4100117756734493).

## Документация по проекту
- [Перейти по cсылке](https://github.com/qzeleza/kvas/wiki).

## Каталог всех версий проекта
- [Перейти по cсылке](https://github.com/qzeleza/kvas/tree/main/ipk)

## История "Звезд"

[![Star History Chart](https://api.star-history.com/svg?repos=qzeleza/kvas&type=Timeline)](https://star-history.com/#qzeleza/kvas&Timeline)

--- 

