#!/usr/bin/env bash
set -euo pipefail


BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PATH="$BASE_DIR/lib:$PATH"


source common.sh
source menu_inicio.sh
source menu_teste.sh


ensure_dirs


main_menu() {
while true; do
CHOICE=$(whiptail --title "audit-tui" \
--menu "Selecione uma aba" 18 70 10 \
Inicio "Importar/Exportar/Salvar/Iniciar/Fechar" \
Teste "Testes de rede/disco/CPU/GPU/Sistema/USB" \
Sobre "Sobre e Manual" \
Sair "Encerrar" 3>&1 1>&2 2>&3) || exit 0


case "$CHOICE" in
Inicio) menu_inicio ;;
Teste) menu_teste ;;
Sobre)
whiptail --msgbox "audit-tui\nSite: goat.dev.br\n\nManual resumido:\n- Use [Teste] para executar verificações.\n- Varredura de pendrive é segura (somente leitura por padrão).\n- Logs em ./logs" 18 70 ;;
*) exit 0 ;;
esac
done
}


main_menu
