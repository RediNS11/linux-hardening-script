#!/bin/bash
# ==============================================================================
# HARDENING: SERVIDOR WEB NGINX (HTTP / HTTPS)
# ==============================================================================
set -euo pipefail

if [ "$EUID" -ne 0 ]; then
  echo "[-] Ejecuta este script como root (sudo)."
  exit 1
fi

echo "[+] Aplicando Hardening a Nginx..."

if [ -d "/etc/nginx" ]; then
    NGINX_CONF="/etc/nginx/nginx.conf"

    # Ocultar versión del servidor (server_tokens off)
    if grep -q "# server_tokens off;" "$NGINX_CONF"; then
        sed -i 's/# server_tokens off;/server_tokens off;/' "$NGINX_CONF"
    elif ! grep -q "server_tokens off;" "$NGINX_CONF"; then
        sed -i '/http {/a \    server_tokens off;' "$NGINX_CONF"
    fi

    # Inyectar cabeceras de seguridad
    HEADERS_FILE="/etc/nginx/conf.d/security_headers.conf"
    cat <<'EOF' > "$HEADERS_FILE"
add_header X-Frame-Options "SAMEORIGIN" always;
add_header X-Content-Type-Options "nosniff" always;
add_header X-XSS-Protection "1; mode=block" always;
EOF

    # Configurar Firewall UFW
    if command -v ufw >/dev/null 2>&1; then
        ufw allow 80/tcp comment 'HTTP Web'
        ufw allow 443/tcp comment 'HTTPS Web'
    fi

    nginx -t && systemctl reload nginx
    echo "[✓] Nginx asegurado y recargado."
else
    echo "[-] Nginx no está instalado en este sistema."
fi