#!/bin/bash

# URL файла с IP-диапазонами
URL="https://raw.githubusercontent.com/KotaruProject/ban-ips/main/ip_ranges.txt"

# Получение IP-диапазонов из файла
IP_RANGES=$(curl -s "$URL")

# Добавление каждого диапазона IP в список блокировки iptables
for RANGE in $IP_RANGES; do
    iptables -A INPUT -s $RANGE -j DROP
done

# Сохранение правил iptables
iptables-save > /etc/iptables/rules.v4

echo "Готово! IP-диапазоны были добавлены в список блокировки iptables."
