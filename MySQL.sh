#!/bin/bash
# ==============================================================================
# HARDENING: MYSQL / MARIADB (PUERTO 3306)
# ==============================================================================
set -euo pipefail

if [ "$EUID" -ne 0 ]; then
  echo "[-] Ejecuta este script como root (sudo)."
  exit 1
fi

echo "[+] Asegurando MySQL / MariaDB..."

CONF_FILE="/etc/mysql/mariadb.conf.d/50-server.cnf"
[ ! -f "$CONF_FILE" ] && CONF_FILE="/etc/mysql/mysql.conf.d/mysqld.cnf"

if [ -f "$CONF_FILE" ]; then
    # Bind a localhost únicamente
    sed -i 's/^bind-address.*/bind-address = 127.0.0.1/' "$CONF_FILE"
    
    # Bloqueo en Firewall de tráfico externo al puerto 3306
    if command -v ufw >/dev/null 2>&1; then
        ufw deny 3306/tcp comment 'Bloqueo MySQL Externo'
    fi

    systemctl restart mysql 2>/dev/null || systemctl restart mariadb 2>/dev/null || true
    echo "[✓] MySQL forzado a 127.0.0.1 y protegido."
else
    echo "[-] Archivo de configuración de MySQL/MariaDB no encontrado."
fi