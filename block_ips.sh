#!/bin/bash

# URL файла с IP-диапазонами
URL="https://raw.githubusercontent.com/KotaruProject/ban-ips/main/ip_ranges.txt"

# Получение IP-диапазонов из файла
IP_RANGES=$(curl -s "$URL")

# Функция для проверки существования правила в iptables
rule_exists() {
    iptables -C INPUT -s $1 -j REJECT &> /dev/null
    return $?
}

# Добавление каждого диапазона IP в список блокировки iptables, если правило еще не существует
for RANGE in $IP_RANGES; do
    if rule_exists $RANGE; then
        echo "Правило для $RANGE уже существует, пропускаем."
    else
        iptables -A INPUT -s $RANGE -j REJECT
        echo "Правило для $RANGE добавлено."
    fi
done

# Сохранение правил iptables
iptables-save > /etc/iptables/rules.v4

# Перезапуск сервиса iptables
systemctl restart iptables

echo "Готово! IP-диапазоны были добавлены в список блокировки iptables."
