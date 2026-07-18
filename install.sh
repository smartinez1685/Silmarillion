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

export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$HOME/.atuin/bin:$HOME/go/bin:$HOME/.local/go/bin:$PATH"

# ── Determine repo directory ─────────────────────────────────────────────
if [[ -f "$(dirname "$0")/../powerlevel10k/powerlevel10k.zsh-theme" ]]; then
    REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"
    log "Running from local clone: $REPO_DIR"
else
    REPO_DIR="$HOME/Silmarillion"
    if [[ ! -d "$REPO_DIR" ]]; then
        log "Cloning Silmarillion to $REPO_DIR..."
        git clone https://github.com/smartinez1685/Silmarillion.git "$REPO_DIR" 2>/dev/null || {
            warn "Could not clone repo. If you're running via curl, clone first:"
            warn "  git clone https://github.com/smartinez1685/Silmarillion.git ~/Silmarillion && cd ~/Silmarillion && bash install.sh"
            exit 1
        }
    fi
fi

# ── Rust toolchain ───────────────────────────────────────────────────────
if command -v cargo &>/dev/null; then
    ok "Rust toolchain already installed ($(rustc --version 2>/dev/null || true))"
else
    log "Installing Rust toolchain..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
    . "$HOME/.cargo/env"
    ok "Rust installed"
fi

# ── Go toolchain (local, no root) ────────────────────────────────────────
GO_VERSION="1.24.5"
if command -v go &>/dev/null; then
    ok "Go already installed ($(go version 2>/dev/null || true))"
else
    log "Installing Go $GO_VERSION locally..."
    mkdir -p "$HOME/.local" "$HOME/go" "$HOME/tmp"
    curl -sL "https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz" -o /tmp/go.tar.gz
    tar -C "$HOME/.local" -xzf /tmp/go.tar.gz
    rm -f /tmp/go.tar.gz
    export GOROOT="$HOME/.local/go"
    export GOPATH="$HOME/go"
    export GOTMPDIR="$HOME/tmp"
    export PATH="$GOROOT/bin:$GOPATH/bin:$PATH"
    ok "Go installed"
fi

# Ensure Go env vars are set for this session
export GOROOT="${GOROOT:-$HOME/.local/go}"
export GOPATH="${GOPATH:-$HOME/go}"
export GOTMPDIR="${GOTMPDIR:-$HOME/tmp}"
export PATH="$GOROOT/bin:$GOPATH/bin:$PATH"

# ── Cargo tools ──────────────────────────────────────────────────────────
cargo_install() {
    local crate="$1" bin="${2:-$1}"
    if command -v "$bin" &>/dev/null; then
        ok "$bin already installed"
    else
        log "Installing $crate (cargo)..."
        cargo install "$crate" || warn "Failed to install $crate"
    fi
}

cargo_install sheldon
cargo_install eza
cargo_install zoxide
cargo_install fd-find fd
cargo_install bottom btm
cargo_install fnm

# ── Go tools ─────────────────────────────────────────────────────────────
go_install() {
    local pkg="$1" bin="${2:-$(basename "$pkg")}"
    if command -v "$bin" &>/dev/null; then
        ok "$bin already installed"
    else
        log "Installing $bin (go)..."
        go install "${pkg}@latest" || warn "Failed to install $bin"
    fi
}

mkdir -p "$HOME/tmp"
go_install github.com/junegunn/fzf fzf
go_install github.com/direnv/direnv direnv
go_install github.com/jesseduffield/lazygit lazygit

# ── Atuin ────────────────────────────────────────────────────────────────
if command -v atuin &>/dev/null; then
    ok "atuin already installed ($(atuin --version 2>/dev/null || true))"
else
    log "Installing atuin..."
    curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh
    ok "atuin installed"
fi

# ── Kitty terminal ───────────────────────────────────────────────────────
if command -v kitty &>/dev/null; then
    ok "kitty already installed ($(kitty --version 2>/dev/null || true))"
else
    log "Installing kitty..."
    curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
    ln -sf "$HOME/.local/kitty.app/bin/kitty" "$HOME/.local/bin/kitty"
    # Desktop launcher
    mkdir -p "$HOME/.local/share/applications" "$HOME/.local/share/icons"
    ln -sf "$HOME/.local/kitty.app/share/applications/kitty.desktop" "$HOME/.local/share/applications/kitty.desktop" 2>/dev/null || true
    cp -rn "$HOME/.local/kitty.app/share/icons/"* "$HOME/.local/share/icons/" 2>/dev/null || true
    ok "kitty installed"
fi

# ── Frogmouth ────────────────────────────────────────────────────────────
if command -v frogmouth &>/dev/null; then
    ok "frogmouth already installed ($(frogmouth --version 2>/dev/null || true))"
else
    log "Installing frogmouth (venv)..."
    python3 -m venv "$HOME/.local/venvs/frogmouth"
    "$HOME/.local/venvs/frogmouth/bin/pip" install -q frogmouth
    ln -sf "$HOME/.local/venvs/frogmouth/bin/frogmouth" "$HOME/.local/bin/frogmouth"
    ok "frogmouth installed"
fi

# ── Zed editor ───────────────────────────────────────────────────────────
if command -v zed &>/dev/null; then
    ok "zed already installed ($(zed --version 2>/dev/null || true))"
else
    log "Installing zed..."
    curl -f https://zed.dev/install.sh | sh
    ok "zed installed"
fi

# ── Nerd Fonts ───────────────────────────────────────────────────────────
FONT_DIR="$HOME/.local/share/fonts"
NERD_FONTS_VERSION="v3.4.0"
if fc-list 2>/dev/null | grep -qi "Nerd Font"; then
    ok "Nerd Fonts already installed ($(fc-list | grep -ci 'Nerd Font') variants)"
else
    log "Downloading Nerd Fonts (60+ families)..."
    mkdir -p "$FONT_DIR"
    NERD_FONTS=(
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
    BASE="https://github.com/ryanoasis/nerd-fonts/releases/download/$NERD_FONTS_VERSION"
    for font in "${NERD_FONTS[@]}"; do
        curl -sL "$BASE/$font.zip" -o "/tmp/${font}.zip" &
    done
    wait
    log "Extracting fonts..."
    for font in "${NERD_FONTS[@]}"; do
        unzip -oq "/tmp/${font}.zip" -d "$FONT_DIR/${font}" 2>/dev/null || true
        rm -f "/tmp/${font}.zip"
    done
    fc-cache -fv "$FONT_DIR" 2>/dev/null
    ok "Nerd Fonts installed ($(fc-list | grep -ci 'Nerd Font') variants)"
fi

# ── Deploy config files ──────────────────────────────────────────────────
log "Deploying config files..."

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
    ok "~/.config/sheldon/plugins.toml created"
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
    ok "~/.config/kitty/kitty.conf created"
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
source ~/Silmarillion/powerlevel10k/powerlevel10k.zsh-theme
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# --- Atuin history (Rust) ------------------------------------------------
. "$HOME/.atuin/bin/env"
eval "$(atuin init zsh)"

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
eval "$(direnv hook zsh)"
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
ok "~/.zshrc deployed (backup at ~/.zshrc.silmarillion.bak)"

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

. "$HOME/.atuin/bin/env"
eval "$(atuin init bash)"
eval "$(zoxide init bash)"

export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
[ -f /usr/share/doc/fzf/examples/key-bindings.bash ] && source /usr/share/doc/fzf/examples/key-bindings.bash
[ -f /usr/share/doc/fzf/examples/completion.bash ] && source /usr/share/doc/fzf/examples/completion.bash

eval "$(direnv hook bash)"

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
ok "~/.bashrc deployed (backup at ~/.bashrc.silmarillion.bak)"

# --- .profile (zsh auto-launch) ---
if ! grep -q "exec.*zsh" "$HOME/.profile" 2>/dev/null; then
    cat >> "$HOME/.profile" << 'PROFILE'

# Silmarillion: auto-launch zsh on login
if [ -x /usr/bin/zsh ] && [ "$SHELL" != /usr/bin/zsh ]; then
    export SHELL=/usr/bin/zsh
    exec /usr/bin/zsh -l
fi
PROFILE
    ok "~/.profile updated (zsh auto-launch)"
fi

# ── Sheldon lock ─────────────────────────────────────────────────────────
log "Installing sheldon plugins..."
sheldon lock 2>/dev/null && ok "Sheldon plugins installed" || warn "sheldon lock failed"

# ── Done ─────────────────────────────────────────────────────────────────
echo ""
echo -e "  ${BOLD}${GREEN}Silmarillion Stack installed!${NC}"
echo ""
echo "  Next steps:"
echo "    1. Open a new terminal (kitty should appear in your app launcher)"
echo "    2. p10k will launch its config wizard on first zsh run"
echo "    3. Install a Node version:  fnm install 22"
echo "    4. Run 'p10k configure' anytime to redo prompt setup"
echo ""
