# Linux-Hardening-Scripts

A collection of Bash scripts designed to automate system hardening, close critical ports, and secure common network services on Linux environments.

## Included Scripts

* **445.close.sh:** Blocks SMB port 445 to prevent unauthorized file share exposure and exploit attempts.
* **BIND9.DNSSEC.OR.sh:** Configures BIND9 DNS server hardening and DNSSEC validation.
* **Close.53.sh:** Closes DNS port 53 to mitigate open resolver abuse.
* **Close.SMTP.sh:** Restricts access to SMTP mail service ports.
* **Close.SSH.sh:** Closes default SSH access points.
* **Closemoonlist.NoAccessExt.sh:** Restricts external access and blocks unnecessary external listeners.
* **FTP21yTelnet23.sh:** Disables legacy, unencrypted management services (FTP port 21 and Telnet port 23).
* **MySQL.sh:** Secures MySQL database service network interfaces.
* **NTP.sh:** Restricts Network Time Protocol (NTP) ports to prevent amplification attacks.
* **Nginx80y443.sh:** Applies firewall rules and configuration hardening for HTTP (80) and HTTPS (443) web ports.
* **PostgreSQL.sh:** Restricts PostgreSQL database exposure and remote access rules.
* **SSH.no.root.FW.sh:** Disables root SSH login and configures default firewall (UFW/Iptables) rules.
* **TLS.NoOpenRelay.sh:** Configures TLS settings to prevent mail/service open relay vulnerabilities.

## How to Use

1. Grant execution permissions to the target script:
   ```bash
   chmod +x <script_name>.sh
2. Execute with elevated privileges:
   sudo ./<script_name>.sh
