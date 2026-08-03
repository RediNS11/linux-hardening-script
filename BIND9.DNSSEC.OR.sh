#!/bin/bash
# ==============================================================================
# HARDENING: BIND9 DNS (DESACTIVAR RECURSIÓN + ACTIVAR DNSSEC)
# Uso: Para servidores que SÍ prestan servicio DNS oficial.
# ==============================================================================
set -euo pipefail

if [ "$EUID" -ne 0 ]; then
  echo "[-] Ejecuta este script como root (sudo)."
  exit 1
fi

CONF_FILE="/etc/bind/named.conf.options"

if [ -f "$CONF_FILE" ]; then
    echo "[+] Configurando BIND9..."

    # 1. Desactivar Recursión Abierta
    if grep -q "recursion " "$CONF_FILE"; then
        sed -i 's/recursion .*/recursion no;/' "$CONF_FILE"
    else
        sed -i '/options {/a \    recursion no;' "$CONF_FILE"
    fi

    # 2. Activar DNSSEC
    if grep -q "dnssec-validation " "$CONF_FILE"; then
        sed -i 's/dnssec-validation .*/dnssec-validation auto;/' "$CONF_FILE"
    else
        sed -i '/options {/a \    dnssec-validation auto;' "$CONF_FILE"
    fi

    # Validar sintaxis antes de reiniciar el servicio
    if named-checkconf; then
        systemctl restart bind9 2>/dev/null || systemctl restart named 2>/dev/null
        echo "[✓] BIND9 configurado: Recursión desactivada y DNSSEC activado."
    else
        echo "[-] Error de sintaxis en el archivo de configuración de BIND9."
        exit 1
    fi
else
    echo "[-] BIND9 (named.conf.options) no está instalado en el sistema."
fi