# Silmarillion Stack

> Один скрипт, чтобы править всеми — терминальное окружение на Rust/Go, не требующее прав root.

[🇬🇧 English](README.md) · [🇪🇸 Español](README.es.md) · [🇩🇪 Deutsch](README.de.md) · [🇮🇹 Italiano](README.it.md) · [🇸🇪 Svenska](README.sv.md) · [🇵🇹 Português](README.pt.md) · [🇬🇷 Ελληνικά](README.el.md)

---

## Компоненты стека

| Уровень | Инструмент | Язык | Установка |
|---------|------------|------|-----------|
| Терминал | **kitty** | C/Python | установщик без root |
| Оболочка | **ZSH** | C | системный |
| Приглашение | **powerlevel10k** | ZSH | git clone (в комплекте) |
| Менеджер плагинов | **sheldon** | Rust | cargo |
| Подсветка синтаксиса | **fast-syntax-highlighting** | ZSH | sheldon |
| Автодополнение | **zsh-autosuggestions** | ZSH | sheldon |
| Поиск по истории | **zsh-history-substring-search** | ZSH | sheldon |
| История | **atuin** | Rust | curl-скрипт |
| Навигация | **zoxide** | Rust | cargo |
| `ls` | **eza** | Rust | cargo |
| `find` | **fd** | Rust | cargo |
| Нечёткий поиск | **fzf** | Go | go install |
| Переключатель окружений | **direnv** | Go | go install |
| Менеджер Node | **fnm** | Rust | cargo |
| Git TUI | **lazygit** | Go | go install |
| Монитор системы | **bottom** | Rust | cargo |
| Просмотрщик Markdown | **frogmouth** | Python | pip (venv) |
| Редактор (GUI) | **zed** | Rust | curl-скрипт |
| Nerd Fonts | **60+ семейств** | — | GitHub релизы |

## Быстрая установка

```bash
curl -fsSL https://raw.githubusercontent.com/smartinez1685/Silmarillion/main/install.sh | bash
```

Или клонировать и запустить локально:

```bash
git clone https://github.com/smartinez1685/Silmarillion.git ~/Silmarillion
cd ~/Silmarillion && bash install.sh
```

Установщик **идемпотентен** — его можно запускать многократно.

## Что делает установщик

1. Устанавливает Rust Toolchain через rustup (если отсутствует)
2. Устанавливает Go локально в `~/.local/go` (если отсутствует)
3. Устанавливает пакеты cargo: sheldon, eza, zoxide, fd-find, bottom, fnm
4. Устанавливает Go-бинарники: fzf, direnv, lazygit
5. Устанавливает atuin через официальный curl-скрипт
6. Устанавливает kitty через официальный установщик без root
7. Устанавливает frogmouth через pip в виртуальном окружении в `~/.local/venvs/frogmouth`
8. Устанавливает zed через официальный curl-скрипт
9. Загружает более 60 семейств Nerd Fonts в `~/.local/share/fonts/`
10. Развёртывает конфиги: `.zshrc`, `.bashrc`, `.profile`, kitty.conf, plugins.toml для sheldon
11. Запускает `sheldon lock` для клонирования ZSH-плагинов
12. Запускает `fc-cache -fv` для регистрации шрифтов

## Root не требуется

Всё устанавливается в `~/.local/`, `~/.cargo/`, `~/.go/` и `~/.config/`. `sudo` не нужен.

## Структура директорий

```
~/
├── .zshrc                  # Основная конфигурация ZSH (p10k + все инструменты)
├── .bashrc                 # Конфигурация Bash (те же алиасы)
├── .profile                # Автоматический запуск zsh при входе
├── .config/
│   ├── kitty/kitty.conf    # Терминал: UbuntuMono Nerd Font, 15pt, 75% прозрачности
│   └── sheldon/plugins.toml
├── .local/
│   ├── bin/                # Пользовательские бинарники (kitty, frogmouth, zed, ...)
│   ├── share/fonts/        # 60+ семейств Nerd Font
│   ├── go/                 # Go Toolchain
│   └── kitty.app/          # Установка Kitty
├── .cargo/bin/             # Rust Toolchain + cargo-инструменты
├── Silmarillion/
│   ├── powerlevel10k/      # Тема p10k
│   ├── install.sh          # Этот установщик
│   └── README.md           # Этот файл
└── go/bin/                 # Go-бинарники (fzf, direnv, lazygit)
```

## После установки

Откройте **новый терминал** — p10k запустит мастер настройки при первом запуске. Выберите:

- **Nerd Font v3** + powerline
- **Classic** style
- **Unicode** icons
- **Darkest** colors
- **2-line** prompt
- **Round** separators

Повторный запуск в любое время: `p10k configure`.

## Настройка

- **Шрифт:** Отредактируйте `~/.config/kitty/kitty.conf`
- **Плагины:** Отредактируйте `~/.config/sheldon/plugins.toml`, затем выполните `sheldon lock`
- **Алиасы:** Отредактируйте `~/.zshrc` (общие с bash через `~/.bashrc`)

## Удаление

Удалите то, что создал установщик:

```bash
rm -rf ~/.local/kitty.app ~/.local/venvs/frogmouth ~/.local/share/fonts/*
rm -rf ~/.cargo ~/.rustup ~/go ~/.local/go
rm -rf ~/.local/share/sheldon ~/.local/share/atuin
# Конфиги (сделайте резервную копию, если вы их изменяли)
rm ~/.zshrc ~/.bashrc ~/.config/kitty/kitty.conf ~/.config/sheldon/plugins.toml
```

## Лицензия

MIT — как и powerlevel10k, а также отдельные включённые инструменты.
