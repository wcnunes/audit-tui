# 📦 Projeto: audit-tui — Ferramenta TUI em Bash para testes e auditoria segura

Uma suíte TUI (Text User Interface) em Bash com abas [Início] [Teste] [Sobre] que executa checagens de performance e inventário do sistema com foco em segurança operacional: velocidade de internet, escrita em disco, carga de CPU/GPU, informações completas do sistema e verificação segura de pendrives.

Plataforma alvo: Linux (Debian/Ubuntu, Fedora, Arch e derivados). Requer privilégios pontuais para funções específicas (p.ex. badblocks, fsck).

# Princípios de segurança aplicados
Não-destrutivo por padrão: qualquer ação que possa afetar dados é opt-in e exige confirmação explícita.
Privilégios mínimos: elevação via sudo apenas quando estritamente necessária.
Transparência: todo output relevante é registrado em logs/.
Resiliência: contorna ausência de ferramentas com alternativas seguras.

# Uso rápido
chmod +x install.sh audit-tui.sh
./install.sh # instala dependências recomendadas (com confirmação)
./audit-tui.sh # inicia a interface


# Dependências
Obrigatórias: bash, whiptail (ou dialog), coreutils, grep, awk, sed, ip, lsblk, lspci, lsusb.
Recomendadas (habilitam recursos extras ou métricas melhores):
Rede: curl e/ou wget, speedtest-cli (se disponível)
Disco: util-linux (dd), smartmontools (smartctl)
GPU: nvidia-smi (NVIDIA), glxinfo (mesa-utils), radeontop (AMD), intel-gpu-tools (Intel)
USB/FS: badblocks, e2fsprogs (fsck, e2fsck)
Wi‑Fi/Bluetooth: nmcli (NetworkManager), bluetoothctl
O instalador pergunta antes de instalar qualquer pacote.


# Notas de segurança — Teste de Pendrive
A varredura padrão usa badblocks em modo somente leitura. É segura e não altera dados.
Correções automáticas não destrutivas são limitadas:
Para ext2/3/4: é possível marcar blocos defeituosos com e2fsck -y + lista do badblocks (requer desmontar o volume). Isso não formata, mas pode demorar.
Para FAT/NTFS/exFAT: marcação automática via fsck é limitada ou indisponível; o programa apenas registra evidências e sugere ação manual segura.
Nunca formatamos ou escrevemos padrões em dispositivos montados. Operações que pedem escrita exigem confirmação explícita e desmontagem.

# Instalação
./install.sh

# Execução
./audit-tui.sh


# Logs e saída
Os resultados são gravados em logs/YYYYMMDD_HHMMSS_*.log.
Arquivos temporários de testes de disco são criados em /tmp/audit-tui/ e removidos ao final.


# Limitações e boas práticas de segurança
Sem root, certos recursos ficam indisponíveis (USB/FS). O app detecta e informa.
Não execute correções se o dispositivo estiver montado.
Faça backup antes de qualquer operação corretiva.
