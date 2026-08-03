#!/bin/bash
# ==============================================================================
# HARDENING: POSTGRESQL (PUERTO 5432)
# ==============================================================================
set -euo pipefail

if [ "$EUID" -ne 0 ]; then
  echo "[-] Ejecuta este script como root (sudo)."
  exit 1
fi

echo "[+] Asegurando PostgreSQL..."

PG_VER=$(ls /etc/postgresql/ 2>/dev/null | tail -n 1)

if [ -n "$PG_VER" ]; then
    PG_CONF="/etc/postgresql/$PG_VER/main/postgresql.conf"
    
    if [ -f "$PG_CONF" ]; then
        # Bind a localhost únicamente
        sed -i "s/^#listen_addresses = .*/listen_addresses = 'localhost'/" "$PG_CONF"
        sed -i "s/^listen_addresses = .*/listen_addresses = 'localhost'/" "$PG_CONF"
        
        # Bloqueo en Firewall de tráfico externo al puerto 5432
        if command -v ufw >/dev/null 2>&1; then
            ufw deny 5432/tcp comment 'Bloqueo PostgreSQL Externo'
        fi

        systemctl restart postgresql
        echo "[✓] PostgreSQL forzado a localhost y protegido."
    fi
else
    echo "[-] PostgreSQL no está instalado en este sistema."
fi