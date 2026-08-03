#!/bin/bash
# ==============================================================================
# HARDENING: POSTFIX (DESACTIVAR OPEN RELAY Y BIND A LOCALHOST)
# ==============================================================================
set -euo pipefail

if [ "$EUID" -ne 0 ]; then
  echo "[-] Ejecuta este script como root (sudo)."
  exit 1
fi

MAIN_CF="/etc/postfix/main.cf"

if [ -f "$MAIN_CF" ]; then
    echo "[+] Asegurando configuración de Postfix..."

    # 1. Escuchar únicamente en localhost (evita recibir peticiones de la red externa)
    if grep -q "^inet_interfaces" "$MAIN_CF"; then
        sed -i 's/^inet_interfaces.*/inet_interfaces = loopback-only/' "$MAIN_CF"
    else
        echo "inet_interfaces = loopback-only" >> "$MAIN_CF"
    fi

    # 2. Permitir retransmisión SOLO a la red local/loopback
    if grep -q "^mynetworks " "$MAIN_CF"; then
        sed -i 's/^mynetworks .*/mynetworks = 127.0.0.0\/8 [::1]\/128/' "$MAIN_CF"
    else
        echo "mynetworks = 127.0.0.0/8 [::1]/128" >> "$MAIN_CF"
    fi

    systemctl restart postfix
    echo "[✓] Postfix asegurado: Open Relay desactivado y limitado a loopback."
else
    echo "[-] Postfix no está instalado en este sistema."
fi