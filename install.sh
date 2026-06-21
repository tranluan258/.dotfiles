#!/usr/bin/env bash
#
# Symlink dotfiles from this repo into your home directory.
# After running, editing a file in this repo updates your live config instantly
# (and vice-versa), because the live paths are symlinks pointing back here.
#
# Existing real files/dirs are backed up to "<name>.backup-<timestamp>" before linking.
# Re-running is safe (idempotent): correct symlinks are left untouched.

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
STAMP="$(date +%Y%m%d-%H%M%S)"

# map: <path in repo>  ->  <target path in home>
link() {
  local src="$REPO_DIR/$1"
  local dst="$2"

  if [[ ! -e "$src" ]]; then
    echo "skip   $1 (not in repo)"
    return
  fi

  # already correctly linked?
  if [[ -L "$dst" && "$(readlink "$dst")" == "$src" ]]; then
    echo "ok     $dst -> $src"
    return
  fi

  mkdir -p "$(dirname "$dst")"

  # back up an existing real file/dir (or wrong symlink)
  if [[ -e "$dst" || -L "$dst" ]]; then
    mv "$dst" "$dst.backup-$STAMP"
    echo "backup $dst -> $dst.backup-$STAMP"
  fi

  ln -s "$src" "$dst"
  echo "link   $dst -> $src"
}

link ".config/nvim" "$HOME/.config/nvim"
link ".tmux.conf"   "$HOME/.tmux.conf"
link ".zshrc"       "$HOME/.zshrc"
link ".ideavimrc"   "$HOME/.ideavimrc"

echo
echo "Done. Reload your shell:  exec zsh"
echo "Reload tmux config:       tmux source-file ~/.tmux.conf"
