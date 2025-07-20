# Manage dev environments.

# Function to add to PATH if the directory exists
_prepend_to_path() {
  local dir=$1
  if [ -d "$dir" ]; then
    export PATH="$dir:$PATH"
  fi
}

# Function to initialize Go environment
_init_go_env() {
  if command -v go &>/dev/null; then
    export GOROOT=$(go env GOROOT)
    export GOPATH=$(go env GOPATH)
    export GO111MODULE=on
    export GOPROXY=https://goproxy.cn,direct
  fi
}

# Function to initialize pyenv environment
_init_pyenv() {
  if [ -d "$HOME/.pyenv" ]; then
    export PYENV_ROOT="$HOME/.pyenv"
    _prepend_to_path "$PYENV_ROOT/bin"
    eval "$(pyenv init -)"
  fi
}

# Function to initialize jenv environment
_init_jenv() {
  _prepend_to_path "$HOME/.jenv/bin"
  eval "$(jenv init -)"
  # jenv enable-plugin export > /dev/null
}

# Function to initialize Haskell environment
_init_haskell_env() {
  _prepend_to_path "$HOME/.ghcup/bin"
  _prepend_to_path "$HOME/.cabal/bin"
}

# Function to initialize Lisp environment
_init_lisp_env() {
  # Roswell
  _prepend_to_path "$HOME/.roswell/bin"
  # Customize quicklisp home
  export QUICKLISP_HOME=${HOME}/quicklisp
  # Allegro CL
  local ACL_HOME=${HOME}/.local/share/acl
  _prepend_to_path "$ACL_HOME"
  # Start with rlwrap
  alias sbcl="rlwrap -f $HOME/.config/rlwrap/lisp_completions --remember sbcl"
  alias alisp="rlwrap -f $HOME/.config/rlwrap/lisp_completions --remember alisp"
  alias mlisp="rlwrap -f $HOME/.config/rlwrap/lisp_completions --remember mlisp"
}

# Function to initialize all development environments
_init_pyenv
#_init_jenv
#_init_go_env
#_init_haskell_env
_init_lisp_env
