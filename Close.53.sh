#!/bin/bash
# ==============================================================================
# HARDENING: BLOQUEO DEL PUERTO 53 (DNS)
# Uso: Para servidores que NO prestan servicio DNS a la red.
# ==============================================================================
set -euo pipefail

if [ "$EUID" -ne 0 ]; then
  echo "[-] Ejecuta este script como root (sudo)."
  exit 1
fi

echo "[+] Aplicando bloqueo de puerto DNS (53)..."

if command -v ufw >/dev/null 2>&1; then
    # Bloquear peticiones DNS entrantes (UDP y TCP)
    ufw deny 53/udp comment 'Bloqueo DNS Entrante'
    ufw deny 53/tcp comment 'Bloqueo DNS Entrante'
    
    # Recargar UFW para asegurar la regla
    ufw reload >/dev/null 2>&1 || true
    echo "[✓] Puerto 53 bloqueado correctamente en UFW."
else
    echo "[-] UFW no está instalado en este sistema."
fi