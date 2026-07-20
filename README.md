# Silmarillion Stack

> One script to rule them all — a Rust/Go-powered terminal environment, rootless and self-contained.

[🇪🇸 Español](README.es.md) · [🇩🇪 Deutsch](README.de.md) · [🇮🇹 Italiano](README.it.md) · [🇸🇪 Svenska](README.sv.md) · [🇷🇺 Русский](README.ru.md) · [🇵🇹 Português](README.pt.md) · [🇬🇷 Ελληνικά](README.el.md)

---

## What's in the stack

| Layer | Tool | Lang | Install |
|-------|------|------|---------|
| Terminal | **kitty** | C/Python | rootless installer |
| Shell | **ZSH** | C | system |
| Prompt | **powerlevel10k** | ZSH | git clone |
| Plugin mgr | **sheldon** | Rust | cargo |
| Syntax highlight | **fast-syntax-highlighting** | ZSH | sheldon |
| Autosuggestions | **zsh-autosuggestions** | ZSH | sheldon |
| History search | **zsh-history-substring-search** | ZSH | sheldon |
| History | **atuin** | Rust | curl script |
| Navigation | **zoxide** | Rust | cargo |
| `ls` | **eza** | Rust | cargo |
| `find` | **fd** | Rust | cargo |
| Fuzzy finder | **fzf** | Go | go install |
| Env switcher | **direnv** | Go | go install |
| Node manager | **fnm** | Rust | cargo |
| Git TUI | **lazygit** | Go | go install |
| System monitor | **bottom** | Rust | cargo |
| Markdown viewer | **frogmouth** | Python | pip (venv) |
| Editor (GUI) | **zed** | Rust | curl script |
| Nerd Fonts | **60+ families** | — | GitHub releases |

## Quick install

```bash
curl -fsSL https://raw.githubusercontent.com/.../install.sh | bash
```

Or clone and run locally:

```bash
git clone https://github.com/smartinez1685/Silmarillion.git ~/Silmarillion
cd ~/Silmarillion && bash install.sh
```

The installer is **idempotent** — run it multiple times safely.

## What the installer does

1. Installs Rust toolchain via rustup (if missing)
2. Installs Go locally to `~/.local/go` (if missing)
3. Installs cargo crates: sheldon, eza, zoxide, fd-find, bottom, fnm
4. Installs Go binaries: fzf, direnv, lazygit
5. Installs atuin via official curl script
6. Installs kitty via official rootless installer
7. Installs frogmouth via pip in a venv at `~/.local/venvs/frogmouth`
8. Installs zed via official curl script
9. Downloads UbuntuMono Nerd Font to `~/.local/share/fonts/` (optionally all 60+ families)
10. Deploys configs: `.zshrc`, `.bashrc`, `.profile`, `.p10k.zsh`, kitty.conf, sheldon plugins.toml
11. Sets ZSH as the default shell
12. Runs `sheldon lock` to clone ZSH plugins
13. Runs `fc-cache -fv` to register fonts

## No root required

Everything installs to `~/.local/`, `~/.cargo/`, `~/.go/`, and `~/.config/`. No `sudo` needed.

## Directory structure

```
~/
├── .zshrc                  # Main ZSH config (p10k + all tools)
├── .bashrc                 # Bash config (same tool aliases)
├── .profile                # Auto-launches zsh on login
├── .p10k.zsh             # Pre-configured powerlevel10k prompt
├── .config/
│   ├── kitty/kitty.conf    # Terminal: UbuntuMono Nerd Font, 15pt, 75% opacity
│   └── sheldon/plugins.toml
├── .local/
│   ├── bin/                # User binaries (kitty, frogmouth, zed, ...)
│   ├── share/fonts/        # Nerd Fonts
│   ├── go/                 # Go toolchain
│   └── kitty.app/          # Kitty installation
├── .powerlevel10k/         # p10k theme
├── .cargo/bin/             # Rust toolchain + cargo tools
├── Silmarillion/
│   ├── install.sh          # This installer
│   └── README.md           # This file
└── go/bin/                 # Go binaries (fzf, direnv, lazygit)
```

## Post-install

Open a **new terminal** — you'll get a pre-configured p10k prompt immediately.
Customize anytime with `p10k configure`.

## Customizing

- **Font:** Edit `~/.config/kitty/kitty.conf`
- **Plugins:** Edit `~/.config/sheldon/plugins.toml` then run `sheldon lock`
- **Aliases:** Edit `~/.zshrc` (shared with bash via `~/.bashrc`)

## Uninstall

Delete what the installer created:

```bash
rm -rf ~/.local/kitty.app ~/.local/venvs/frogmouth ~/.local/share/fonts/*
rm -rf ~/.cargo ~/.rustup ~/go ~/.local/go
rm -rf ~/.local/share/sheldon ~/.local/share/atuin
# Configs (backup first if you customized them)
rm ~/.zshrc ~/.bashrc ~/.config/kitty/kitty.conf ~/.config/sheldon/plugins.toml
```

## License

MIT — same as powerlevel10k and the individual tools included.
