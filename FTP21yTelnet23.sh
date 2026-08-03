#!/bin/bash
# ==============================================================================
# HARDENING: PROTOCOLOS OBSOLETOS (FTP y TELNET)
# ==============================================================================
set -euo pipefail

if [ "$EUID" -ne 0 ]; then
  echo "[-] Ejecuta este script como root (sudo)."
  exit 1
fi

echo "[+] Purgando servicios FTP y Telnet..."

SERVICES=("vsftpd" "proftpd" "pure-ftpd" "telnetd" "inetutils-telnetd")

for service in "${SERVICES[@]}"; do
    if dpkg -l | grep -q "^ii  $service "; then
        systemctl stop "$service" 2>/dev/null || true
        systemctl disable "$service" 2>/dev/null || true
        apt-get purge -y "$service"
        echo "    - $service eliminado correctamente."
    fi
done

# Bloquear puertos en Firewall
if command -v ufw >/dev/null 2>&1; then
    ufw deny 21/tcp comment 'Bloqueo FTP'
    ufw deny 23/tcp comment 'Bloqueo Telnet'
    echo "    - Puertos 21 y 23 bloqueados en UFW."
fi

echo "[✓] Hardening de FTP/Telnet finalizado."