# Silmarillion Stack

> Ein Skript, um sie alle zu beherrschen — eine Rust/Go-betriebene Terminal-Umgebung, rootlos und eigenständig.

[🇬🇧 English](README.md) · [🇪🇸 Español](README.es.md) · [🇮🇹 Italiano](README.it.md) · [🇸🇪 Svenska](README.sv.md) · [🇷🇺 Русский](README.ru.md) · [🇵🇹 Português](README.pt.md) · [🇬🇷 Ελληνικά](README.el.md)

---

## Bestandteile des Stacks

| Ebene | Werkzeug | Sprache | Installation |
|-------|----------|---------|-------------|
| Terminal | **kitty** | C/Python | rootloser Installer |
| Shell | **ZSH** | C | System |
| Prompt | **powerlevel10k** | ZSH | git clone (beigelegt) |
| Plugin-Manager | **sheldon** | Rust | cargo |
| Syntax-Highlighting | **fast-syntax-highlighting** | ZSH | sheldon |
| Autovervollständigung | **zsh-autosuggestions** | ZSH | sheldon |
| Verlaufssuche | **zsh-history-substring-search** | ZSH | sheldon |
| Verlauf | **atuin** | Rust | curl-Skript |
| Navigation | **zoxide** | Rust | cargo |
| `ls` | **eza** | Rust | cargo |
| `find` | **fd** | Rust | cargo |
| Fuzzy-Finder | **fzf** | Go | go install |
| Umgebungsmanager | **direnv** | Go | go install |
| Node-Manager | **fnm** | Rust | cargo |
| Git-TUI | **lazygit** | Go | go install |
| Systemmonitor | **bottom** | Rust | cargo |
| Markdown-Betrachter | **frogmouth** | Python | pip (venv) |
| Editor (GUI) | **zed** | Rust | curl-Skript |
| Nerd Fonts | **60+ Familien** | — | GitHub-Releases |

## Schnellinstallation

```bash
curl -fsSL https://raw.githubusercontent.com/smartinez1685/Silmarillion/master/install.sh | bash
```

O klonen und lokal ausführen:

```bash
git clone https://github.com/smartinez1685/Silmarillion.git ~/Silmarillion
cd ~/Silmarillion && bash install.sh
```

Der Installer ist **idempotent** — du kannst ihn beliebig oft ausführen.

## Was der Installer macht

1. Installiert das Rust-Toolchain über rustup (falls fehlend)
2. Installiert Go lokal nach `~/.local/go` (falls fehlend)
3. Installiert Cargo-Pakete: sheldon, eza, zoxide, fd-find, bottom, fnm
4. Installiert Go-Binaries: fzf, direnv, lazygit
5. Installiert atuin über das offizielle curl-Skript
6. Installiert kitty über den offiziellen rootlosen Installer
7. Installiert frogmouth über pip in einer virtuellen Umgebung unter `~/.local/venvs/frogmouth`
8. Installiert zed über das offizielle curl-Skript
9. Lädt über 60 Nerd Font-Familien nach `~/.local/share/fonts/` herunter
10. Verteilt die Konfigurationen: `.zshrc`, `.bashrc`, `.profile`, kitty.conf, sheldon plugins.toml
11. Führt `sheldon lock` aus, um die ZSH-Plugins zu klonen
12. Führt `fc-cache -fv` aus, um die Schriftarten zu registrieren

## Kein Root erforderlich

Alles wird in `~/.local/`, `~/.cargo/`, `~/.go/` und `~/.config/` installiert. Kein `sudo` nötig.

## Verzeichnisstruktur

```
~/
├── .zshrc                  # Haupt-ZSH-Konfiguration (p10k + alle Werkzeuge)
├── .bashrc                 # Bash-Konfiguration (gleiche Werkzeug-Aliase)
├── .profile                # Startet zsh automatisch bei Anmeldung
├── .config/
│   ├── kitty/kitty.conf    # Terminal: UbuntuMono Nerd Font, 15pt, 75% Deckkraft
│   └── sheldon/plugins.toml
├── .local/
│   ├── bin/                # Benutzer-Binaries (kitty, frogmouth, zed, ...)
│   ├── share/fonts/        # 60+ Nerd Font-Familien
│   ├── go/                 # Go-Toolchain
│   └── kitty.app/          # Kitty-Installation
├── .cargo/bin/             # Rust-Toolchain + Cargo-Werkzeuge
├── Silmarillion/
│   ├── powerlevel10k/      # p10k-Theme
│   ├── install.sh          # Dieser Installer
│   └── README.md           # Diese Datei
└── go/bin/                 # Go-Binaries (fzf, direnv, lazygit)
```

## Nach der Installation

Öffne ein **neues Terminal** — p10k startet den Konfigurationsassistenten beim ersten Start. Wähle:

- **Nerd Font v3** + powerline
- **Classic** style
- **Unicode** icons
- **Darkest** colors
- **2-line** prompt
- **Round** separators

Jederzeit wiederholbar mit `p10k configure`.

## Anpassung

- **Schriftart:** Bearbeite `~/.config/kitty/kitty.conf`
- **Plugins:** Bearbeite `~/.config/sheldon/plugins.toml` und führe dann `sheldon lock` aus
- **Aliase:** Bearbeite `~/.zshrc` (mit bash geteilt über `~/.bashrc`)

## Deinstallation

Lösche, was der Installer erstellt hat:

```bash
rm -rf ~/.local/kitty.app ~/.local/venvs/frogmouth ~/.local/share/fonts/*
rm -rf ~/.cargo ~/.rustup ~/go ~/.local/go
rm -rf ~/.local/share/sheldon ~/.local/share/atuin
# Konfigurationen (vorher sichern, falls angepasst)
rm ~/.zshrc ~/.bashrc ~/.config/kitty/kitty.conf ~/.config/sheldon/plugins.toml
```

## Lizenz

MIT — wie powerlevel10k und die einzelnen enthaltenen Werkzeuge.
