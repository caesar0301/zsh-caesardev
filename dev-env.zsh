# =============================
# Development Environment Setup
# =============================

# --- PATH Utility ---
# Add to PATH if directory exists and not already present
_prepend_to_path() {
  local dir=$1
  if [ -d "$dir" ] && [[ ":$PATH:" != *":$dir:"* ]]; then
    export PATH="$dir:$PATH"
  fi
}

# --- Python Environment ---
# Initialize pyenv if available
_init_pyenv() {
  if [ -d "$HOME/.pyenv" ]; then
    export PYENV_ROOT="$HOME/.pyenv"
    _prepend_to_path "$PYENV_ROOT/bin"
    if command -v pyenv &>/dev/null; then
      eval "$(pyenv init -)"
    fi
  fi
}
_init_pyenv

# --- Go Environment (Disabled) ---
_init_go_env() {
  if command -v go &>/dev/null; then
    export GOROOT=$(go env GOROOT)
    export GOPATH=$(go env GOPATH)
    export GO111MODULE=on
    export GOPROXY=https://goproxy.cn,direct
    export PATH=$GOPATH/bin:$GOROOT/bin:$PATH
  fi
}

# --- Java Environment (Disabled) ---
_init_jenv() {
  if [ -d "$HOME/.jenv" ]; then
    _prepend_to_path "$HOME/.jenv/bin"
    if command -v jenv &>/dev/null; then
      eval "$(jenv init -)"
    fi
  fi
}

# --- Haskell Environment (Disabled) ---
_init_haskell_env() {
  if [ -d "$HOME/.ghcup" ]; then
    _prepend_to_path "$HOME/.ghcup/bin"
  fi
  if [ -d "$HOME/.cabal" ]; then
    _prepend_to_path "$HOME/.cabal/bin"
  fi
}

# --- Lisp Environment ---
# Initialize Lisp/Quicklisp/Roswell/Allegro CL if available
_init_lisp_env() {
  # Roswell
  if [ -d "$HOME/.roswell" ]; then
    _prepend_to_path "$HOME/.roswell/bin"
  fi

  # Quicklisp home
  export QUICKLISP_HOME=${HOME}/quicklisp

  # Allegro CL
  local ACL_HOME=${HOME}/.local/share/acl
  if [ -d "$ACL_HOME" ]; then
    _prepend_to_path "$ACL_HOME"
  fi

  # rlwrap for better REPL experience
  if command -v rlwrap &>/dev/null; then
    alias sbcl="rlwrap -f $HOME/.config/rlwrap/lisp_completions --remember sbcl"
    alias alisp="rlwrap -f $HOME/.config/rlwrap/lisp_completions --remember alisp"
    alias mlisp="rlwrap -f $HOME/.config/rlwrap/lisp_completions --remember mlisp"
  fi
}

# --- node Environment ---
# Initialize nvm if available
_init_node_env() {
  if [ -d "$HOME/.nvm" ]; then
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
  fi
}
