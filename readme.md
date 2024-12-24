# ma4w - My Alpine Linux For Work

## Configuração do Alpine Linux com Hyprland e Wayland

Este repositório contém um script para configurar o Alpine Linux como um desktop completo, utilizando o Hyprland e o Wayland 

O script é otimizado para sistemas com processadores AMD Ryzen e GPUs AMD, garantindo o máximo de compatibilidade com hardware moderno.  

## Recursos

- Instalação do gerenciador de login SDDM.  
- Configuração do Hyprland como gerenciador de janelas.  
- Suporte ao protocolo Wayland.  
- Configuração de idioma para **Português do Brasil (pt-BR)** e teclado ABNT2.  
- Drivers otimizados para AMD Ryzen 5 3400G e AMD RX 550.  
- Suporte a áudio via PipeWire.  
- Ativação de serviços essenciais para o funcionamento do desktop.  

## Pré-requisitos

- **Alpine Linux** instalado em um ambiente físico (não em VM ou Docker).  
- Acesso à internet.  
- `doas` configurado no sistema (substituto para `sudo`).  

## Como usar

1. Clone este repositório no seu sistema:  
   ```bash
   git clone https://github.com/joaovjo/ma4w
   cd ma4w
   ```

2. Execute o script com privilégios administrativos:  
   ```bash
   doas sh script.sh
   ```

3. Reinicie o sistema para aplicar todas as configurações:  
   ```bash
   doas reboot
   ```

## Estrutura do Repositório

- **`script.sh`**: Script principal para configurar o Alpine Linux.  

## Observações

- Certifique-se de que os repositórios do Alpine estão habilitados corretamente antes de executar o script.  
- O script foi testado em um ambiente com processador AMD Ryzen 5 3400G e GPU AMD RX 550, mas pode funcionar em outras configurações semelhantes.  

## Licença

Este projeto está licenciado sob a [MIT License](LICENSE).  

---