#!/bin/sh
# Script para configurar Alpine Linux como desktop com Hyprland e Wayland
# Compatível com AMD Ryzen 5 3400G e RX 550

set -e

# Variáveis
LOCALE="pt_BR.UTF-8"
KEYMAP="br-abnt2"

echo "Atualizando repositórios e sistema..."
doas apk update
doas apk upgrade

echo "Habilitando repositórios necessários..."
doas sed -i '/^#http/s/^#//' /etc/apk/repositories
doas apk update

echo "Instalando pacotes essenciais..."
doas apk add \
    sddm \
    hyprland \
    wayland \
    wayland-protocols \
    xdg-desktop-portal \
    mesa \
    mesa-dri-gallium \
    mesa-va-gallium \
    mesa-vdpau-gallium \
    vulkan-tools \
    vulkan-radeon \
    xf86-video-amdgpu \
    libinput \
    seatd \
    elogind \
    dbus \
    alsa-utils \
    alsa-plugins-pulse \
    pipewire \
    pipewire-alsa \
    pipewire-pulse \
    pipewire-jack \
    git \
    bash \
    curl \
    wget

echo "Habilitando serviços..."
doas rc-update add dbus
doas rc-update add elogind
doas rc-update add seatd
doas rc-update add sddm
doas rc-service dbus start
doas rc-service elogind start
doas rc-service seatd start
doas rc-service sddm start

echo "Configurando idioma e teclado..."
doas setup-keymap $KEYMAP
echo "export LANG=$LOCALE" | doas tee -a /etc/profile.d/locale.sh
echo "$LOCALE UTF-8" | doas tee -a /etc/locale.gen
doas locale-gen

echo "Configurando driver de vídeo..."
doas modprobe amdgpu
echo "amdgpu" | doas tee -a /etc/modules

echo "Configuração concluída!"
echo "Reinicie o sistema para aplicar todas as mudanças."
