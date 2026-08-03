#!/bin/bash
# ==============================================================================
# HARDENING: BLOQUEO / REMOCIÓN DE SERVICIO DE CORREO (PUERTO 25)
# ==============================================================================
set -euo pipefail

if [ "$EUID" -ne 0 ]; then
  echo "[-] Ejecuta este script como root (sudo)."
  exit 1
fi

echo "[+] Asegurando puerto SMTP (25)..."

# Detener y purgar MTA común si está instalado de forma inútil
MAIL_SERVICES=("postfix" "exim4" "sendmail")
for service in "${MAIL_SERVICES[@]}"; do
    if dpkg -l | grep -q "^ii  $service "; then
        systemctl stop "$service" 2>/dev/null || true
        systemctl disable "$service" 2>/dev/null || true
        apt-get purge -y "$service"
        echo "    - Servicio $service eliminado."
    fi
done

# Bloquear puerto 25 en UFW
if command -v ufw >/dev/null 2>&1; then
    ufw deny 25/tcp comment 'Bloqueo SMTP Inseguro'
    ufw reload >/dev/null 2>&1 || true
    echo "[✓] Puerto 25 bloqueado en UFW."
fi