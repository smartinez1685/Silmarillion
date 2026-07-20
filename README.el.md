# Silmarillion Stack

> Ένα σενάριο για να τα κυβερνήσει όλα — ένα περιβάλλον τερματικού με Rust/Go, χωρίς root και αυτόνομο.

[🇬🇧 English](README.md) · [🇪🇸 Español](README.es.md) · [🇩🇪 Deutsch](README.de.md) · [🇮🇹 Italiano](README.it.md) · [🇸🇪 Svenska](README.sv.md) · [🇷🇺 Русский](README.ru.md) · [🇵🇹 Português](README.pt.md)

---

## Τι περιλαμβάνει η στοίβα

| Επίπεδο | Εργαλείο | Γλώσσα | Εγκατάσταση |
|---------|----------|--------|-------------|
| Τερματικό | **kitty** | C/Python | εγκατάσταση χωρίς root |
| Shell | **ZSH** | C | σύστημα |
| Prompt | **powerlevel10k** | ZSH | git clone |
| Διαχειριστής προσθηκών | **sheldon** | Rust | cargo |
| Επισήμανση σύνταξης | **fast-syntax-highlighting** | ZSH | sheldon |
| Αυτοπροτάσεις | **zsh-autosuggestions** | ZSH | sheldon |
| Αναζήτηση ιστορικού | **zsh-history-substring-search** | ZSH | sheldon |
| Ιστορικό | **atuin** | Rust | curl script |
| Πλοήγηση | **zoxide** | Rust | cargo |
| `ls` | **eza** | Rust | cargo |
| `find` | **fd** | Rust | cargo |
| Ασαφής αναζήτηση | **fzf** | Go | go install |
| Εναλλάκτης περιβάλλοντος | **direnv** | Go | go install |
| Διαχειριστής Node | **fnm** | Rust | cargo |
| Git TUI | **lazygit** | Go | go install |
| Παρακολούθηση συστήματος | **bottom** | Rust | cargo |
| Προβολή Markdown | **frogmouth** | Python | pip (venv) |
| Επεξεργαστής (GUI) | **zed** | Rust | curl script |
| Nerd Fonts | **60+ οικογένειες** | — | GitHub releases |

## Γρήγορη εγκατάσταση

```bash
curl -fsSL https://raw.githubusercontent.com/smartinez1685/Silmarillion/master/install.sh | bash
```

Ή κλωνοποιήστε και εκτελέστε τοπικά:

```bash
git clone https://github.com/smartinez1685/Silmarillion.git ~/Silmarillion
cd ~/Silmarillion && bash install.sh
```

Το πρόγραμμα εγκατάστασης είναι **αδρανοδύναμο (idempotent)** — μπορείτε να το εκτελέσετε πολλές φορές με ασφάλεια.

## Τι κάνει το πρόγραμμα εγκατάστασης

1. Εγκαθιστά το Rust toolchain μέσω rustup (αν λείπει)
2. Εγκαθιστά το Go τοπικά στο `~/.local/go` (αν λείπει)
3. Εγκαθιστά πακέτα cargo: sheldon, eza, zoxide, fd-find, bottom, fnm
4. Εγκαθιστά Go δυαδικά: fzf, direnv, lazygit
5. Εγκαθιστά atuin μέσω επίσημου curl script
6. Εγκαθιστά kitty μέσω επίσημου installer χωρίς root
7. Εγκαθιστά frogmouth μέσω pip σε εικονικό περιβάλλον στο `~/.local/venvs/frogmouth`
8. Εγκαθιστά zed μέσω επίσημου curl script
9. Κατεβάζει UbuntuMono Nerd Font στο `~/.local/share/fonts/` (προαιρετικά όλες τις 60+ οικογένειες)
10. Αναπτύσσει αρχεία διαμόρφωσης: `.zshrc`, `.bashrc`, `.profile`, `.p10k.zsh`, kitty.conf, plugins.toml
11. Εκτελεί `sheldon lock` για κλωνοποίηση προσθηκών ZSH
12. Εκτελεί `fc-cache -fv` για εγγραφή γραμματοσειρών

## Χωρίς ανάγκη root

Τα πάντα εγκαθίστανται στο `~/.local/`, `~/.cargo/`, `~/.go/` και `~/.config/`. Δεν χρειάζεται `sudo`.

## Δομή καταλόγων

```
~/
├── .zshrc                  # Κύρια ρύθμιση ZSH (p10k + όλα τα εργαλεία)
├── .bashrc                 # Ρύθμιση Bash (ίδιες εντολές)
├── .profile                # Αυτόματη εκκίνηση zsh κατά την είσοδο
├── .p10k.zsh               # Προ-ρυθμισμένο prompt p10k
├── .config/
│   ├── kitty/kitty.conf    # Τερματικό: UbuntuMono Nerd Font, 15pt, 75% αδιαφάνεια
│   └── sheldon/plugins.toml
├── .local/
│   ├── bin/                # Δυαδικά χρήστη (kitty, frogmouth, zed, ...)
│   ├── share/fonts/        # Nerd Fonts
│   ├── go/                 # Go toolchain
│   └── kitty.app/          # Εγκατάσταση Kitty
├── .powerlevel10k/         # Θέμα p10k
├── .cargo/bin/             # Rust toolchain + εργαλεία cargo
├── Silmarillion/
│   ├── install.sh          # Αυτό το πρόγραμμα εγκατάστασης
│   └── README.md           # Αυτό το αρχείο
└── go/bin/                 # Δυαδικά Go (fzf, direnv, lazygit)
```

## Μετά την εγκατάσταση

Ανοίξτε ένα **νέο τερματικό** — θα έχετε άμεσα ένα προ-ρυθμισμένο p10k prompt.
Προσαρμόστε το οποτεδήποτε με `p10k configure`.

## Προσαρμογή

- **Γραμματοσειρά:** Επεξεργαστείτε το `~/.config/kitty/kitty.conf`
- **Προσθήκες:** Επεξεργαστείτε το `~/.config/sheldon/plugins.toml` και εκτελέστε `sheldon lock`
- **Εντολές:** Επεξεργαστείτε το `~/.zshrc` (κοινόχρηστο με bash μέσω `~/.bashrc`)

## Απεγκατάσταση

Διαγράψτε όσα δημιούργησε το πρόγραμμα εγκατάστασης:

```bash
rm -rf ~/.local/kitty.app ~/.local/venvs/frogmouth ~/.local/share/fonts/*
rm -rf ~/.cargo ~/.rustup ~/go ~/.local/go
rm -rf ~/.local/share/sheldon ~/.local/share/atuin
# Αρχεία ρυθμίσεων (δημιουργήστε αντίγραφο ασφαλείας αν τα έχετε προσαρμόσει)
rm ~/.zshrc ~/.bashrc ~/.config/kitty/kitty.conf ~/.config/sheldon/plugins.toml
```

## Άδεια

MIT — ίδια με το powerlevel10k και τα επιμέρους εργαλεία που περιλαμβάνονται.
