#!/usr/bin/bash
# shellcheck disable=SC1090,SC2154

# Caesardev Zsh Plugin
# Development environment configuration

# Handle $0 according to the Zsh Plugin Standard:
# https://zdharma-continuum.github.io/Zsh-100-Commits-Club/Zsh-Plugin-Standard.html
0="${${ZERO:-${0:#$ZSH_ARGZERO}}:-${(%):-%N}}"
0="${${(M)0:#/*}:-$PWD/$0}"

# =====================
# Environment Variables
# =====================
# Set non-default Git remote for Homebrew/homebrew-core.
export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.ustc.edu.cn/homebrew-core.git"
export HOMEBREW_NO_AUTO_UPDATE=1
export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.ustc.edu.cn/homebrew-bottles"

export PATH=$HOME/.npm-global/bin:$PATH
export PATH=$HOME/go/bin:$PATH
export PATH="/usr/local/bin:$PATH"
export RLWRAP_HOME=${HOME}/.config/rlwrap

# =====================
# Editor Aliases
# =====================
export EDITOR=nvim
alias vi=nvim
alias em='emacs -nw'

# =====================
# File/Directory Listing
# =====================
alias ll='ls -alF'

# =====================
# Kubernetes
# =====================
alias k="kubectl"

# =====================
# Disk Usage/Stats
# =====================
# Human-readable disk usage for dotfiles
duh() { du -hs .[^.]*; }
alias duh=duh

# =====================
# Rsync (preserve symlinks, timestamps, permissions)
# =====================
alias rsync2="rsync -rlptgoD --progress"

# =====================
# Search (ag, perf, dict)
# =====================
# Enable search hidden files by default
alias ag='ag -u'
# Show memory usage sorted by %mem
alias psmem="ps -o pid,user,%mem,command ax | sort -b -k3 -r"
# StarDict console (install dicts into ~/.local/share/stardict/dic or /usr/share/stardict/dic)
alias dict="sdcv -0 -c"
# Ag searching for CMake/Bazel
alias ag_cmake='ag --ignore-dir="build" -G "(ODPSBuild.txt|CMakeLists.txt|.\\.cmake)"'
alias ag_bazel='ag --ignore-dir="build" -G "(BUILD|.\\.bazel)"'

_superman_print_error() {
  echo "$1" >&2
}

# Decrypt and source local .zshenv.local.env
_superman_decrypt_and_source_local_env() {
  local script_dir="${${(%):-%x}:h}"
  local encrypted_file="$script_dir/.zshenv.local.enc"
  local decrypted_file="$HOME/.zshenv.local"

  if [[ ! -f "$encrypted_file" ]]; then
    _superman_print_error "Encrypted file not found at $encrypted_file"
    return 1
  fi

  if ! superman_decrypt_file "drjaminchen" "$encrypted_file" "$decrypted_file"; then
    _superman_print_error "Failed to decrypt .zshenv.local.enc"
    return 1
  fi

  if [[ ! -f "$decrypted_file" ]]; then
    _superman_print_error "Decrypted file not found at $decrypted_file"
    return 1
  fi

  if ! source "$decrypted_file"; then
    _superman_print_error "Failed to source .zshenv.local"
    return 1
  fi
  return 0
}
