#!/usr/bin/env bash
# =============================================================================
# Silmarillion Stack — one-command terminal environment installer
# Usage: curl -fsSL <url> | bash
#    or: bash install.sh
# =============================================================================
set -euo pipefail

RED='\033[0;31m'; GREEN='\033[0;32m'; CYAN='\033[0;36m'; BOLD='\033[1m'; NC='\033[0m'
log()  { echo -e "${CYAN}[silmarillion]${NC} $*"; }
ok()   { echo -e "${GREEN}[✓]${NC} $*"; }
warn() { echo -e "${RED}[!]${NC} $*"; }

# ── TUI helpers ─────────────────────────────────────────────────────────
SPLASH="
${CYAN}╔══════════════════════════════════════════════════╗${NC}
${CYAN}║${NC}          ${BOLD}☾  Silmarillion Stack  ☽${NC}            ${CYAN}║${NC}
${CYAN}║${NC}    One script to rule them all                ${CYAN}║${NC}
${CYAN}║${NC}    ${GREEN}Rust${NC}/${GREEN}Go${NC}-powered terminal environment         ${CYAN}║${NC}
${CYAN}╚══════════════════════════════════════════════════╝${NC}"

section() {
    local title="$1"
    echo ""
    echo -e "  ${CYAN}━━━ ${BOLD}${title}${NC} ${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
}

done_screen() {
    echo ""
    echo -e "  ${GREEN}╔════════════════════════════════════════════╗${NC}"
    echo -e "  ${GREEN}║${NC}  ${BOLD}$(msg install_done)${NC}              ${GREEN}║${NC}"
    echo -e "  ${GREEN}╚════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "  ${BOLD}$(msg next_steps)${NC}"
    echo "  $(msg step1)"
    echo "  $(msg step2)"
    echo "  $(msg step3)"
    echo "  $(msg step4)"
    echo ""
}

# ── Language selection ──────────────────────────────────────────────────
SILMARILLION_LANG="${SILMARILLION_LANG:-}"
if [[ -z "$SILMARILLION_LANG" && -t 0 ]]; then
    echo ""
    if command -v whiptail &>/dev/null; then
        choice=$(whiptail --title "Silmarillion Stack" \
            --menu "Language / Idioma:" 18 55 8 \
            "en" "English" \
            "es" "Español" \
            "de" "Deutsch" \
            "it" "Italiano" \
            "sv" "Svenska" \
            "ru" "Русский" \
            "pt" "Português" \
            "el" "Ελληνικά" 3>&1 1>&2 2>&3) || true
        SILMARILLION_LANG="${choice:-en}"
    else
        echo ""
        echo "  Select language / Seleccione idioma:"
        echo "  1) English    2) Español    3) Deutsch    4) Italiano"
        echo "  5) Svenska    6) Русский    7) Português    8) Ελληνικά"
        printf "  Choice [1-8] (default 1): "
        read -r lang_choice
        case "$lang_choice" in
            2) SILMARILLION_LANG="es" ;; 3) SILMARILLION_LANG="de" ;;
            4) SILMARILLION_LANG="it" ;; 5) SILMARILLION_LANG="sv" ;;
            6) SILMARILLION_LANG="ru" ;; 7) SILMARILLION_LANG="pt" ;;
            8) SILMARILLION_LANG="el" ;;
            *) SILMARILLION_LANG="en" ;;
        esac
    fi
    echo ""
fi
: "${SILMARILLION_LANG:=en}"

# Splash screen
echo -e "$SPLASH"
echo ""

# ── Internationalized message function ─────────────────────────────────
# Defines m_<key>_<lang> variables and provides a msg() lookup.
# Usage: msg "running_local" "/path/to/repo"
#        msg "already_installed" "sheldon"
msg() {
    local key="$1"; shift
    local var="m_${key}_${SILMARILLION_LANG}"
    local fallback="m_${key}_en"
    local template
    if [[ -n "${!var:-}" ]]; then
        template="${!var}"
    elif [[ -n "${!fallback:-}" ]]; then
        template="${!fallback}"
    else
        template="$key"
    fi
    printf "${template}\n" "$@"
}

# ── Message definitions ─────────────────────────────────────────────────
# --- English ---
m_running_local_en="Running from local clone: %s"
m_cloning_repo_en="Cloning Silmarillion to %s..."
m_clone_fail_en="Could not clone repo. If running via curl, clone first:"
m_clone_cmd_en="  git clone https://github.com/smartinez1685/Silmarillion.git ~/Silmarillion && cd ~/Silmarillion && bash install.sh"
m_p10k_present_en="Powerlevel10k already present"
m_p10k_cloning_en="Cloning Powerlevel10k..."
m_p10k_cloned_en="Powerlevel10k cloned"
m_rust_installed_en="Rust toolchain already installed (%s)"
m_rust_installing_en="Installing Rust toolchain..."
m_rust_done_en="Rust installed"
m_go_installed_en="Go already installed (%s)"
m_go_installing_en="Installing Go %s locally..."
m_go_done_en="Go installed"
m_already_installed_en="%s already installed"
m_installing_cargo_en="Installing %s (cargo)..."
m_install_failed_en="Failed to install %s"
m_installing_go_en="Installing %s (go)..."
m_atuin_installed_en="atuin already installed (%s)"
m_atuin_installing_en="Installing atuin..."
m_atuin_done_en="atuin installed"
m_kitty_installed_en="kitty already installed (%s)"
m_kitty_installing_en="Installing kitty..."
m_kitty_done_en="kitty installed"
m_frogmouth_installed_en="frogmouth already installed (%s)"
m_frogmouth_installing_en="Installing frogmouth (venv)..."
m_frogmouth_done_en="frogmouth installed"
m_zed_installed_en="zed already installed (%s)"
m_zed_installing_en="Installing zed..."
m_zed_done_en="zed installed"
m_fonts_installed_en="Nerd Fonts already installed (%s variants)"
m_fonts_downloading_en="Downloading Nerd Fonts (60+ families)..."
m_fonts_ask_full_en="Download all 60+ Nerd Font families? (~7 GB, otherwise just UbuntuMono)"
m_fonts_downloading_mini_en="Downloading UbuntuMono Nerd Font..."
m_fonts_extracting_en="Extracting fonts..."
m_fonts_done_en="Nerd Fonts installed (%s variants)"
m_deploying_configs_en="Deploying config files..."
m_phase1_en="Phase 1/7 · Theme & Toolchains"
m_phase2_en="Phase 2/7 · Cargo Tools"
m_phase3_en="Phase 3/7 · Go Tools"
m_phase4_en="Phase 4/7 · Applications"
m_phase5_en="Phase 5/7 · Fonts"
m_phase6_en="Phase 6/7 · Config Files"
m_phase7_en="Phase 7/7 · Neovim"
m_sheldon_created_en="~/.config/sheldon/plugins.toml created"
m_kitty_conf_created_en="~/.config/kitty/kitty.conf created"
m_zshrc_deployed_en="~/.zshrc deployed (backup at ~/.zshrc.silmarillion.bak)"
m_bashrc_deployed_en="~/.bashrc deployed (backup at ~/.bashrc.silmarillion.bak)"
m_profile_updated_en="~/.profile updated (zsh auto-launch)"
m_sheldon_installing_en="Installing sheldon plugins..."
m_sheldon_done_en="Sheldon plugins installed"
m_sheldon_failed_en="sheldon lock failed"
m_ping_deploying_en="Deploying curl-based ping tool..."
m_ping_deployed_en="curl-ping deployed (shadows /usr/bin/ping)"
m_install_done_en="Silmarillion Stack installed!"
m_next_steps_en="Next steps:"
m_step1_en="1. Open a new terminal (kitty should appear in your app launcher)"
m_step2_en="2. p10k prompt is pre-configured — run 'p10k configure' to customize"
m_step3_en="3. Install a Node version:  fnm install 22"
m_step4_en="4. Run 'p10k configure' anytime to redo prompt setup"
# --- Español ---
m_running_local_es="Ejecutando desde clon local: %s"
m_cloning_repo_es="Clonando Silmarillion a %s..."
m_clone_fail_es="No se pudo clonar el repositorio. Si ejecutas por curl, clona primero:"
m_clone_cmd_es="  git clone https://github.com/smartinez1685/Silmarillion.git ~/Silmarillion && cd ~/Silmarillion && bash install.sh"
m_p10k_present_es="Powerlevel10k ya presente"
m_p10k_cloning_es="Clonando Powerlevel10k..."
m_p10k_cloned_es="Powerlevel10k clonado"
m_rust_installed_es="Rust toolchain ya instalado (%s)"
m_rust_installing_es="Instalando Rust toolchain..."
m_rust_done_es="Rust instalado"
m_go_installed_es="Go ya instalado (%s)"
m_go_installing_es="Instalando Go %s localmente..."
m_go_done_es="Go instalado"
m_already_installed_es="%s ya instalado"
m_installing_cargo_es="Instalando %s (cargo)..."
m_install_failed_es="Error al instalar %s"
m_installing_go_es="Instalando %s (go)..."
m_atuin_installed_es="atuin ya instalado (%s)"
m_atuin_installing_es="Instalando atuin..."
m_atuin_done_es="atuin instalado"
m_kitty_installed_es="kitty ya instalado (%s)"
m_kitty_installing_es="Instalando kitty..."
m_kitty_done_es="kitty instalado"
m_frogmouth_installed_es="frogmouth ya instalado (%s)"
m_frogmouth_installing_es="Instalando frogmouth (venv)..."
m_frogmouth_done_es="frogmouth instalado"
m_zed_installed_es="zed ya instalado (%s)"
m_zed_installing_es="Instalando zed..."
m_zed_done_es="zed instalado"
m_fonts_installed_es="Nerd Fonts ya instaladas (%s variantes)"
m_fonts_downloading_es="Descargando Nerd Fonts (60+ familias)..."
m_fonts_ask_full_es="¿Descargar las 60+ familias Nerd Font? (~7 GB, solo UbuntuMono sino)"
m_fonts_downloading_mini_es="Descargando UbuntuMono Nerd Font..."
m_fonts_extracting_es="Extrayendo fuentes..."
m_fonts_done_es="Nerd Fonts instaladas (%s variantes)"
m_deploying_configs_es="Desplegando archivos de configuración..."
m_phase1_es="Fase 1/7 · Tema y Toolchains"
m_phase2_es="Fase 2/7 · Herramientas Cargo"
m_phase3_es="Fase 3/7 · Herramientas Go"
m_phase4_es="Fase 4/7 · Aplicaciones"
m_phase5_es="Fase 5/7 · Fuentes"
m_phase6_es="Fase 6/7 · Archivos de Configuración"
m_phase7_es="Fase 7/7 · Neovim"
m_sheldon_created_es="~/.config/sheldon/plugins.toml creado"
m_kitty_conf_created_es="~/.config/kitty/kitty.conf creado"
m_zshrc_deployed_es="~/.zshrc desplegado (copia en ~/.zshrc.silmarillion.bak)"
m_bashrc_deployed_es="~/.bashrc desplegado (copia en ~/.bashrc.silmarillion.bak)"
m_profile_updated_es="~/.profile actualizado (inicio automático de zsh)"
m_sheldon_installing_es="Instalando plugins de sheldon..."
m_sheldon_done_es="Plugins de sheldon instalados"
m_sheldon_failed_es="sheldon lock falló"
m_ping_deploying_es="Desplegando herramienta ping basada en curl..."
m_ping_deployed_es="curl-ping desplegado (reemplaza /usr/bin/ping)"
m_install_done_es="¡Silmarillion Stack instalado!"
m_next_steps_es="Próximos pasos:"
m_step1_es="1. Abre una nueva terminal (kitty debería aparecer en tu lanzador)"
m_step2_es="2. El prompt de p10k ya está configurado — ejecuta 'p10k configure' para personalizar"
m_step3_es="3. Instala una versión de Node:  fnm install 22"
m_step4_es="4. Ejecuta 'p10k configure' para rehacer la configuración del prompt"
# --- Deutsch ---
m_running_local_de="Ausführung von lokalem Klon: %s"
m_cloning_repo_de="Klone Silmarillion nach %s..."
m_clone_fail_de="Konnte Repository nicht klonen. Bei curl-Ausführung bitte zuerst klonen:"
m_clone_cmd_de="  git clone https://github.com/smartinez1685/Silmarillion.git ~/Silmarillion && cd ~/Silmarillion && bash install.sh"
m_p10k_present_de="Powerlevel10k bereits vorhanden"
m_p10k_cloning_de="Klone Powerlevel10k..."
m_p10k_cloned_de="Powerlevel10k geklont"
m_rust_installed_de="Rust-Toolchain bereits installiert (%s)"
m_rust_installing_de="Installiere Rust-Toolchain..."
m_rust_done_de="Rust installiert"
m_go_installed_de="Go bereits installiert (%s)"
m_go_installing_de="Installiere Go %s lokal..."
m_go_done_de="Go installiert"
m_already_installed_de="%s bereits installiert"
m_installing_cargo_de="Installiere %s (cargo)..."
m_install_failed_de="Fehler bei Installation von %s"
m_installing_go_de="Installiere %s (go)..."
m_atuin_installed_de="atuin bereits installiert (%s)"
m_atuin_installing_de="Installiere atuin..."
m_atuin_done_de="atuin installiert"
m_kitty_installed_de="kitty bereits installiert (%s)"
m_kitty_installing_de="Installiere kitty..."
m_kitty_done_de="kitty installiert"
m_frogmouth_installed_de="frogmouth bereits installiert (%s)"
m_frogmouth_installing_de="Installiere frogmouth (venv)..."
m_frogmouth_done_de="frogmouth installiert"
m_zed_installed_de="zed bereits installiert (%s)"
m_zed_installing_de="Installiere zed..."
m_zed_done_de="zed installiert"
m_fonts_installed_de="Nerd Fonts bereits installiert (%s Varianten)"
m_fonts_downloading_de="Lade Nerd Fonts herunter (60+ Familien)..."
m_fonts_ask_full_de="Alle 60+ Nerd Font-Familien herunterladen? (~7 GB, sonst nur UbuntuMono)"
m_fonts_downloading_mini_de="Lade UbuntuMono Nerd Font herunter..."
m_fonts_extracting_de="Extrahiere Schriftarten..."
m_fonts_done_de="Nerd Fonts installiert (%s Varianten)"
m_deploying_configs_de="Konfigurationsdateien werden bereitgestellt..."
m_phase1_de="Phase 1/7 · Theme & Toolchains"
m_phase2_de="Phase 2/7 · Cargo-Werkzeuge"
m_phase3_de="Phase 3/7 · Go-Werkzeuge"
m_phase4_de="Phase 4/7 · Anwendungen"
m_phase5_de="Phase 5/7 · Schriftarten"
m_phase6_de="Phase 6/7 · Konfigurationsdateien"
m_phase7_de="Phase 7/7 · Neovim"
m_sheldon_created_de="~/.config/sheldon/plugins.toml erstellt"
m_kitty_conf_created_de="~/.config/kitty/kitty.conf erstellt"
m_zshrc_deployed_de="~/.zshrc bereitgestellt (Backup unter ~/.zshrc.silmarillion.bak)"
m_bashrc_deployed_de="~/.bashrc bereitgestellt (Backup unter ~/.bashrc.silmarillion.bak)"
m_profile_updated_de="~/.profile aktualisiert (zsh-Autostart)"
m_sheldon_installing_de="Installiere sheldon-Plugins..."
m_sheldon_done_de="Sheldon-Plugins installiert"
m_sheldon_failed_de="sheldon lock fehlgeschlagen"
m_ping_deploying_de="Installiere curl-basiertes Ping-Tool..."
m_ping_deployed_de="curl-ping installiert (ersetzt /usr/bin/ping)"
m_install_done_de="Silmarillion Stack installiert!"
m_next_steps_de="Nächste Schritte:"
m_step1_de="1. Öffne ein neues Terminal (kitty sollte im Launcher erscheinen)"
m_step2_de="2. p10k-Prompt ist vorkonfiguriert — passe es mit 'p10k configure' an"
m_step3_de="3. Installiere eine Node-Version:  fnm install 22"
m_step4_de="4. Führe 'p10k configure' aus, um das Prompt anzupassen"
# --- Italiano ---
m_running_local_it="Esecuzione da clone locale: %s"
m_cloning_repo_it="Clonazione di Silmarillion in %s..."
m_clone_fail_it="Impossibile clonare il repo. Se esegui tramite curl, clona prima:"
m_clone_cmd_it="  git clone https://github.com/smartinez1685/Silmarillion.git ~/Silmarillion && cd ~/Silmarillion && bash install.sh"
m_p10k_present_it="Powerlevel10k già presente"
m_p10k_cloning_it="Clonazione Powerlevel10k..."
m_p10k_cloned_it="Powerlevel10k clonato"
m_rust_installed_it="Toolchain Rust già installato (%s)"
m_rust_installing_it="Installazione toolchain Rust..."
m_rust_done_it="Rust installato"
m_go_installed_it="Go già installato (%s)"
m_go_installing_it="Installazione Go %s localmente..."
m_go_done_it="Go installato"
m_already_installed_it="%s già installato"
m_installing_cargo_it="Installazione %s (cargo)..."
m_install_failed_it="Installazione di %s fallita"
m_installing_go_it="Installazione %s (go)..."
m_atuin_installed_it="atuin già installato (%s)"
m_atuin_installing_it="Installazione atuin..."
m_atuin_done_it="atuin installato"
m_kitty_installed_it="kitty già installato (%s)"
m_kitty_installing_it="Installazione kitty..."
m_kitty_done_it="kitty installato"
m_frogmouth_installed_it="frogmouth già installato (%s)"
m_frogmouth_installing_it="Installazione frogmouth (venv)..."
m_frogmouth_done_it="frogmouth installato"
m_zed_installed_it="zed già installato (%s)"
m_zed_installing_it="Installazione zed..."
m_zed_done_it="zed installato"
m_fonts_installed_it="Nerd Fonts già installate (%s varianti)"
m_fonts_downloading_it="Download Nerd Fonts (60+ famiglie)..."
m_fonts_ask_full_it="Scaricare tutte le 60+ famiglie Nerd Font? (~7 GB, altrimenti solo UbuntuMono)"
m_fonts_downloading_mini_it="Download UbuntuMono Nerd Font..."
m_fonts_extracting_it="Estrazione font..."
m_fonts_done_it="Nerd Fonts installate (%s varianti)"
m_deploying_configs_it="Distribuzione file di configurazione..."
m_phase1_it="Fase 1/7 · Tema e Toolchain"
m_phase2_it="Fase 2/7 · Strumenti Cargo"
m_phase3_it="Fase 3/7 · Strumenti Go"
m_phase4_it="Fase 4/7 · Applicazioni"
m_phase5_it="Fase 5/7 · Font"
m_phase6_it="Fase 6/7 · File di Configurazione"
m_phase7_it="Fase 7/7 · Neovim"
m_sheldon_created_it="~/.config/sheldon/plugins.toml creato"
m_kitty_conf_created_it="~/.config/kitty/kitty.conf creato"
m_zshrc_deployed_it="~/.zshrc distribuito (backup in ~/.zshrc.silmarillion.bak)"
m_bashrc_deployed_it="~/.bashrc distribuito (backup in ~/.bashrc.silmarillion.bak)"
m_profile_updated_it="~/.profile aggiornato (avvio automatico zsh)"
m_sheldon_installing_it="Installazione plugin sheldon..."
m_sheldon_done_it="Plugin sheldon installati"
m_sheldon_failed_it="sheldon lock fallito"
m_ping_deploying_it="Installazione tool ping basato su curl..."
m_ping_deployed_it="curl-ping installato (sostituisce /usr/bin/ping)"
m_install_done_it="Silmarillion Stack installato!"
m_next_steps_it="Prossimi passi:"
m_step1_it="1. Apri un nuovo terminale (kitty dovrebbe apparire nel launcher)"
m_step2_it="2. Il prompt p10k è preconfigurato — esegui 'p10k configure' per personalizzare"
m_step3_it="3. Installa una versione Node:  fnm install 22"
m_step4_it="4. Esegui 'p10k configure' per riconfigurare il prompt"
# --- Svenska ---
m_running_local_sv="Kör från lokal klon: %s"
m_cloning_repo_sv="Klonar Silmarillion till %s..."
m_clone_fail_sv="Kunde inte klona repo. Om du kör via curl, klona först:"
m_clone_cmd_sv="  git clone https://github.com/smartinez1685/Silmarillion.git ~/Silmarillion && cd ~/Silmarillion && bash install.sh"
m_p10k_present_sv="Powerlevel10k redan tillgängligt"
m_p10k_cloning_sv="Klonar Powerlevel10k..."
m_p10k_cloned_sv="Powerlevel10k klonat"
m_rust_installed_sv="Rust-verktygskedja redan installerad (%s)"
m_rust_installing_sv="Installerar Rust-verktygskedjan..."
m_rust_done_sv="Rust installerat"
m_go_installed_sv="Go redan installerat (%s)"
m_go_installing_sv="Installerar Go %s lokalt..."
m_go_done_sv="Go installerat"
m_already_installed_sv="%s redan installerat"
m_installing_cargo_sv="Installerar %s (cargo)..."
m_install_failed_sv="Misslyckades att installera %s"
m_installing_go_sv="Installerar %s (go)..."
m_atuin_installed_sv="atuin redan installerat (%s)"
m_atuin_installing_sv="Installerar atuin..."
m_atuin_done_sv="atuin installerat"
m_kitty_installed_sv="kitty redan installerat (%s)"
m_kitty_installing_sv="Installerar kitty..."
m_kitty_done_sv="kitty installerat"
m_frogmouth_installed_sv="frogmouth redan installerat (%s)"
m_frogmouth_installing_sv="Installerar frogmouth (venv)..."
m_frogmouth_done_sv="frogmouth installerat"
m_zed_installed_sv="zed redan installerat (%s)"
m_zed_installing_sv="Installerar zed..."
m_zed_done_sv="zed installerat"
m_fonts_installed_sv="Nerd Fonts redan installerade (%s varianter)"
m_fonts_downloading_sv="Laddar ner Nerd Fonts (60+ familjer)..."
m_fonts_ask_full_sv="Ladda ner alla 60+ Nerd Font-familjer? (~7 GB, annars bara UbuntuMono)"
m_fonts_downloading_mini_sv="Laddar ner UbuntuMono Nerd Font..."
m_fonts_extracting_sv="Extraherar typsnitt..."
m_fonts_done_sv="Nerd Fonts installerade (%s varianter)"
m_deploying_configs_sv="Distribuerar konfigurationsfiler..."
m_phase1_sv="Fas 1/7 · Tema och verktygskedjor"
m_phase2_sv="Fas 2/7 · Cargo-verktyg"
m_phase3_sv="Fas 3/7 · Go-verktyg"
m_phase4_sv="Fas 4/7 · Applikationer"
m_phase5_sv="Fas 5/7 · Typsnitt"
m_phase6_sv="Fas 6/7 · Konfigurationsfiler"
m_phase7_sv="Fas 7/7 · Neovim"
m_sheldon_created_sv="~/.config/sheldon/plugins.toml skapad"
m_kitty_conf_created_sv="~/.config/kitty/kitty.conf skapad"
m_zshrc_deployed_sv="~/.zshrc distribuerad (säkerhetskopia på ~/.zshrc.silmarillion.bak)"
m_bashrc_deployed_sv="~/.bashrc distribuerad (säkerhetskopia på ~/.bashrc.silmarillion.bak)"
m_profile_updated_sv="~/.profile uppdaterad (zsh auto-start)"
m_sheldon_installing_sv="Installerar sheldon-plugin..."
m_sheldon_done_sv="Sheldon-plugin installerade"
m_sheldon_failed_sv="sheldon lock misslyckades"
m_ping_deploying_sv="Installerar curl-baserat ping-verktyg..."
m_ping_deployed_sv="curl-ping installerat (ersätter /usr/bin/ping)"
m_install_done_sv="Silmarillion Stack installerad!"
m_next_steps_sv="Nästa steg:"
m_step1_sv="1. Öppna en ny terminal (kitty bör visas i din applikationsstartare)"
m_step2_sv="2. p10k-promptet är förkonfigurerat — kör 'p10k configure' för att anpassa"
m_step3_sv="3. Installera en Node-version:  fnm install 22"
m_step4_sv="4. Kör 'p10k configure' när som helst för att göra om prompt-inställningarna"
# --- Русский ---
m_running_local_ru="Запуск из локального клона: %s"
m_cloning_repo_ru="Клонирование Silmarillion в %s..."
m_clone_fail_ru="Не удалось клонировать репозиторий. При запуске через curl сначала клонируйте:"
m_clone_cmd_ru="  git clone https://github.com/smartinez1685/Silmarillion.git ~/Silmarillion && cd ~/Silmarillion && bash install.sh"
m_p10k_present_ru="Powerlevel10k уже присутствует"
m_p10k_cloning_ru="Клонирование Powerlevel10k..."
m_p10k_cloned_ru="Powerlevel10k клонирован"
m_rust_installed_ru="Rust toolchain уже установлен (%s)"
m_rust_installing_ru="Установка Rust toolchain..."
m_rust_done_ru="Rust установлен"
m_go_installed_ru="Go уже установлен (%s)"
m_go_installing_ru="Локальная установка Go %s..."
m_go_done_ru="Go установлен"
m_already_installed_ru="%s уже установлен"
m_installing_cargo_ru="Установка %s (cargo)..."
m_install_failed_ru="Не удалось установить %s"
m_installing_go_ru="Установка %s (go)..."
m_atuin_installed_ru="atuin уже установлен (%s)"
m_atuin_installing_ru="Установка atuin..."
m_atuin_done_ru="atuin установлен"
m_kitty_installed_ru="kitty уже установлен (%s)"
m_kitty_installing_ru="Установка kitty..."
m_kitty_done_ru="kitty установлен"
m_frogmouth_installed_ru="frogmouth уже установлен (%s)"
m_frogmouth_installing_ru="Установка frogmouth (venv)..."
m_frogmouth_done_ru="frogmouth установлен"
m_zed_installed_ru="zed уже установлен (%s)"
m_zed_installing_ru="Установка zed..."
m_zed_done_ru="zed установлен"
m_fonts_installed_ru="Nerd Fonts уже установлены (%s вариантов)"
m_fonts_downloading_ru="Загрузка Nerd Fonts (60+ семейств)..."
m_fonts_ask_full_ru="Загрузить все 60+ семейств Nerd Font? (~7 ГБ, иначе только UbuntuMono)"
m_fonts_downloading_mini_ru="Загрузка UbuntuMono Nerd Font..."
m_fonts_extracting_ru="Извлечение шрифтов..."
m_fonts_done_ru="Nerd Fonts установлены (%s вариантов)"
m_deploying_configs_ru="Развёртывание конфигурационных файлов..."
m_phase1_ru="Этап 1/7 · Тема и Toolchain"
m_phase2_ru="Этап 2/7 · Инструменты Cargo"
m_phase3_ru="Этап 3/7 · Инструменты Go"
m_phase4_ru="Этап 4/7 · Приложения"
m_phase5_ru="Этап 5/7 · Шрифты"
m_phase6_ru="Этап 6/7 · Конфигурационные файлы"
m_phase7_ru="Этап 7/7 · Neovim"
m_sheldon_created_ru="~/.config/sheldon/plugins.toml создан"
m_kitty_conf_created_ru="~/.config/kitty/kitty.conf создан"
m_zshrc_deployed_ru="~/.zshrc развёрнут (резервная копия: ~/.zshrc.silmarillion.bak)"
m_bashrc_deployed_ru="~/.bashrc развёрнут (резервная копия: ~/.bashrc.silmarillion.bak)"
m_profile_updated_ru="~/.profile обновлён (автозапуск zsh)"
m_sheldon_installing_ru="Установка плагинов sheldon..."
m_sheldon_done_ru="Плагины sheldon установлены"
m_sheldon_failed_ru="sheldon lock не удался"
m_ping_deploying_ru="Установка ping-утилиты на основе curl..."
m_ping_deployed_ru="curl-ping установлен (заменяет /usr/bin/ping)"
m_install_done_ru="Silmarillion Stack установлен!"
m_next_steps_ru="Следующие шаги:"
m_step1_ru="1. Откройте новый терминал (kitty должен появиться в панели приложений)"
m_step2_ru="2. Приглашение p10k предварительно настроено — выполните 'p10k configure' для настройки"
m_step3_ru="3. Установите версию Node:  fnm install 22"
m_step4_ru="4. Выполните 'p10k configure' для перенастройки приглашения"
# --- Português ---
m_running_local_pt="Executando a partir do clone local: %s"
m_cloning_repo_pt="A clonar Silmarillion para %s..."
m_clone_fail_pt="Não foi possível clonar o repositório. Se estiver a executar via curl, clone primeiro:"
m_clone_cmd_pt="  git clone https://github.com/smartinez1685/Silmarillion.git ~/Silmarillion && cd ~/Silmarillion && bash install.sh"
m_p10k_present_pt="Powerlevel10k já presente"
m_p10k_cloning_pt="A clonar Powerlevel10k..."
m_p10k_cloned_pt="Powerlevel10k clonado"
m_rust_installed_pt="Rust toolchain já instalado (%s)"
m_rust_installing_pt="A instalar Rust toolchain..."
m_rust_done_pt="Rust instalado"
m_go_installed_pt="Go já instalado (%s)"
m_go_installing_pt="A instalar Go %s localmente..."
m_go_done_pt="Go instalado"
m_already_installed_pt="%s já instalado"
m_installing_cargo_pt="A instalar %s (cargo)..."
m_install_failed_pt="Falha ao instalar %s"
m_installing_go_pt="A instalar %s (go)..."
m_atuin_installed_pt="atuin já instalado (%s)"
m_atuin_installing_pt="A instalar atuin..."
m_atuin_done_pt="atuin instalado"
m_kitty_installed_pt="kitty já instalado (%s)"
m_kitty_installing_pt="A instalar kitty..."
m_kitty_done_pt="kitty instalado"
m_frogmouth_installed_pt="frogmouth já instalado (%s)"
m_frogmouth_installing_pt="A instalar frogmouth (venv)..."
m_frogmouth_done_pt="frogmouth instalado"
m_zed_installed_pt="zed já instalado (%s)"
m_zed_installing_pt="A instalar zed..."
m_zed_done_pt="zed instalado"
m_fonts_installed_pt="Nerd Fonts já instaladas (%s variantes)"
m_fonts_downloading_pt="A descarregar Nerd Fonts (60+ famílias)..."
m_fonts_ask_full_pt="Descarregar todas as 60+ famílias Nerd Font? (~7 GB, senão apenas UbuntuMono)"
m_fonts_downloading_mini_pt="A descarregar UbuntuMono Nerd Font..."
m_fonts_extracting_pt="A extrair fontes..."
m_fonts_done_pt="Nerd Fonts instaladas (%s variantes)"
m_deploying_configs_pt="A implementar ficheiros de configuração..."
m_phase1_pt="Fase 1/7 · Tema e Toolchains"
m_phase2_pt="Fase 2/7 · Ferramentas Cargo"
m_phase3_pt="Fase 3/7 · Ferramentas Go"
m_phase4_pt="Fase 4/7 · Aplicações"
m_phase5_pt="Fase 5/7 · Fontes"
m_phase6_pt="Fase 6/7 · Ficheiros de Configuração"
m_phase7_pt="Fase 7/7 · Neovim"
m_sheldon_created_pt="~/.config/sheldon/plugins.toml criado"
m_kitty_conf_created_pt="~/.config/kitty/kitty.conf criado"
m_zshrc_deployed_pt="~/.zshrc implementado (cópia em ~/.zshrc.silmarillion.bak)"
m_bashrc_deployed_pt="~/.bashrc implementado (cópia em ~/.bashrc.silmarillion.bak)"
m_profile_updated_pt="~/.profile atualizado (início automático do zsh)"
m_sheldon_installing_pt="A instalar plugins do sheldon..."
m_sheldon_done_pt="Plugins do sheldon instalados"
m_sheldon_failed_pt="sheldon lock falhou"
m_ping_deploying_pt="A instalar ferramenta ping baseada em curl..."
m_ping_deployed_pt="curl-ping instalado (substitui /usr/bin/ping)"
m_install_done_pt="Silmarillion Stack instalado!"
m_next_steps_pt="Próximos passos:"
m_step1_pt="1. Abra um novo terminal (o kitty deve aparecer no seu lançador)"
m_step2_pt="2. O prompt p10k está pré-configurado — execute 'p10k configure' para personalizar"
m_step3_pt="3. Instale uma versão do Node:  fnm install 22"
m_step4_pt="4. Execute 'p10k configure' para reconfigurar o prompt"
# --- Ελληνικά (Greek) ---
m_running_local_el="Εκτέλεση από τοπικό κλώνο: %s"
m_cloning_repo_el="Κλωνοποίηση του Silmarillion στο %s..."
m_clone_fail_el="Αδυναμία κλωνοποίησης. Αν εκτελείτε μέσω curl, κλωνοποιήστε πρώτα:"
m_clone_cmd_el="  git clone https://github.com/smartinez1685/Silmarillion.git ~/Silmarillion && cd ~/Silmarillion && bash install.sh"
m_p10k_present_el="Το Powerlevel10k υπάρχει ήδη"
m_p10k_cloning_el="Κλωνοποίηση Powerlevel10k..."
m_p10k_cloned_el="Το Powerlevel10k κλωνοποιήθηκε"
m_rust_installed_el="Το Rust toolchain είναι ήδη εγκατεστημένο (%s)"
m_rust_installing_el="Εγκατάσταση Rust toolchain..."
m_rust_done_el="Το Rust εγκαταστάθηκε"
m_go_installed_el="Το Go είναι ήδη εγκατεστημένο (%s)"
m_go_installing_el="Τοπική εγκατάσταση Go %s..."
m_go_done_el="Το Go εγκαταστάθηκε"
m_already_installed_el="Το %s είναι ήδη εγκατεστημένο"
m_installing_cargo_el="Εγκατάσταση %s (cargo)..."
m_install_failed_el="Αποτυχία εγκατάστασης %s"
m_installing_go_el="Εγκατάσταση %s (go)..."
m_atuin_installed_el="Το atuin είναι ήδη εγκατεστημένο (%s)"
m_atuin_installing_el="Εγκατάσταση atuin..."
m_atuin_done_el="Το atuin εγκαταστάθηκε"
m_kitty_installed_el="Το kitty είναι ήδη εγκατεστημένο (%s)"
m_kitty_installing_el="Εγκατάσταση kitty..."
m_kitty_done_el="Το kitty εγκαταστάθηκε"
m_frogmouth_installed_el="Το frogmouth είναι ήδη εγκατεστημένο (%s)"
m_frogmouth_installing_el="Εγκατάσταση frogmouth (venv)..."
m_frogmouth_done_el="Το frogmouth εγκαταστάθηκε"
m_zed_installed_el="Το zed είναι ήδη εγκατεστημένο (%s)"
m_zed_installing_el="Εγκατάσταση zed..."
m_zed_done_el="Το zed εγκαταστάθηκε"
m_fonts_installed_el="Nerd Fonts ήδη εγκατεστημένες (%s παραλλαγές)"
m_fonts_downloading_el="Λήψη Nerd Fonts (60+ οικογένειες)..."
m_fonts_ask_full_el="Λήψη όλων των 60+ οικογενειών Nerd Font; (~7 GB, αλλιώς μόνο UbuntuMono)"
m_fonts_downloading_mini_el="Λήψη UbuntuMono Nerd Font..."
m_fonts_extracting_el="Εξαγωγή γραμματοσειρών..."
m_fonts_done_el="Nerd Fonts εγκατεστημένες (%s παραλλαγές)"
m_deploying_configs_el="Ανάπτυξη αρχείων διαμόρφωσης..."
m_phase1_el="Φάση 1/7 · Θέμα και Εργαλεία"
m_phase2_el="Φάση 2/7 · Εργαλεία Cargo"
m_phase3_el="Φάση 3/7 · Εργαλεία Go"
m_phase4_el="Φάση 4/7 · Εφαρμογές"
m_phase5_el="Φάση 5/7 · Γραμματοσειρές"
m_phase6_el="Φάση 6/7 · Αρχεία Διαμόρφωσης"
m_phase7_el="Φάση 7/7 · Neovim"
m_sheldon_created_el="~/.config/sheldon/plugins.toml δημιουργήθηκε"
m_kitty_conf_created_el="~/.config/kitty/kitty.conf δημιουργήθηκε"
m_zshrc_deployed_el="~/.zshrc αναπτύχθηκε (αντίγραφο στο ~/.zshrc.silmarillion.bak)"
m_bashrc_deployed_el="~/.bashrc αναπτύχθηκε (αντίγραφο στο ~/.bashrc.silmarillion.bak)"
m_profile_updated_el="~/.profile ενημερώθηκε (αυτόματη εκκίνηση zsh)"
m_sheldon_installing_el="Εγκατάσταση προσθηκών sheldon..."
m_sheldon_done_el="Οι προσθήκες sheldon εγκαταστάθηκαν"
m_sheldon_failed_el="το sheldon lock απέτυχε"
m_ping_deploying_el="Εγκατάσταση εργαλείου ping βασισμένου σε curl..."
m_ping_deployed_el="το curl-ping εγκαταστάθηκε (αντικαθιστά το /usr/bin/ping)"
m_install_done_el="Το Silmarillion Stack εγκαταστάθηκε!"
m_next_steps_el="Επόμενα βήματα:"
m_step1_el="1. Ανοίξτε ένα νέο τερματικό (το kitty θα εμφανιστεί στον εκκινητή σας)"
m_step2_el="2. Το p10k είναι προ-ρυθμισμένο — εκτελέστε 'p10k configure' για προσαρμογή"
m_step3_el="3. Εγκαταστήστε μια έκδοση Node:  fnm install 22"
m_step4_el="4. Εκτελέστε 'p10k configure' για επαναφορά των ρυθμίσεων του prompt"

export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$HOME/.atuin/bin:$HOME/go/bin:$HOME/.local/go/bin:$PATH"

# ── Determine repo directory ─────────────────────────────────────────────
SCRIPT_DIR="$(cd "$(dirname "$0")" 2>/dev/null && pwd || true)"
if [[ -n "$SCRIPT_DIR" && -f "$SCRIPT_DIR/install.sh" ]]; then
    REPO_DIR="$SCRIPT_DIR"
    log "$(msg running_local "$REPO_DIR")"
else
    REPO_DIR="$HOME/Silmarillion"
    if [[ ! -d "$REPO_DIR" ]]; then
        log "$(msg cloning_repo "$REPO_DIR")"
        git clone https://github.com/smartinez1685/Silmarillion.git "$REPO_DIR" 2>/dev/null || {
            warn "$(msg clone_fail)"
            warn "$(msg clone_cmd)"
            exit 1
        }
    fi
fi

# ── Phase 1: Theme & Toolchains ─────────────────────────────────────────
section "$(msg phase1)"

# ── Powerlevel10k ────────────────────────────────────────────────────────
P10K_DIR="$HOME/.powerlevel10k"
if [[ -f "$P10K_DIR/powerlevel10k.zsh-theme" ]]; then
    ok "$(msg p10k_present)"
else
    log "$(msg p10k_cloning)"
    git clone --depth 1 https://github.com/romkatv/powerlevel10k.git "$P10K_DIR"
    ok "$(msg p10k_cloned)"
fi

# ── Rust toolchain ───────────────────────────────────────────────────────
rustc_version="$(rustc --version 2>/dev/null || true)"
if command -v cargo &>/dev/null && [[ -n "$rustc_version" ]]; then
    ok "$(msg rust_installed "$rustc_version")"
else
    log "$(msg rust_installing)"
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
    . "$HOME/.cargo/env"
    ok "$(msg rust_done)"
fi

# ── Go toolchain (local, no root) ────────────────────────────────────────
GO_VERSION="1.24.5"
if command -v go &>/dev/null; then
    ok "$(msg go_installed "$(go version 2>/dev/null || true)")"
else
    log "$(msg go_installing "$GO_VERSION")"
    mkdir -p "$HOME/.local" "$HOME/go" "$HOME/tmp"
    curl -sL "https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz" -o /tmp/go.tar.gz
    tar -C "$HOME/.local" -xzf /tmp/go.tar.gz
    rm -f /tmp/go.tar.gz
    export GOROOT="$HOME/.local/go"
    export GOPATH="$HOME/go"
    export GOTMPDIR="$HOME/tmp"
    export PATH="$GOROOT/bin:$GOPATH/bin:$PATH"
    ok "$(msg go_done)"
fi

# Ensure Go env vars are set for this session
export GOROOT="${GOROOT:-$HOME/.local/go}"
export GOPATH="${GOPATH:-$HOME/go}"
export GOTMPDIR="${GOTMPDIR:-$HOME/tmp}"
export PATH="$GOROOT/bin:$GOPATH/bin:$PATH"

# ── Phase 2: Cargo tools ────────────────────────────────────────────────
section "$(msg phase2)"

cargo_install() {
    local crate="$1" bin="${2:-$1}"
    if command -v "$bin" &>/dev/null; then
        ok "$(msg already_installed "$bin")"
    else
        log "$(msg installing_cargo "$crate")"
        cargo install "$crate" || warn "$(msg install_failed "$crate")"
    fi
}

cargo_install sheldon
cargo_install eza
cargo_install zoxide
cargo_install fd-find fd
cargo_install bottom btm
cargo_install fnm
cargo_install xh

# ── Phase 3: Go tools ──────────────────────────────────────────────────
section "$(msg phase3)"

go_install() {
    local pkg="$1" bin="${2:-$(basename "$pkg")}"
    if command -v "$bin" &>/dev/null; then
        ok "$(msg already_installed "$bin")"
    else
        log "$(msg installing_go "$bin")"
        go install "${pkg}@latest" || warn "$(msg install_failed "$bin")"
    fi
}

mkdir -p "$HOME/tmp"
go_install github.com/junegunn/fzf fzf
go_install github.com/direnv/direnv direnv
go_install github.com/jesseduffield/lazygit lazygit

# ── Phase 4: Applications ──────────────────────────────────────────────
section "$(msg phase4)"

# ── Atuin ────────────────────────────────────────────────────────────────
if command -v atuin &>/dev/null; then
    ok "$(msg atuin_installed "$(atuin --version 2>/dev/null || true)")"
else
    log "$(msg atuin_installing)"
    curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh
    ok "$(msg atuin_done)"
fi

# ── Kitty terminal ───────────────────────────────────────────────────────
if command -v kitty &>/dev/null; then
    ok "$(msg kitty_installed "$(kitty --version 2>/dev/null || true)")"
else
    log "$(msg kitty_installing)"
    curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
    mkdir -p "$HOME/.local/bin"
    ln -sf "$HOME/.local/kitty.app/bin/kitty" "$HOME/.local/bin/kitty"
    # Desktop launcher
    mkdir -p "$HOME/.local/share/applications" "$HOME/.local/share/icons"
    ln -sf "$HOME/.local/kitty.app/share/applications/kitty.desktop" "$HOME/.local/share/applications/kitty.desktop" 2>/dev/null || true
    cp -rn "$HOME/.local/kitty.app/share/icons/"* "$HOME/.local/share/icons/" 2>/dev/null || true
    ok "$(msg kitty_done)"
fi

# ── Frogmouth ────────────────────────────────────────────────────────────
if command -v frogmouth &>/dev/null; then
    ok "$(msg frogmouth_installed "$(frogmouth --version 2>/dev/null || true)")"
else
    log "$(msg frogmouth_installing)"
    python3 -m venv "$HOME/.local/venvs/frogmouth"
    "$HOME/.local/venvs/frogmouth/bin/pip" install -q frogmouth
    mkdir -p "$HOME/.local/bin"
    ln -sf "$HOME/.local/venvs/frogmouth/bin/frogmouth" "$HOME/.local/bin/frogmouth"
    ok "$(msg frogmouth_done)"
fi

# ── Zed editor ───────────────────────────────────────────────────────────
if command -v zed &>/dev/null; then
    ok "$(msg zed_installed "$(zed --version 2>/dev/null || true)")"
else
    log "$(msg zed_installing)"
    curl -f https://zed.dev/install.sh | sh
    ok "$(msg zed_done)"
fi

# ── Phase 5: Fonts ─────────────────────────────────────────────────────
section "$(msg phase5)"

# ── Nerd Fonts ───────────────────────────────────────────────────────────
FONT_DIR="$HOME/.local/share/fonts"
NERD_FONTS_VERSION="v3.4.0"
if fc-list 2>/dev/null | grep -qi "Nerd Font"; then
    ok "$(msg fonts_installed "$(fc-list | grep -ci 'Nerd Font')")"
else
    mkdir -p "$FONT_DIR"
    FONT_FAMILIES=("UbuntuMono")
    # Ask about full font set when interactive
    if [[ -z "${SILMARILLION_FULL_FONTS:-}" && -t 0 ]]; then
        log "$(msg fonts_ask_full)"
        printf "  [y/N] "
        read -r full_fonts_choice
        case "$full_fonts_choice" in y|Y|yes|YES) SILMARILLION_FULL_FONTS=1 ;; esac
    fi
    if [[ -n "${SILMARILLION_FULL_FONTS:-}" ]]; then
        log "$(msg fonts_downloading)"
        FONT_FAMILIES=(
            0xProto 3270 AdwaitaMono Agave AnonymousPro Arimo
            AtkinsonHyperlegibleMono AurulentSansMono BigBlueTerminal
            BitstreamVeraSansMono IBMPlexMono CascadiaCode CascadiaMono
            CodeNewRoman ComicShannsMono CommitMono Cousine D2Coding
            DaddyTimeMono DejaVuSansMono DepartureMono DroidSansMono
            EnvyCodeR FantasqueSansMono FiraCode FiraMono GeistMono
            Go-Mono Gohu Hack Hasklig HeavyData Hermit iA-Writer
            Inconsolata InconsolataGo InconsolataLGC IntelOneMono Iosevka
            IosevkaTerm IosevkaTermSlab JetBrainsMono Lekton LiberationMono
            Lilex MartianMono Meslo Monaspace Monofur Monoid Mononoki MPlus
            Noto NerdFontsSymbolsOnly OpenDyslexic Overpass ProFont
            ProggyClean Recursive RobotoMono ShareTechMono SourceCodePro
            SpaceMono Terminus Tinos Ubuntu UbuntuMono UbuntuSans VictorMono ZedMono
        )
    else
        log "$(msg fonts_downloading_mini)"
    fi
    BASE="https://github.com/ryanoasis/nerd-fonts/releases/download/$NERD_FONTS_VERSION"
    for font in "${FONT_FAMILIES[@]}"; do
        curl -sL "$BASE/$font.zip" -o "/tmp/${font}.zip" &
    done
    wait
    log "$(msg fonts_extracting)"
    for font in "${FONT_FAMILIES[@]}"; do
        unzip -oq "/tmp/${font}.zip" -d "$FONT_DIR/${font}" 2>/dev/null || true
        rm -f "/tmp/${font}.zip"
    done
    fc-cache -fv "$FONT_DIR" 2>/dev/null
    ok "$(msg fonts_done "$(fc-list | grep -ci 'Nerd Font')")"
fi

# ── Phase 6: Config files ──────────────────────────────────────────────
section "$(msg phase6)"

# ── Deploy config files ──────────────────────────────────────────────────
log "$(msg deploying_configs)"

mkdir -p "$HOME/.config/sheldon" "$HOME/.config/kitty"

# --- sheldon plugins.toml ---
if [[ ! -f "$HOME/.config/sheldon/plugins.toml" ]]; then
    cat > "$HOME/.config/sheldon/plugins.toml" << 'SHELDON'
shell = "zsh"

[plugins.zsh-history-substring-search]
github = "zsh-users/zsh-history-substring-search"

[plugins.fast-syntax-highlighting]
github = "zdharma-continuum/fast-syntax-highlighting"

[plugins.zsh-autosuggestions]
github = "zsh-users/zsh-autosuggestions"
SHELDON
    ok "$(msg sheldon_created)"
fi

# --- kitty.conf ---
if [[ ! -f "$HOME/.config/kitty/kitty.conf" ]]; then
    cat > "$HOME/.config/kitty/kitty.conf" << 'KITTY'
font_family      UbuntuMono Nerd Font Mono
bold_font        UbuntuMono Nerd Font Mono Bold
italic_font      UbuntuMono Nerd Font Mono Italic
bold_italic_font UbuntuMono Nerd Font Mono Bold Italic
font_size        15.0

background_opacity 0.75
KITTY
    ok "$(msg kitty_conf_created)"
fi

# --- .zshrc ---
if [[ ! -f "$HOME/.zshrc.silmarillion.bak" ]]; then
    [[ -f "$HOME/.zshrc" ]] && cp "$HOME/.zshrc" "$HOME/.zshrc.silmarillion.bak"
fi
cat > "$HOME/.zshrc" << 'ZSHRC'
# =============================================================================
# ZSH CONFIG — Silmarillion Stack (Rust-powered)
# =============================================================================

# --- PATH ----------------------------------------------------------------
export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$HOME/.atuin/bin:$PATH"
export GOROOT="$HOME/.local/go"
export GOPATH="$HOME/go"
export GOTMPDIR="$HOME/tmp"
export PATH="$GOROOT/bin:$GOPATH/bin:$PATH"

. "$HOME/.cargo/env"

# --- ZSH options ---------------------------------------------------------
setopt autocd interactivecomments magicequalsubst nonomatch notify numericglobsort promptsubst
WORDCHARS=${WORDCHARS//\/}
PROMPT_EOL_MARK=""

# --- History -------------------------------------------------------------
HISTSIZE=1000000
SAVEHIST=1000000
HISTFILE=~/.zsh_history
setopt hist_expire_dups_first hist_ignore_dups hist_ignore_space hist_verify
alias history="history 0"
TIMEFMT=$'\nreal\t%E\nuser\t%U\nsys\t%S\ncpu\t%P'
export PAGER='less -S'

# --- Keybindings ---------------------------------------------------------
bindkey -e
bindkey ' ' magic-space
bindkey '^U' backward-kill-line
bindkey '^[[3;5~' kill-word
bindkey '^[[3~' delete-char
bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word
bindkey '^[[5~' beginning-of-buffer-or-history
bindkey '^[[6~' end-of-buffer-or-history
bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line
bindkey '^[[Z' undo

# --- Completion ----------------------------------------------------------
autoload -Uz compinit
compinit -d ~/.cache/zcompdump
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' rehash true
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

# --- Sheldon plugins -----------------------------------------------------
if command -v sheldon > /dev/null; then
    eval "$(sheldon source)"
fi

# --- Powerlevel10k prompt ------------------------------------------------
source ~/.powerlevel10k/powerlevel10k.zsh-theme
# Default p10k config — skips the interactive wizard on first shell
if [[ ! -f ~/.p10k.zsh ]]; then
    cat > ~/.p10k.zsh << 'P10K_CONF'
# Generated by Silmarillion Stack — classic 2-line prompt with round separators
POWERLEVEL9K_MODE=nerdfont-v3
POWERLEVEL9K_OS_ICON_BACKGROUND=2
POWERLEVEL9K_PROMPT_ON_NEWLINE=true
POWERLEVEL9K_RPROMPT_ON_NEWLINE=true
POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX='%242F╭─'
POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX='%242F╰─'
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(os_icon context dir vcs)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status command_execution_time time)
POWERLEVEL9K_SHOW_CHANGESET=true
POWERLEVEL9K_CHANGESET_HASH_LENGTH=6
POWERLEVEL9K_STATUS_VERBOSE=true
POWERLEVEL9K_TIME_FORMAT='%D{%H:%M}'
POWERLEVEL9K_DIR_BACKGROUND=4
POWERLEVEL9K_DIR_FOREGROUND=0
POWERLEVEL9K_VCS_BACKGROUND=8
POWERLEVEL9K_VCS_FOREGROUND=0
POWERLEVEL9K_CONTEXT_DEFAULT_BACKGROUND=2
POWERLEVEL9K_CONTEXT_DEFAULT_FOREGROUND=0
POWERLEVEL9K_STATUS_OK_BACKGROUND=2
POWERLEVEL9K_STATUS_OK_FOREGROUND=0
POWERLEVEL9K_STATUS_ERROR_BACKGROUND=1
POWERLEVEL9K_STATUS_ERROR_FOREGROUND=0
P10K_CONF
fi
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# --- Atuin history (Rust) ------------------------------------------------
[[ -f "$HOME/.atuin/bin/env" ]] && . "$HOME/.atuin/bin/env"
eval "$(timeout 2 atuin init zsh 2>/dev/null || true)"

# --- Zoxide (Rust) -------------------------------------------------------
eval "$(zoxide init zsh)"

# --- FZF -----------------------------------------------------------------
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
[ -f /usr/share/doc/fzf/examples/key-bindings.zsh ] && source /usr/share/doc/fzf/examples/key-bindings.zsh
[ -f /usr/share/doc/fzf/examples/completion.zsh ] && source /usr/share/doc/fzf/examples/completion.zsh
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# --- direnv (Go) ---------------------------------------------------------
eval "$(timeout 2 direnv hook zsh 2>/dev/null || true)"
alias a='direnv allow'

# --- fnm Node.js (Rust) --------------------------------------------------
export FNM_PATH="$HOME/.local/share/fnm"
export FNM_MULTISHELL_PATH="$HOME/.local/share/fnm_multishells"
mkdir -p "$FNM_MULTISHELL_PATH"
if [ -d "$FNM_PATH" ]; then
    export PATH="$FNM_PATH:$PATH"
    eval "$(fnm env --use-on-cd)"
fi

# --- Terminal title ------------------------------------------------------
case "$TERM" in
xterm*|rxvt*|Eterm|aterm|kterm|gnome*|alacritty|kitty)
    TERM_TITLE=$'\e]0;${debian_chroot:+($debian_chroot)}%n@%m: %~\a'
    ;;
esac
precmd() { print -Pnr -- "$TERM_TITLE"; }

# --- dircolors & aliases -------------------------------------------------
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
    zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
fi

alias ls='eza --icons --git'
alias ll='eza -lah --icons --git --group-directories-first'
alias lt='eza -lah --sort=modified --reverse --icons --git'
alias fdfind='fd'
alias grep='grep --color=auto'
alias diff='diff --color=auto'

alias v='nvim'
alias vim='nvim'
alias .z='vim ~/.zshrc'
alias .b='vim ~/.bashrc'
alias lz='lazygit'
alias btm='btm'
alias frg='frogmouth'
alias ...='cd ../../..'
alias ....='cd ../../../..'
alias .....='cd ../../../../..'
alias cfg='cd ~/.config'

# --- Env -----------------------------------------------------------------
export TMPDIR=~/tmp
export TEMPDIR=~/tmp
export XCURSOR_SIZE=48
export TERMINAL="kitty"

[ -f /etc/zsh_command_not_found ] && . /etc/zsh_command_not_found
ZSHRC
ok "$(msg zshrc_deployed)"

# --- .bashrc ---
if [[ ! -f "$HOME/.bashrc.silmarillion.bak" ]]; then
    [[ -f "$HOME/.bashrc" ]] && cp "$HOME/.bashrc" "$HOME/.bashrc.silmarillion.bak"
fi
cat > "$HOME/.bashrc" << 'BASHRC'
# =============================================================================
# BASH CONFIG — Silmarillion Stack (Rust-powered)
# =============================================================================
case $- in *i*) ;; *) return;; esac

export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$HOME/.atuin/bin:$PATH"
export GOROOT="$HOME/.local/go"
export GOPATH="$HOME/go"
export GOTMPDIR="$HOME/tmp"
export PATH="$GOROOT/bin:$GOPATH/bin:$PATH"
. "$HOME/.cargo/env"

shopt -s histappend checkwinsize
HISTCONTROL=ignoreboth
HISTSIZE=1000000
HISTFILESIZE=1000000
export PAGER='less -S'

case "$TERM" in xterm-color|*-256color) color_prompt=yes;; esac
if [ "$color_prompt" = yes ]; then
    PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='\u@\h:\w\$ '
fi
case "$TERM" in xterm*|rxvt*) PS1="\[\e]0;\u@\h: \w\a\]$PS1";; esac

[[ -f "$HOME/.atuin/bin/env" ]] && . "$HOME/.atuin/bin/env"
eval "$(timeout 2 atuin init bash 2>/dev/null || true)"
eval "$(zoxide init bash)"

export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
[ -f /usr/share/doc/fzf/examples/key-bindings.bash ] && source /usr/share/doc/fzf/examples/key-bindings.bash
[ -f /usr/share/doc/fzf/examples/completion.bash ] && source /usr/share/doc/fzf/examples/completion.bash

eval "$(timeout 2 direnv hook bash 2>/dev/null || true)"

export FNM_PATH="$HOME/.local/share/fnm"
if [ -d "$FNM_PATH" ]; then
    export PATH="$FNM_PATH:$PATH"
    eval "$(fnm env --use-on-cd)"
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
fi

alias ls='eza --icons --git'
alias ll='eza -lah --icons --git --group-directories-first'
alias lt='eza -lah --sort=modified --reverse --icons --git'
alias fdfind='fd'
alias grep='grep --color=auto'
alias diff='diff --color=auto'
alias v='nvim'
alias vim='nvim'
alias .z='vim ~/.zshrc'
alias .b='vim ~/.bashrc'
alias lz='lazygit'
alias btm='btm'
alias frg='frogmouth'
alias a='direnv allow'
alias ...='cd ../../..'
alias ....='cd ../../../..'
alias .....='cd ../../../../..'
alias cfg='cd ~/.config'

if ! shopt -oq posix; then
  [ -f /usr/share/bash-completion/bash_completion ] && . /usr/share/bash-completion/bash_completion
fi

export TMPDIR=~/tmp
export XCURSOR_SIZE=48
export TERMINAL="kitty"
[ -f ~/.bash_aliases ] && . ~/.bash_aliases
[ -f "$HOME/.local/bin/env" ] && . "$HOME/.local/bin/env"
[[ -f ~/.bash-preexec.sh ]] && source ~/.bash-preexec.sh
BASHRC
ok "$(msg bashrc_deployed)"

# --- .profile (zsh auto-launch) ---
if ! grep -q "exec.*zsh" "$HOME/.profile" 2>/dev/null; then
    cat >> "$HOME/.profile" << 'PROFILE'

# Silmarillion: auto-launch zsh on login
if [ -x /usr/bin/zsh ] && [ "$SHELL" != /usr/bin/zsh ]; then
    export SHELL=/usr/bin/zsh
    exec /usr/bin/zsh -l
fi
PROFILE
    ok "$(msg profile_updated)"
fi

# ── Phase 7: Neovim ────────────────────────────────────────────────────
section "$(msg phase7)"

# Install Neovim if not present
if command -v nvim &>/dev/null; then
    ok "Neovim already installed ($(nvim --version 2>/dev/null | head -1))"
else
    log "Installing Neovim..."
    if command -v apt &>/dev/null; then
        sudo apt install -y neovim 2>/dev/null || {
            warn "apt failed — installing from GitHub release..."
            curl -sL https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz -o /tmp/nvim.tar.gz
            mkdir -p "$HOME/.local"
            tar -xzf /tmp/nvim.tar.gz -C "$HOME/.local/"
            ln -sf "$HOME/.local/nvim-linux64/bin/nvim" "$HOME/.local/bin/nvim"
            rm -f /tmp/nvim.tar.gz
        }
    else
        curl -sL https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz -o /tmp/nvim.tar.gz
        mkdir -p "$HOME/.local"
        tar -xzf /tmp/nvim.tar.gz -C "$HOME/.local/"
        ln -sf "$HOME/.local/nvim-linux64/bin/nvim" "$HOME/.local/bin/nvim"
        rm -f /tmp/nvim.tar.gz
    fi
    ok "Neovim installed"
fi

# Deploy Neovim config
log "Deploying Neovim config..."
mkdir -p "$HOME/.config/nvim/lua/plugins"

# --- init.lua ---
cat > "$HOME/.config/nvim/init.lua" << 'NVIM_INIT'
require("settings")

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.g.python3_host_prog = '/usr/bin/python3'

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
        vim.fn.system({
                "git",
                "clone",
                "--filter=blob:none",
                "https://github.com/folke/lazy.nvim.git",
                "--branch=stable",
                lazypath,
        })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins")
NVIM_INIT

# --- lua/settings.lua ---
cat > "$HOME/.config/nvim/lua/settings.lua" << 'NVIM_SET'
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.termguicolors = true

vim.api.nvim_create_autocmd("BufReadPost", {
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

local function transparent_bg()
  local groups = { "Normal", "NormalNC", "LineNr", "Folded", "NonText", "SpecialKey", "VertSplit", "SignColumn", "EndOfBuffer" }
  for _, group in ipairs(groups) do
    vim.api.nvim_set_hl(0, group, { bg = "NONE", ctermbg = "NONE" })
  end
end
transparent_bg()
vim.api.nvim_create_autocmd("ColorScheme", { callback = transparent_bg })

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(ev)
    local opts = { buffer = ev.buf }
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
  end,
})
NVIM_SET

# --- lua/plugins/core.lua ---
cat > "$HOME/.config/nvim/lua/plugins/core.lua" << 'NVIM_CORE'
return {
  {
    "mason-org/mason.nvim",
    config = function()
      require("mason").setup()
    end
  },
  {
    "goolord/alpha-nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("alpha").setup(require("alpha.themes.startify").config)
    end
  },
  {
    "kiddos/gemini.nvim",
    enabled = false,
    build = "make",
    config = function()
      require("gemini").setup()
    end
  },
  {
    "gisketch/triforce.nvim",
    enabled = false,
    dependencies = { "nvim-lualine/lualine.nvim" }
  }
}
NVIM_CORE

# --- lua/plugins/lsp.lua ---
cat > "$HOME/.config/nvim/lua/plugins/lsp.lua" << 'NVIM_LSP'
return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
      "b0o/SchemaStore.nvim",
    },
    config = function()
      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = { "pyright", "yamlls", "lua_ls" },
      })
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      vim.lsp.config("pyright", {
        install = { cmd = { "pyright-langserver", "--stdio" } },
        options = { capabilities = capabilities }
      })
      vim.lsp.config("yamlls", {
        install = { cmd = { "yaml-language-server", "--stdio" } },
        options = {
          capabilities = capabilities,
          settings = {
            yaml = {
              schemaStore = { enable = false, url = "" },
              schemas = require("schemastore").yaml.schemas(),
            },
          },
        }
      })
      vim.lsp.config("lua_ls", {
        options = {
          capabilities = capabilities,
          settings = { Lua = { diagnostics = { globals = { "vim" } } } },
        }
      })
      vim.lsp.enable("pyright")
      vim.lsp.enable("yamlls")
      vim.lsp.enable("lua_ls")
    end,
  },
}
NVIM_LSP

# --- lua/plugins/completion.lua ---
cat > "$HOME/.config/nvim/lua/plugins/completion.lua" << 'NVIM_CMP'
return {
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "path" },
        }, {
          { name = "buffer" },
        }),
      })
    end,
  },
}
NVIM_CMP

# --- lua/plugins/lualine.lua ---
cat > "$HOME/.config/nvim/lua/plugins/lualine.lua" << 'NVIM_LUALINE'
return {
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local lualine = require("lualine")
      local function lsp_clients()
        local clients = vim.lsp.get_clients({ bufnr = 0 })
        if next(clients) == nil then return "No LSP" end
        local c_names = {}
        for _, client in pairs(clients) do
          table.insert(c_names, client.name)
        end
        return "⚙ " .. table.concat(c_names, ", ")
      end
      lualine.setup({
        options = {
          theme = "dracula",
          component_separators = { left = "│", right = "│" },
          section_separators = { left = "", right = "" },
          globalstatus = true,
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch", "diff", "diagnostics" },
          lualine_c = { { "filename", path = 1 } },
          lualine_x = { lsp_clients, "encoding", "fileformat", "filetype" },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
      })
    end,
  },
}
NVIM_LUALINE

# --- lua/plugins/telescope.lua ---
cat > "$HOME/.config/nvim/lua/plugins/telescope.lua" << 'NVIM_TELESCOPE'
return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      local telescope = require("telescope")
      local actions = require("telescope.actions")
      telescope.setup({
        defaults = {
          path_display = { "truncate" },
          preview = { treesitter = false },
          mappings = {
            i = {
              ["<C-k>"] = actions.move_selection_previous,
              ["<C-j>"] = actions.move_selection_next,
            },
          },
        },
      })
      telescope.load_extension("fzf")
      local km = vim.keymap
      km.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Find Files" })
      km.set("n", "<leader>fs", "<cmd>Telescope live_grep<cr>", { desc = "Find String" })
      km.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "Find Buffers" })
    end,
  },
}
NVIM_TELESCOPE

# --- lua/plugins/treesitter.lua ---
cat > "$HOME/.config/nvim/lua/plugins/treesitter.lua" << 'NVIM_TS'
return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").setup({
        ensure_installed = {
          "python", "yaml", "dockerfile", "markdown",
          "markdown_inline", "html", "javascript", "lua", "vim", "bash"
        },
        highlight = { enable = true, additional_vim_regex_highlighting = false },
        indent = { enable = true },
      })
    end,
  },
}
NVIM_TS

# --- lua/plugins/oil.lua ---
cat > "$HOME/.config/nvim/lua/plugins/oil.lua" << 'NVIM_OIL'
return {
  {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("oil").setup({
        default_file_explorer = true,
        skip_confirm_for_simple_edits = true,
        view_options = { show_hidden = true },
        float = { padding = 2, max_width = 80, max_height = 20, border = "rounded" },
      })
      vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
      vim.keymap.set("n", "<leader>e", "<CMD>Oil --float<CR>", { desc = "File Explorer" })
    end,
  },
}
NVIM_OIL

# --- lua/plugins/formatting.lua ---
cat > "$HOME/.config/nvim/lua/plugins/formatting.lua" << 'NVIM_FMT'
return {
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    opts = {
      formatters_by_ft = {
        python = { "ruff_fix", "ruff_format", "black" },
        lua = { "stylua" },
      },
      formatters = {
        black = { command = "uvx", args = { "black", "--stdin-filename", "$FILENAME", "-" } },
        ruff_fix = { command = "uvx", args = { "ruff", "check", "--fix", "--force-exclude", "--exit-zero", "--no-cache", "--stdin-filename", "$FILENAME", "-" } },
        ruff_format = { command = "uvx", args = { "ruff", "format", "--force-exclude", "--stdin-filename", "$FILENAME", "-" } },
      },
      format_on_save = { timeout_ms = 1000, lsp_fallback = true },
    },
  },
}
NVIM_FMT

# --- lua/plugins/indent.lua ---
cat > "$HOME/.config/nvim/lua/plugins/indent.lua" << 'NVIM_INDENT'
return {
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      indent = { char = "│", tab_char = "│" },
      scope = { enabled = true, show_start = false, show_end = false, highlight = "IblScope" },
      exclude = { filetypes = { "help", "alpha", "dashboard", "neo-tree", "Trouble", "trouble", "lazy", "mason", "notify", "toggleterm", "lazyterm" } },
    },
    config = function(_, opts)
      vim.api.nvim_set_hl(0, "IblScope", { fg = "#bd93f9", bold = true })
      vim.api.nvim_set_hl(0, "IblIndent", { fg = "#6272a4" })
      require("ibl").setup(opts)
    end,
  },
}
NVIM_INDENT

# --- lua/plugins/alpha.lua ---
cat > "$HOME/.config/nvim/lua/plugins/alpha.lua" << 'NVIM_ALPHA'
return {
  {
    "goolord/alpha-nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    lazy = false,
    priority = 1000,
    config = function()
      local alpha = require("alpha")
      local dashboard = require("alpha.themes.dashboard")
      dashboard.section.header.val = {
        [[                                                     /$$       /$$            /$$   /$$                                /$$            ]],
        [[                                                    | $$      | $$           | $$$ | $$                               |__/            ]],
        [[ /$$$$$$$   /$$$$$$ | $$$$$$$ | $$  /$$$$$$ | $$$$| $$  /$$$$$$   /$$$$$$  /$$    /$$ /$$ /$$$$$$/$$$$ ]],
        [[| $$__  $$ /$$__  $$| $$__  $$| $$ /$$__  $$| $$ $$ $$ /$$__  $$ /$$__  $$|  $$  /$$/| $$| $$_  $$_  $$]],
        [[| $$  \ $$| $$  \ $$| $$  \ $$| $$| $$$$$$$$| $$  $$$$| $$$$$$$$| $$  \ $$ \  $$/$$/ | $$| $$ \ $$ \ $$]],
        [[| $$  | $$| $$  | $$| $$  | $$| $$| $$_____/| $$\  $$$| $$_____/| $$  | $$  \\  $$$/  | $$| $$ | $$ | $$]],
        [[| $$  | $$|  $$$$$$/| $$$$$$$/| $$|  $$$$$$$| $$ \  $$|  $$$$$$$|  $$$$$$/   \\  $/   | $$| $$ | $$ | $$]],
        [[|__/  |__/ \______/ |_______/ |__/ \_______/|__/  \__/ \_______/ \______/     \_/    |__/|__/ |__/ |__/]],
      }
      dashboard.section.buttons.val = {
        dashboard.button("f", "  Find file", "<cmd>Telescope find_files<cr>"),
        dashboard.button("r", "  Recent files", "<cmd>Telescope oldfiles<cr>"),
        dashboard.button("s", "  Find text", "<cmd>Telescope live_grep<cr>"),
        dashboard.button("g", "  LazyGit", "<cmd>LazyGit<cr>"),
        dashboard.button("q", "  Quit", "<cmd>qa<cr>"),
      }
      dashboard.section.footer.val = "Hallo! Ready to code."
      dashboard.section.header.opts.hl = "AlphaHeader"
      dashboard.section.buttons.opts.hl = "AlphaButtons"
      dashboard.section.footer.opts.hl = "AlphaFooter"
      alpha.setup(dashboard.config)
      vim.api.nvim_set_hl(0, "AlphaHeader", { fg = "#bd93f9", bold = true })
      vim.api.nvim_set_hl(0, "AlphaButtons", { fg = "#8be9fd" })
      vim.api.nvim_set_hl(0, "AlphaFooter", { fg = "#6272a4", italic = true })
      vim.opt.shortmess:append("I")
      vim.keymap.set("n", "<leader>a", "<cmd>Alpha<cr>", { desc = "Dashboard" })
    end,
  },
}
NVIM_ALPHA

# --- lua/plugins/lazygit.lua ---
cat > "$HOME/.config/nvim/lua/plugins/lazygit.lua" << 'NVIM_LAZYGIT'
return {
  {
    "kdheepak/lazygit.nvim",
    cmd = { "LazyGit", "LazyGitConfig", "LazyGitCurrentFile", "LazyGitFilter", "LazyGitFilterCurrentFile" },
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = { { "<leader>lg", "<cmd>LazyGit<cr>", desc = "Open LazyGit" } },
  },
}
NVIM_LAZYGIT

ok "Neovim config deployed"
log "Installing Neovim plugins (lazy.nvim)..."
nvim --headless "+Lazy! sync" +qa 2>/dev/null && ok "Neovim plugins installed" || warn "Neovim plugin sync failed — run nvim manually to complete"

# ── Treesitter parsers ──────────────────────────────────────────────────
log "Installing treesitter parsers..."
if [ -x "$REPO_DIR/bin/install-treesitter-parsers" ]; then
    "$REPO_DIR/bin/install-treesitter-parsers" >/dev/null 2>&1 && ok "Treesitter parsers installed" || warn "Treesitter parser install failed"
fi

# ── Ping tool (curl-based, ICMP workaround) ─────────────────────────────
log "$(msg ping_deploying)"
mkdir -p "$HOME/.local/bin"
ln -sf "$REPO_DIR/bin/ping" "$HOME/.local/bin/ping"
ok "$(msg ping_deployed)"

# ── curl → xh wrapper ────────────────────────────────────────────────────
log "Deploying xh-based curl wrapper..."
ln -sf "$REPO_DIR/bin/curl" "$HOME/.local/bin/curl"
ln -sf "$REPO_DIR/bin/curl.sh" "$HOME/.local/bin/curl.sh"
ok "curl wrapper deployed (shadows /usr/bin/curl)"

# ── Sheldon lock ─────────────────────────────────────────────────────────
log "$(msg sheldon_installing)"
sheldon lock 2>/dev/null && ok "$(msg sheldon_done)" || warn "$(msg sheldon_failed)"

# ── Done ─────────────────────────────────────────────────────────────────
echo ""
echo -e "$SPLASH"
done_screen
