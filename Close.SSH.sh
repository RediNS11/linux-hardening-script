#!/bin/bash
# ==============================================================================
# HERRAMIENTA 1: CIERRE TOTAL DE SSH (PUERTO 22)
# ==============================================================================

# 1. Detener y deshabilitar el servicio SSH para que no escuche peticiones
if systemctl is-active --quiet sshd; then
    systemctl stop sshd
    systemctl disable sshd
    echo "[CAMBIO] Servicio SSH detenido y deshabilitado."
else
    echo "[OK] El servicio SSH ya estaba detenido."
fi

# 2. Aplicar regla de bloqueo explícito en el Firewall (UFW)
if command -v ufw > /dev/null; then
    if ufw status | grep -q "22/tcp.*ALLOW"; then
        ufw deny 22/tcp
        ufw reload
        echo "[CAMBIO] Regla de bloqueo del puerto 22/TCP aplicada en UFW."
    else
        echo "[OK] El puerto 22/TCP ya no estaba permitido en el Firewall."
    fi
fi