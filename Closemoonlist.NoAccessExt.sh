#!/bin/bash
# ==============================================================================
# HARDENING: CONFIGURACIÓN DE NTPD (DESACTIVAR MONLIST Y RESTRINGIR CONSULTAS)
# ==============================================================================
set -euo pipefail

if [ "$EUID" -ne 0 ]; then
  echo "[-] Ejecuta este script como root (sudo)."
  exit 1
fi

NTP_CONF="/etc/ntp.conf"

if [ -f "$NTP_CONF" ]; then
    echo "[+] Asegurando archivo ntp.conf..."

    # Bloquear consultas externas predeterminadas
    if ! grep -q "restrict default nomodify nopeer noquery" "$NTP_CONF"; then
        echo "restrict default nomodify nopeer noquery" >> "$NTP_CONF"
    fi

    # Permitir acceso total únicamente a localhost
    if ! grep -q "restrict 127.0.0.1" "$NTP_CONF"; then
        echo "restrict 127.0.0.1" >> "$NTP_CONF"
        echo "restrict ::1" >> "$NTP_CONF"
    fi

    # Desactivar la función vulnerable monlist
    if ! grep -q "disable monitor" "$NTP_CONF"; then
        echo "disable monitor" >> "$NTP_CONF"
    fi

    systemctl restart ntp 2>/dev/null || systemctl restart ntpd 2>/dev/null || true
    echo "[✓] NTPD asegurado contra amplificación y consultas no autorizadas."
else
    echo "[-] Servidor NTPD no instalado (usando el cliente nativo del sistema)."
fi