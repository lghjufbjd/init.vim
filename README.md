# Backup
mv ~/.config/nvim{,.bak}

## optional backups
mv ~/.local/share/nvim{,.bak}
mv ~/.local/state/nvim{,.bak}
mv ~/.cache/nvim{,.bak}

# Installation
git clone https://github.com/lghjufbjd/init.vim.git ~/.config/nvim

# Optional
rm -rf ~/.config/nvim/.git
git init
