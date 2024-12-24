#!/bin/sh
# Script para configurar Alpine Linux com Hyprland, Wayland, nwg-shell e Docker
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
doas sed -i '/^#http.*community/s/^#//' /etc/apk/repositories
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
    wget \
    gtk+3.0 \
    gtk4.0 \
    g++ \
    make \
    cmake \
    pkgconfig \
    glib-dev \
    pango-dev \
    json-c-dev \
    wayland-dev \
    cairo-dev \
    gdk-pixbuf-dev \
    libxcb-dev \
    gtk-layer-shell-dev \
    libinput-dev \
    rofi \
    pcmanfm \
    docker

echo "Habilitando serviços..."
doas rc-update add dbus
doas rc-update add elogind
doas rc-update add seatd
doas rc-update add sddm
doas rc-update add docker
doas rc-service dbus start
doas rc-service elogind start
doas rc-service seatd start
doas rc-service sddm start
doas rc-service docker start

echo "Configurando idioma e teclado..."
doas setup-keymap $KEYMAP
echo "export LANG=$LOCALE" | doas tee -a /etc/profile.d/locale.sh
echo "$LOCALE UTF-8" | doas tee -a /etc/locale.gen
doas locale-gen

echo "Configurando driver de vídeo..."
doas modprobe amdgpu
echo "amdgpu" | doas tee -a /etc/modules

echo "Baixando e compilando nwg-shell e ferramentas relacionadas..."
mkdir -p ~/build
cd ~/build

# Clonando e instalando nwg-shell
git clone https://github.com/nwg-piotr/nwg-shell.git
cd nwg-shell
./install.sh
cd ..

# Clonando e instalando nwg-look
git clone https://github.com/nwg-piotr/nwg-look.git
cd nwg-look
make
doas make install
cd ..

# Clonando e instalando nwg-drawer
git clone https://github.com/nwg-piotr/nwg-drawer.git
cd nwg-drawer
make
doas make install
cd ..

# Clonando e instalando nwg-bar
git clone https://github.com/nwg-piotr/nwg-bar.git
cd nwg-bar
make
doas make install
cd ..

# Clonando e instalando nwg-menu
git clone https://github.com/nwg-piotr/nwg-menu.git
cd nwg-menu
make
doas make install
cd ..

# Clonando e instalando nwg-panel
git clone https://github.com/nwg-piotr/nwg-panel.git
cd nwg-panel
make
doas make install
cd ..

echo "Configurando Hyprland como padrão para todos os usuários..."

# Define Hyprland como o ambiente padrão para o SDDM
echo "[Desktop]" | doas tee /etc/sddm.conf.d/default.conf
echo "Session=hyprland" | doas tee -a /etc/sddm.conf.d/default.conf

# Define o Hyprland para o usuário atual
echo "exec Hyprland" > ~/.xinitrc

# Cria configuração global para novos usuários
echo "exec Hyprland" | doas tee /etc/skel/.xinitrc

echo "Instalando Portainer..."
doas docker pull portainer/portainer-ce
doas docker volume create portainer_data
doas docker run -d \
    --name=portainer \
    --restart=always \
    -p 8000:8000 \
    -p 9443:9443 \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v portainer_data:/data \
    portainer/portainer-ce

echo "Configuração concluída. Reinicie o sistema para aplicar todas as mudanças."
