# Silmarillion Stack

> Un script per domarli tutti — un ambiente terminale potenziato da Rust/Go, senza root e autonomo.

[🇬🇧 English](README.md) · [🇪🇸 Español](README.es.md) · [🇩🇪 Deutsch](README.de.md) · [🇸🇪 Svenska](README.sv.md) · [🇷🇺 Русский](README.ru.md) · [🇵🇹 Português](README.pt.md) · [🇬🇷 Ελληνικά](README.el.md)

---

## Componenti dello stack

| Livello | Strumento | Linguaggio | Installazione |
|---------|-----------|------------|---------------|
| Terminale | **kitty** | C/Python | installer senza root |
| Shell | **ZSH** | C | sistema |
| Prompt | **powerlevel10k** | ZSH | git clone (incluso) |
| Gestore plugin | **sheldon** | Rust | cargo |
| Evidenziazione sintassi | **fast-syntax-highlighting** | ZSH | sheldon |
| Suggerimenti | **zsh-autosuggestions** | ZSH | sheldon |
| Ricerca cronologia | **zsh-history-substring-search** | ZSH | sheldon |
| Cronologia | **atuin** | Rust | script curl |
| Navigazione | **zoxide** | Rust | cargo |
| `ls` | **eza** | Rust | cargo |
| `find` | **fd** | Rust | cargo |
| Ricerca fuzzy | **fzf** | Go | go install |
| Gestore ambienti | **direnv** | Go | go install |
| Gestore Node | **fnm** | Rust | cargo |
| TUI Git | **lazygit** | Go | go install |
| Monitor di sistema | **bottom** | Rust | cargo |
| Visualizzatore Markdown | **frogmouth** | Python | pip (venv) |
| Editor (GUI) | **zed** | Rust | script curl |
| Nerd Fonts | **60+ famiglie** | — | GitHub releases |

## Installazione rapida

```bash
curl -fsSL https://raw.githubusercontent.com/smartinez1685/Silmarillion/main/install.sh | bash
```

Oppure clona ed esegui localmente:

```bash
git clone https://github.com/smartinez1685/Silmarillion.git ~/Silmarillion
cd ~/Silmarillion && bash install.sh
```

L'installer è **idempotente** — puoi eseguirlo più volte senza problemi.

## Cosa fa l'installer

1. Installa il toolchain Rust tramite rustup (se mancante)
2. Installa Go localmente in `~/.local/go` (se mancante)
3. Installa pacchetti cargo: sheldon, eza, zoxide, fd-find, bottom, fnm
4. Installa binari Go: fzf, direnv, lazygit
5. Installa atuin tramite lo script curl ufficiale
6. Installa kitty tramite l'installer ufficiale senza root
7. Installa frogmouth tramite pip in un ambiente virtuale in `~/.local/venvs/frogmouth`
8. Installa zed tramite lo script curl ufficiale
9. Scarica oltre 60 famiglie di Nerd Fonts in `~/.local/share/fonts/`
10. Distribuisce le configurazioni: `.zshrc`, `.bashrc`, `.profile`, kitty.conf, plugins.toml di sheldon
11. Esegue `sheldon lock` per clonare i plugin ZSH
12. Esegue `fc-cache -fv` per registrare i font

## Nessun root richiesto

Tutto viene installato in `~/.local/`, `~/.cargo/`, `~/.go/` e `~/.config/`. Non serve `sudo`.

## Struttura delle directory

```
~/
├── .zshrc                  # Configurazione ZSH principale (p10k + tutti gli strumenti)
├── .bashrc                 # Configurazione Bash (stessi alias degli strumenti)
├── .profile                # Avvia zsh automaticamente al login
├── .config/
│   ├── kitty/kitty.conf    # Terminale: UbuntuMono Nerd Font, 15pt, 75% opacità
│   └── sheldon/plugins.toml
├── .local/
│   ├── bin/                # Binari utente (kitty, frogmouth, zed, ...)
│   ├── share/fonts/        # 60+ famiglie Nerd Font
│   ├── go/                 # Toolchain Go
│   └── kitty.app/          # Installazione Kitty
├── .cargo/bin/             # Toolchain Rust + strumenti cargo
├── Silmarillion/
│   ├── powerlevel10k/      # Tema p10k
│   ├── install.sh          # Questo installer
│   └── README.md           # Questo file
└── go/bin/                 # Binari Go (fzf, direnv, lazygit)
```

## Post-installazione

Apri un **nuovo terminale** — p10k avvierà la procedura guidata al primo avvio. Scegli:

- **Nerd Font v3** + powerline
- **Classic** style
- **Unicode** icons
- **Darkest** colors
- **2-line** prompt
- **Round** separators

Rieseguibile in qualsiasi momento con `p10k configure`.

## Personalizzazione

- **Font:** Modifica `~/.config/kitty/kitty.conf`
- **Plugin:** Modifica `~/.config/sheldon/plugins.toml` poi esegui `sheldon lock`
- **Alias:** Modifica `~/.zshrc` (condiviso con bash tramite `~/.bashrc`)

## Disinstallazione

Elimina ciò che l'installer ha creato:

```bash
rm -rf ~/.local/kitty.app ~/.local/venvs/frogmouth ~/.local/share/fonts/*
rm -rf ~/.cargo ~/.rustup ~/go ~/.local/go
rm -rf ~/.local/share/sheldon ~/.local/share/atuin
# Configurazioni (fai un backup se le hai personalizzate)
rm ~/.zshrc ~/.bashrc ~/.config/kitty/kitty.conf ~/.config/sheldon/plugins.toml
```

## Licenza

MIT — come powerlevel10k e i singoli strumenti inclusi.
