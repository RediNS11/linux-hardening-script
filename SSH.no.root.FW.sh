#!/bin/bash
# ==============================================================================
# HERRAMIENTA 2: HARDENING DE SSH (SIN ROOT DIRECTO + PERMITIR SOLO RED VPN)
# ==============================================================================

# DEFINIR EL RANGO DE LA VPN O IP AUTORIZADA (Ejemplo: Red interna de VPN 10.8.0.0/24)
ALLOWED_NET="10.8.0.0/24"
SSH_CONFIG="/etc/ssh/sshd_config"

# 1. Asegurar que el servicio SSH esté activo
if ! systemctl is-active --quiet sshd; then
    systemctl enable --now sshd
    echo "[CAMBIO] Servicio SSH iniciado y configurado para arrancar con el sistema."
fi

# 2. Deshabilitar login directo del usuario root en SSH (Buenas Prácticas)
if grep -q "^PermitRootLogin yes" "$SSH_CONFIG" || ! grep -q "^PermitRootLogin no" "$SSH_CONFIG"; then
    sed -i 's/^#*PermitRootLogin.*/PermitRootLogin no/' "$SSH_CONFIG"
    RESTART_NEEDED=true
    echo "[CAMBIO] Login directo de root en SSH deshabilitado."
else
    echo "[OK] Login directo de root ya estaba deshabilitado."
fi

# Recargar configuración SSH si hubo cambios en el archivo
if [ "$RESTART_NEEDED" = true ]; then
    systemctl reload sshd
fi

# 3. Configurar Firewall (UFW): Bloquear todo excepto el rango de la VPN
if command -v ufw > /dev/null; then
    # Eliminar acceso global anterior
    ufw delete allow 22/tcp > /dev/null 2>&1
    
    # Permitir solo la red autorizada
    ufw allow from $ALLOWED_NET to any port 22 proto tcp > /dev/null
    ufw --force enable > /dev/null
    echo "[CAMBIO] Firewall configurado: SSH permitido SOLO desde la red $ALLOWED_NET."
fi