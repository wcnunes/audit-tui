#!/usr/bin/env bash
set -euo pipefail


# Detecta distro simples
distro="$(. /etc/os-release 2>/dev/null; echo ${ID:-unknown})"


need_pkgs=(whiptail coreutils iproute2 util-linux pciutils usbutils)
opt_pkgs=(curl wget speedtest-cli smartmontools e2fsprogs mesa-utils radeontop intel-gpu-tools)


say() { printf "[install] %s\n" "$*"; }
ask_yes_no() { whiptail --yesno "$1" 12 70 && return 0 || return 1; }


require_root() {
if [[ $EUID -ne 0 ]]; then
say "Este instalador precisa de sudo para instalar pacotes."
sudo -v
fi
}


pkg_install() {
local pkgs=("$@")
case "$distro" in
ubuntu|debian) sudo apt-get update -y && sudo apt-get install -y "${pkgs[@]}" ;;
fedora) sudo dnf install -y "${pkgs[@]}" ;;
arch|manjaro) sudo pacman -Sy --noconfirm "${pkgs[@]}" ;;
*) say "Distro não reconhecida. Instale manualmente: ${pkgs[*]}" ;;
esac
}


# Instala obrigatórias
if ask_yes_no "Instalar dependências obrigatórias?"; then
require_root; pkg_install "${need_pkgs[@]}"
fi


# Instala opcionais
if ask_yes_no "Instalar dependências recomendadas?"; then
require_root; pkg_install "${opt_pkgs[@]}"
fi


say "Feito. Você pode iniciar com: ./audit-tui.sh"
