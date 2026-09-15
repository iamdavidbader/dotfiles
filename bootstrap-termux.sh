#!/usr/bin/env bash
# Bootstrap script for Termux — checks out the bare-repo dotfiles
# on the "termux" branch and installs the extra CLI tools via pkg.
#
# Usage: curl -fsSL <raw-url-to-this-file> | bash
# or:    ./bootstrap.sh
#
# Notes vs. the WSL script:
#   - No sudo in Termux; pkg installs as your own user.
#   - $HOME is /data/data/com.termux/files/home, not /home/<user>.
#   - Storage access (~/storage/*) needs `termux-setup-storage` separately
#     if your dotfiles reference shared/Android storage paths.

set -euo pipefail

REPO_URL="https://github.com/iamdavidbader/dotfiles.git"
DOTFILES_DIR="$HOME/.cfg"
BRANCH="linux"
BACKUP_DIR="$HOME/.config-backup/$(date +%Y%m%d-%H%M%S)"

config() {
  git --git-dir="$DOTFILES_DIR" --work-tree="$HOME" "$@"
}

echo "==> Updating package lists"
pkg update -y

echo "==> Ensuring git is present"
command -v git >/dev/null 2>&1 || pkg install -y git

echo "==> Cloning bare dotfiles repo (branch: $BRANCH)"
if [ ! -d "$DOTFILES_DIR" ]; then
  git clone --bare -b "$BRANCH" "$REPO_URL" "$DOTFILES_DIR"
else
  echo "    $DOTFILES_DIR already exists, skipping clone"
fi

config config --local status.showUntrackedFiles no
config config --local include.path ../.dotfiles_gitconfig

echo "==> Backing up any files that would be overwritten"
mkdir -p "$BACKUP_DIR"
moved=0
while IFS= read -r file; do
  target="$HOME/$file"
  if [ -e "$target" ] && [ ! -L "$target" ]; then
    mkdir -p "$BACKUP_DIR/$(dirname "$file")"
    mv "$target" "$BACKUP_DIR/$file"
    moved=$((moved + 1))
  fi
done < <(config ls-tree -r --name-only "$BRANCH")

if [ "$moved" -gt 0 ]; then
  echo "    Moved $moved conflicting file(s) to $BACKUP_DIR"
else
  echo "    Nothing to back up"
  rmdir "$BACKUP_DIR" 2>/dev/null || true
fi

echo "==> Checking out dotfiles"
config checkout "$BRANCH"
config submodule update --init --recursive 2>/dev/null || true

echo "==> Installing CLI tools"

# fzf + fzf-git.sh (fzf is packaged directly in Termux)
pkg install -y fzf
mkdir -p "$HOME/.fzf/bin"
curl -fsSL https://raw.githubusercontent.com/junegunn/fzf-git.sh/main/fzf-git.sh \
  -o "$HOME/.fzf/bin/fzf-git.sh"

# ripgrep, bat, delta are all packaged in Termux
pkg install -y ripgrep bat git-delta vim

command -v python >/dev/null 2>&1 || pkg install -y python
command -v pip >/dev/null 2>&1 || pkg install -y python-pip

pkg install -y tar xz-utils
mkdir -p "$HOME/.termux"
echo "==> Installing Termux-NF and Hack Nerd Font"
curl -fsSL https://raw.githubusercontent.com/arnavgr/termux-nf/main/install.sh | bash -s -- --silent
getnf -i "Hack"

echo "==> Done. Restart your shell (or run 'exec \$SHELL') to pick up the new config."
