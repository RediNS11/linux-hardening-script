#!/bin/bash
echo "--- Ejecutando Blindaje Inteligente (Idempotente) ---"

# 1. VERIFICACIÓN Y GESTIÓN DE FIREWALL
if command -v ufw &> /dev/null; then
    # Verificar si UFW ya tiene la regla para el puerto 445
    if sudo ufw status | grep -q "445/tcp.*DENY"; then
        echo "[=] UFW: El puerto 445/tcp ya está bloqueado. Omitiendo."
    else
        sudo ufw deny 445/tcp
        echo "[+] UFW: Puerto 445/tcp bloqueado exitosamente."
    fi
else
    # Verificar si IPTABLES ya tiene la regla de bloqueo exacta (-C comprueba si existe)
    if sudo iptables -C INPUT -p tcp --dport 445 -j DROP &> /dev/null; then
        echo "[=] IPTABLES: La regla para el puerto 445 ya existe. Omitiendo."
    else
        sudo iptables -A INPUT -p tcp --dport 445 -j DROP
        echo "[+] IPTABLES: Regla agregada para bloquear el puerto 445."
    fi
fi

# 2. VERIFICACIÓN Y GESTIÓN DE SERVICIOS
if command -v systemctl &> /dev/null; then
    # Verificar si el servicio smbd está activo antes de intentar detenerlo
    if systemctl is-active --quiet smbd; then
        sudo systemctl stop smbd
        echo "[+] SYSTEMCTL: Servicio 'smbd' detenido."
    else
        echo "[=] SYSTEMCTL: El servicio 'smbd' ya estaba detenido o no está activo."
    fi
elif command -v service &> /dev/null; then
    # Verificar si el servicio samba está corriendo en sistemas sin systemctl
    if service samba status &> /dev/null; then
        sudo service samba stop
        echo "[+] SERVICE: Servicio 'samba' detenido."
    else
        echo "[=] SERVICE: El servicio 'samba' ya estaba detenido."
    fi
fi