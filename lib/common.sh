#!/usr/bin/env bash
set -euo pipefail

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")"/.. && pwd)"
LOG_DIR="$BASE_DIR/logs"
CFG_DIR="$BASE_DIR/config"
TMP_DIR="/tmp/audit-tui"
CFG_FILE="$CFG_DIR/settings.env"


ensure_dirs() { mkdir -p "$LOG_DIR" "$CFG_DIR" "$TMP_DIR"; }


log_file() { date +"$LOG_DIR/%Y%m%d_%H%M%S_${1:-run}.log"; }


log() { local f=${LOG:-$(log_file)}; printf "%s %s\n" "$(date +%F_%T)" "$*" | tee -a "$f" >/dev/null; }


require_cmd() { command -v "$1" >/dev/null 2>&1; }


need_root() { [[ $EUID -eq 0 ]]; }


confirm_root() {
if ! need_root; then
if whiptail --yesno "Esta ação requer privilégios elevados. Continuar com sudo?" 12 70; then
sudo -v || return 1
else
return 1
fi
fi
}


pick_blockdev() {
local list
list=$(lsblk -S -o NAME,MODEL,SIZE,TRAN,HOTPLUG,RM 2>/dev/null | awk 'NR>1 && ($5==1 || $6==1){print $1" "$2" ("$3")"}')
[[ -z "$list" ]] && return 1
local arr=($list)
whiptail --title "Dispositivos removíveis" --menu "Selecione" 20 72 10 ${arr[@]} 3>&1 1>&2 2>&3
}


save_config() {
cat > "$CFG_FILE" <<EOF
# audit-tui settings
dd_bs=${dd_bs:-1M}
dd_count=${dd_count:-1024}
net_url=${net_url:-https://speed.hetzner.de/100MB.bin}
EOF
}


load_config() { [[ -f "$CFG_FILE" ]] && source "$CFG_FILE" || true; }


rotate_logs() {
find "$LOG_DIR" -type f -name '*.log' -mtime +14 -delete 2>/dev/null || true
}
