# Linux-Hardening-Scripts

A collection of Bash scripts designed to automate system hardening, close critical ports, and secure common services.

## Included Scripts

* **445.close.sh:** Blocks SMB port 445 to prevent unauthorized share access.
* **BIND9.DNSSEC.OR.sh / Close.53.sh:** Configures DNSSEC and closes open resolvers/DNS ports.
* **Close.SMTP.sh:** Secures mail service ports.
* **Close.SSH.sh / SSH.no.root.FW.sh:** Restricts SSH root login and configures firewall rules.
* **FTP21yTelnet23.sh:** Disables legacy, unencrypted management protocols.
* **MySQL.sh / PostgreSQL.sh:** Hardens local database engines and access control.
* **NTP.sh:** Secures NTP time synchronization.
* **Nginx80y443.sh:** Configures basic web server port rules.
* **TLS.NoOpenRelay.sh:** Restricts TLS relay misconfigurations.

## How to Use

1. Grant execution permissions:
   ```bash
   chmod +x <script_name>.sh
