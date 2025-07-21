#!/usr/bin/bash
# shellcheck disable=SC1090,SC2154

# Caesardev Zsh Plugin Loader
# Loads all utility scripts for the development environment
# Ensures all required files are sourced, with error checks

# Handle $0 according to the Zsh Plugin Standard:
# https://zdharma-continuum.github.io/Zsh-100-Commits-Club/Zsh-Plugin-Standard.html
0="${${ZERO:-${0:#$ZSH_ARGZERO}}:-${(%):-%N}}"
0="${${(M)0:#/*}:-$PWD/$0}"

for f in alias.zsh dev_env.zsh git.zsh superman.zsh dev_tools.zsh; do
  if [ -f "${0:h}/$f" ]; then
    source "${0:h}/$f"
  else
    echo "[caesardev.plugin.zsh] Warning: ${0:h}/$f not found, skipping." >&2
  fi

done