# Silmarillion Stack

> Ett skript för att styra dem alla — en Rust/Go-driven terminalmiljö, rootlös och självförsörjande.

[🇬🇧 English](README.md) · [🇪🇸 Español](README.es.md) · [🇩🇪 Deutsch](README.de.md) · [🇮🇹 Italiano](README.it.md) · [🇷🇺 Русский](README.ru.md) · [🇵🇹 Português](README.pt.md)

---

## Stackens komponenter

| Lager | Verktyg | Språk | Installation |
|-------|---------|-------|--------------|
| Terminal | **kitty** | C/Python | rootlös installerare |
| Skal | **ZSH** | C | system |
| Prompt | **powerlevel10k** | ZSH | git clone (medföljer) |
| Plugin-hanterare | **sheldon** | Rust | cargo |
| Syntaxmarkering | **fast-syntax-highlighting** | ZSH | sheldon |
| Autoförslag | **zsh-autosuggestions** | ZSH | sheldon |
| Historiksökning | **zsh-history-substring-search** | ZSH | sheldon |
| Historik | **atuin** | Rust | curl-skript |
| Navigering | **zoxide** | Rust | cargo |
| `ls` | **eza** | Rust | cargo |
| `find` | **fd** | Rust | cargo |
| Fuzzy-sökare | **fzf** | Go | go install |
| Miljöväxlare | **direnv** | Go | go install |
| Node-hanterare | **fnm** | Rust | cargo |
| Git-TUI | **lazygit** | Go | go install |
| Systemövervakare | **bottom** | Rust | cargo |
| Markdown-visare | **frogmouth** | Python | pip (venv) |
| Editor (GUI) | **zed** | Rust | curl-skript |
| Nerd Fonts | **60+ familjer** | — | GitHub-releaser |

## Snabbinstallation

```bash
curl -fsSL https://raw.githubusercontent.com/smartinez1685/Silmarillion/main/install.sh | bash
```

Eller klona och kör lokalt:

```bash
git clone https://github.com/smartinez1685/Silmarillion.git ~/Silmarillion
cd ~/Silmarillion && bash install.sh
```

Installationsskriptet är **idempotent** — du kan köra det flera gånger utan problem.

## Vad installationsskriptet gör

1. Installerar Rust-verktygskedjan via rustup (om den saknas)
2. Installerar Go lokalt i `~/.local/go` (om det saknas)
3. Installerar cargo-paket: sheldon, eza, zoxide, fd-find, bottom, fnm
4. Installerar Go-binärfiler: fzf, direnv, lazygit
5. Installerar atuin via det officiella curl-skriptet
6. Installerar kitty via den officiella rootlösa installeraren
7. Installerar frogmouth via pip i en virtuell miljö under `~/.local/venvs/frogmouth`
8. Installerar zed via det officiella curl-skriptet
9. Laddar ner över 60 Nerd Font-familjer till `~/.local/share/fonts/`
10. Distribuerar konfigurationer: `.zshrc`, `.bashrc`, `.profile`, kitty.conf, sheldon plugins.toml
11. Kör `sheldon lock` för att klona ZSH-plugin
12. Kör `fc-cache -fv` för att registrera typsnitten

## Ingen root krävs

Allt installeras i `~/.local/`, `~/.cargo/`, `~/.go/` och `~/.config/`. Ingen `sudo` behövs.

## Katalogstruktur

```
~/
├── .zshrc                  # Huvudkonfiguration för ZSH (p10k + alla verktyg)
├── .bashrc                 # Bash-konfiguration (samma verktygsalias)
├── .profile                # Startar zsh automatiskt vid inloggning
├── .config/
│   ├── kitty/kitty.conf    # Terminal: UbuntuMono Nerd Font, 15pt, 75% opacitet
│   └── sheldon/plugins.toml
├── .local/
│   ├── bin/                # Användarbinärfiler (kitty, frogmouth, zed, ...)
│   ├── share/fonts/        # 60+ Nerd Font-familjer
│   ├── go/                 # Go-verktygskedja
│   └── kitty.app/          # Kitty-installation
├── .cargo/bin/             # Rust-verktygskedja + cargo-verktyg
├── Silmarillion/
│   ├── powerlevel10k/      # p10k-tema
│   ├── install.sh          # Detta installationsskript
│   └── README.md           # Denna fil
└── go/bin/                 # Go-binärfiler (fzf, direnv, lazygit)
```

## Efter installationen

Öppna en **ny terminal** — p10k startar konfigurationsguiden första gången. Välj:

- **Nerd Font v3** + powerline
- **Classic** style
- **Unicode** icons
- **Darkest** colors
- **2-line** prompt
- **Round** separators

Kör när som helst med `p10k configure`.

## Anpassning

- **Typsnitt:** Redigera `~/.config/kitty/kitty.conf`
- **Plugin:** Redigera `~/.config/sheldon/plugins.toml` och kör sedan `sheldon lock`
- **Alias:** Redigera `~/.zshrc` (delas med bash via `~/.bashrc`)

## Avinstallation

Ta bort vad installationsskriptet skapade:

```bash
rm -rf ~/.local/kitty.app ~/.local/venvs/frogmouth ~/.local/share/fonts/*
rm -rf ~/.cargo ~/.rustup ~/go ~/.local/go
rm -rf ~/.local/share/sheldon ~/.local/share/atuin
# Konfigurationer (säkerhetskopiera om du anpassat dem)
rm ~/.zshrc ~/.bashrc ~/.config/kitty/kitty.conf ~/.config/sheldon/plugins.toml
```

## Licens

MIT — samma som powerlevel10k och de enskilda ingående verktygen.
