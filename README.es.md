# Silmarillion Stack

> Un script para controlarlos a todos — un entorno de terminal potenciado por Rust/Go, sin root y autónomo.

[🇬🇧 English](README.md) · [🇩🇪 Deutsch](README.de.md) · [🇮🇹 Italiano](README.it.md) · [🇸🇪 Svenska](README.sv.md) · [🇷🇺 Русский](README.ru.md) · [🇵🇹 Português](README.pt.md) · [🇬🇷 Ελληνικά](README.el.md)

---

## Componentes del stack

| Capa | Herramienta | Lenguaje | Instalación |
|------|-------------|----------|-------------|
| Terminal | **kitty** | C/Python | instalador sin root |
| Shell | **ZSH** | C | sistema |
| Prompt | **powerlevel10k** | ZSH | git clone (incluido) |
| Gestor de plugins | **sheldon** | Rust | cargo |
| Resaltado de sintaxis | **fast-syntax-highlighting** | ZSH | sheldon |
| Autocompletado | **zsh-autosuggestions** | ZSH | sheldon |
| Búsqueda en historial | **zsh-history-substring-search** | ZSH | sheldon |
| Historial | **atuin** | Rust | script curl |
| Navegación | **zoxide** | Rust | cargo |
| `ls` | **eza** | Rust | cargo |
| `find` | **fd** | Rust | cargo |
| Buscador difuso | **fzf** | Go | go install |
| Gestor de entornos | **direnv** | Go | go install |
| Gestor de Node | **fnm** | Rust | cargo |
| TUI para Git | **lazygit** | Go | go install |
| Monitor del sistema | **bottom** | Rust | cargo |
| Visor de Markdown | **frogmouth** | Python | pip (venv) |
| Editor (GUI) | **zed** | Rust | script curl |
| Nerd Fonts | **60+ familias** | — | GitHub releases |

## Instalación rápida

```bash
curl -fsSL https://raw.githubusercontent.com/smartinez1685/Silmarillion/main/install.sh | bash
```

O clonar y ejecutar localmente:

```bash
git clone https://github.com/smartinez1685/Silmarillion.git ~/Silmarillion
cd ~/Silmarillion && bash install.sh
```

El instalador es **idempotente** — puedes ejecutarlo varias veces sin problemas.

## Qué hace el instalador

1. Instala el toolchain de Rust mediante rustup (si falta)
2. Instala Go localmente en `~/.local/go` (si falta)
3. Instala paquetes de cargo: sheldon, eza, zoxide, fd-find, bottom, fnm
4. Instala binarios de Go: fzf, direnv, lazygit
5. Instala atuin mediante el script oficial curl
6. Instala kitty mediante el instalador oficial sin root
7. Instala frogmouth mediante pip en un entorno virtual en `~/.local/venvs/frogmouth`
8. Instala zed mediante el script oficial curl
9. Descarga más de 60 familias de Nerd Fonts en `~/.local/share/fonts/`
10. Despliega las configuraciones: `.zshrc`, `.bashrc`, `.profile`, kitty.conf, plugins.toml de sheldon
11. Ejecuta `sheldon lock` para clonar los plugins de ZSH
12. Ejecuta `fc-cache -fv` para registrar las fuentes

## Sin necesidad de root

Todo se instala en `~/.local/`, `~/.cargo/`, `~/.go/` y `~/.config/`. No se necesita `sudo`.

## Estructura de directorios

```
~/
├── .zshrc                  # Configuración principal de ZSH (p10k + todas las herramientas)
├── .bashrc                 # Configuración de Bash (mismos alias de herramientas)
├── .profile                # Inicia zsh automáticamente al iniciar sesión
├── .config/
│   ├── kitty/kitty.conf    # Terminal: UbuntuMono Nerd Font, 15pt, 75% opacidad
│   └── sheldon/plugins.toml
├── .local/
│   ├── bin/                # Binarios del usuario (kitty, frogmouth, zed, ...)
│   ├── share/fonts/        # 60+ familias Nerd Font
│   ├── go/                 # Toolchain de Go
│   └── kitty.app/          # Instalación de Kitty
├── .cargo/bin/             # Toolchain de Rust + herramientas cargo
├── Silmarillion/
│   ├── powerlevel10k/      # Tema p10k
│   ├── install.sh          # Este instalador
│   └── README.md           # Este archivo
└── go/bin/                 # Binarios de Go (fzf, direnv, lazygit)
```

## Después de la instalación

Abre una **nueva terminal** — p10k iniciará su asistente de configuración en la primera ejecución. Elige:

- **Nerd Font v3** + powerline
- **Classic** style
- **Unicode** icons
- **Darkest** colors
- **2-line** prompt
- **Round** separators

Vuelve a ejecutarlo cuando quieras con `p10k configure`.

## Personalización

- **Fuente:** Edita `~/.config/kitty/kitty.conf`
- **Plugins:** Edita `~/.config/sheldon/plugins.toml` y luego ejecuta `sheldon lock`
- **Alias:** Edita `~/.zshrc` (compartido con bash mediante `~/.bashrc`)

## Desinstalación

Borra lo que el instalador creó:

```bash
rm -rf ~/.local/kitty.app ~/.local/venvs/frogmouth ~/.local/share/fonts/*
rm -rf ~/.cargo ~/.rustup ~/go ~/.local/go
rm -rf ~/.local/share/sheldon ~/.local/share/atuin
# Configuraciones (haz una copia de seguridad si las personalizaste)
rm ~/.zshrc ~/.bashrc ~/.config/kitty/kitty.conf ~/.config/sheldon/plugins.toml
```

## Licencia

MIT — igual que powerlevel10k y las herramientas individuales incluidas.
