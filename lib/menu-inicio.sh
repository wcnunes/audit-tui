#!/usr/bin/env bash
set -euo pipefail
source common.sh


menu_inicio() {
while true; do
local choice=$(whiptail --title "Início" --menu "Opções" 18 70 10 \
Importar "Importar configurações" \
Exportar "Exportar configurações" \
Salvar "Salvar/rotacionar logs" \
Iniciar "Checar ambiente" \
Fechar "Voltar ao menu principal" 3>&1 1>&2 2>&3) || return


case "$choice" in
Importar)
load_config; whiptail --msgbox "Configurações carregadas de $CFG_FILE (se existirem)." 12 70 ;;
Exportar)
save_config; whiptail --msgbox "Configurações salvas em $CFG_FILE." 12 70 ;;
Salvar)
rotate_logs; whiptail --msgbox "Logs antigos rotacionados. Config sincronizada." 12 70 ;;
Iniciar)
local f=$(log_file init); LOG="$f"
log "Checando dependências
