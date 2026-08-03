#!/bin/bash
# ==============================================================================
# HARDENING: PUERTO 123 (NTP / TIEMPO)
# Uso: Sincronización segura sin exposición externa.
# ==============================================================================
set -euo pipefail

if [ "$EUID" -ne 0 ]; then
  echo "[-] Ejecuta este script como root (sudo)."
  exit 1
fi

echo "[+] Configurando Hardening para NTP (Puerto 123)..."

# Bloquear tráfico NTP entrante en UFW (El servidor puede salir a consultar, pero nadie le pregunta a él)
if command -v ufw >/dev/null 2>&1; then
    ufw deny in 123/udp comment 'Bloqueo NTP Entrante'
    ufw reload >/dev/null 2>&1 || true
    echo "    - Puerto 123/UDP bloqueado para conexiones entrantes en UFW."
fi

# Asegurar que el servicio nativo de sincronización esté activo
if systemctl list-unit-files | grep -q "systemd-timesyncd.service"; then
    systemctl enable --now systemd-timesyncd
    echo "    - systemd-timesyncd activado y funcionando."
fi

echo "[✓] Hardening de NTP completado."