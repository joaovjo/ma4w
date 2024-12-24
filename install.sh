#!/bin/sh
# Script para configurar Alpine Linux com Hyprland, Wayland, nwg-shell e Docker
# Compatível com AMD Ryzen 5 3400G e RX 550

set -e

# Variáveis
LOCALE="pt_BR.UTF-8"
KEYMAP="br-abnt2"
USERNAME="joaovjo"

# Instalando e configurando doas e sudo
echo "Instalando e configurando doas e sudo..."
apk add doas sudo

# Configurando doas
echo "permit :wheel" > /etc/doas.d/doas.conf
addgroup $USERNAME wheel

# Configurando sudo
echo "%wheel ALL=(ALL) ALL" >> /etc/sudoers

# Garantindo que o usuário esteja no grupo correto
addgroup $USERNAME wheel

# Atualizando repositórios e sistema
echo "Atualizando repositórios e sistema..."
apk update
apk upgrade

# Habilitando repositórios necessários
echo "Habilitando repositórios necessários..."
sed -i '/^#http/s/^#//' /etc/apk/repositories
sed -i '/^#http.*community/s/^#//' /etc/apk/repositories
apk update

# Instalando pacotes essenciais
echo "Instalando pacotes essenciais..."
apk add \
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

# Habilitando serviços
echo "Habilitando serviços..."
rc-update add dbus
rc-update add elogind
rc-update add seatd
rc-update add sddm
rc-update add docker
rc-service dbus start
rc-service elogind start
rc-service seatd start
rc-service sddm start
rc-service docker start

# Configurando idioma e teclado
echo "Configurando idioma e teclado..."
setup-keymap $KEYMAP
echo "export LANG=$LOCALE" > /etc/profile.d/locale.sh
echo "$LOCALE UTF-8" >> /etc/locale.gen
locale-gen

# Configurando driver de vídeo
echo "Configurando driver de vídeo..."
modprobe amdgpu
echo "amdgpu" >> /etc/modules

# Baixando e compilando nwg-shell e ferramentas relacionadas
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
make install
cd ..

# Clonando e instalando nwg-drawer
git clone https://github.com/nwg-piotr/nwg-drawer.git
cd nwg-drawer
make
make install
cd ..

# Clonando e instalando nwg-bar
git clone https://github.com/nwg-piotr/nwg-bar.git
cd nwg-bar
make
make install
cd ..

# Clonando e instalando nwg-menu
git clone https://github.com/nwg-piotr/nwg-menu.git
cd nwg-menu
make
make install
cd ..

# Clonando e instalando nwg-panel
git clone https://github.com/nwg-piotr/nwg-panel.git
cd nwg-panel
make
make install
cd ..

# Configurando Hyprland como padrão para todos os usuários
echo "Configurando Hyprland como padrão para todos os usuários..."

# Define Hyprland como o ambiente padrão para o SDDM
echo "[Desktop]" > /etc/sddm.conf.d/default.conf
echo "Session=hyprland" >> /etc/sddm.conf.d/default.conf

# Define o Hyprland para o usuário atual
echo "exec Hyprland" > ~/.xinitrc

# Cria configuração global para novos usuários
echo "exec Hyprland" > /etc/skel/.xinitrc

# Instalando Portainer
echo "Instalando Portainer..."
docker pull portainer/portainer-ce
docker volume create portainer_data
docker run -d \
    --name=portainer \
    --restart=always \
    -p 8000:8000 \
    -p 9443:9443 \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v portainer_data:/data \
    portainer/portainer-ce

echo "Configuração concluída. Reinicie o sistema para aplicar todas as mudanças."
