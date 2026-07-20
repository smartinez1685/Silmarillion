# Silmarillion Stack

> Um script para governar todos — um ambiente de terminal turbinado com Rust/Go, sem root e autossuficiente.

[🇬🇧 English](README.md) · [🇪🇸 Español](README.es.md) · [🇩🇪 Deutsch](README.de.md) · [🇮🇹 Italiano](README.it.md) · [🇸🇪 Svenska](README.sv.md) · [🇷🇺 Русский](README.ru.md) · [🇬🇷 Ελληνικά](README.el.md)

---

## Componentes da stack

| Camada | Ferramenta | Linguagem | Instalação |
|--------|------------|-----------|------------|
| Terminal | **kitty** | C/Python | instalador sem root |
| Shell | **ZSH** | C | sistema |
| Prompt | **powerlevel10k** | ZSH | git clone (embutido) |
| Gerenciador de plugins | **sheldon** | Rust | cargo |
| Destaque de sintaxe | **fast-syntax-highlighting** | ZSH | sheldon |
| Autossugestões | **zsh-autosuggestions** | ZSH | sheldon |
| Pesquisa de histórico | **zsh-history-substring-search** | ZSH | sheldon |
| Histórico | **atuin** | Rust | script curl |
| Navegação | **zoxide** | Rust | cargo |
| `ls` | **eza** | Rust | cargo |
| `find` | **fd** | Rust | cargo |
| Buscador difuso | **fzf** | Go | go install |
| Gerenciador de ambiente | **direnv** | Go | go install |
| Gerenciador Node | **fnm** | Rust | cargo |
| TUI Git | **lazygit** | Go | go install |
| Monitor do sistema | **bottom** | Rust | cargo |
| Visualizador Markdown | **frogmouth** | Python | pip (venv) |
| Editor (GUI) | **zed** | Rust | script curl |
| Nerd Fonts | **60+ famílias** | — | GitHub releases |

## Instalação rápida

```bash
curl -fsSL https://raw.githubusercontent.com/smartinez1685/Silmarillion/master/install.sh | bash
```

Ou clone e execute localmente:

```bash
git clone https://github.com/smartinez1685/Silmarillion.git ~/Silmarillion
cd ~/Silmarillion && bash install.sh
```

O instalador é **idempotente** — pode executá-lo várias vezes sem problemas.

## O que o instalador faz

1. Instala o toolchain Rust via rustup (se ausente)
2. Instala Go localmente em `~/.local/go` (se ausente)
3. Instala pacotes cargo: sheldon, eza, zoxide, fd-find, bottom, fnm
4. Instala binários Go: fzf, direnv, lazygit
5. Instala atuin via script curl oficial
6. Instala kitty via instalador oficial sem root
7. Instala frogmouth via pip num ambiente virtual em `~/.local/venvs/frogmouth`
8. Instala zed via script curl oficial
9. Descarrega mais de 60 famílias Nerd Fonts para `~/.local/share/fonts/`
10. Implementa as configurações: `.zshrc`, `.bashrc`, `.profile`, kitty.conf, plugins.toml do sheldon
11. Executa `sheldon lock` para clonar os plugins ZSH
12. Executa `fc-cache -fv` para registar as fontes

## Sem necessidade de root

Tudo é instalado em `~/.local/`, `~/.cargo/`, `~/.go/` e `~/.config/`. Não é necessário `sudo`.

## Estrutura de diretórios

```
~/
├── .zshrc                  # Configuração ZSH principal (p10k + todas as ferramentas)
├── .bashrc                 # Configuração Bash (mesmos aliases)
├── .profile                # Inicia zsh automaticamente no login
├── .config/
│   ├── kitty/kitty.conf    # Terminal: UbuntuMono Nerd Font, 15pt, 75% opacidade
│   └── sheldon/plugins.toml
├── .local/
│   ├── bin/                # Binários do utilizador (kitty, frogmouth, zed, ...)
│   ├── share/fonts/        # 60+ famílias Nerd Font
│   ├── go/                 # Toolchain Go
│   └── kitty.app/          # Instalação Kitty
├── .cargo/bin/             # Toolchain Rust + ferramentas cargo
├── Silmarillion/
│   ├── powerlevel10k/      # Tema p10k
│   ├── install.sh          # Este instalador
│   └── README.md           # Este ficheiro
└── go/bin/                 # Binários Go (fzf, direnv, lazygit)
```

## Pós-instalação

Abra um **novo terminal** — o p10k iniciará o assistente de configuração na primeira execução. Escolha:

- **Nerd Font v3** + powerline
- **Classic** style
- **Unicode** icons
- **Darkest** colors
- **2-line** prompt
- **Round** separators

Reexecutável a qualquer momento com `p10k configure`.

## Personalização

- **Fonte:** Edite `~/.config/kitty/kitty.conf`
- **Plugins:** Edite `~/.config/sheldon/plugins.toml` e depois execute `sheldon lock`
- **Aliases:** Edite `~/.zshrc` (partilhado com bash via `~/.bashrc`)

## Desinstalação

Remova o que o instalador criou:

```bash
rm -rf ~/.local/kitty.app ~/.local/venvs/frogmouth ~/.local/share/fonts/*
rm -rf ~/.cargo ~/.rustup ~/go ~/.local/go
rm -rf ~/.local/share/sheldon ~/.local/share/atuin
# Configurações (faça backup se as personalizou)
rm ~/.zshrc ~/.bashrc ~/.config/kitty/kitty.conf ~/.config/sheldon/plugins.toml
```

## Licença

MIT — tal como o powerlevel10k e as ferramentas individuais incluídas.
