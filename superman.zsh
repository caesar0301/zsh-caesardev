#!/usr/bin/env zsh

# Superman utilities for zsh-caesardev

# Simple output functions
_superman_print_info() {
  echo "$1"
}

_superman_print_warning() {
  echo "$1"
}

_superman_print_error() {
  echo "$1" >&2
}

# Internal decrypt function (converted from decrypt-zshenv-dotme script)
function _superman_decrypt_file() {
  local alias_name="${1:-default}"
  local encrypted_file="${2:-}"
  local target_file="${3:-}"
  local gpg_tool="gpg-dotme"

  # Show help if requested
  if [[ "$alias_name" == "help" || "$alias_name" == "-h" || "$alias_name" == "--help" ]]; then
    echo "Superman Decrypt Function"
    echo ""
    echo "Usage: _superman_decrypt_file [alias] [encrypted_file] [target_file]"
    echo ""
    echo "Parameters:"
    echo "  alias: GPG alias to use (default: 'default')"
    echo "  encrypted_file: Path to encrypted file"
    echo "  target_file: Path to output decrypted file"
    echo ""
    echo "Examples:"
    echo "  _superman_decrypt_file default /path/to/file.enc /path/to/output"
    echo "  _superman_decrypt_file my-alias /path/to/file.enc /path/to/output"
    return 0
  fi

  # Check if encrypted file exists
  if [[ ! -f "$encrypted_file" ]]; then
    _superman_print_error "Encrypted file '$encrypted_file' not found"
    return 1
  fi

  # Check if gpg tool exists and is executable
  if ! command -v "$gpg_tool" &>/dev/null; then
    _superman_print_error "$gpg_tool not found in PATH"
    return 1
  fi

  # Create backup of existing target file if it exists
  if [[ -f "$target_file" ]]; then
    local backup_file="${target_file:h}/.zshenv.local.bak"
    cp "$target_file" "$backup_file"
  fi

  # Decrypt the file using gpg tool
  if "$gpg_tool" dec "$alias_name" "$encrypted_file" >"$target_file"; then
    return 0
  else
    _superman_print_error "Failed to decrypt $encrypted_file"
    return 1
  fi
}

# Function to decrypt and source local .zshenv.local.env
# This function will:
# 1. Find the encrypted file relative to the script location
# 2. Decrypt the .zshenv.local.enc file
# 3. Source it into the current shell
function _superman_decrypt_and_source_local_env() {
  local script_dir="${0:h}"
  local encrypted_file="$script_dir/.zshenv.local.enc"
  local decrypted_file="$HOME/.zshenv.local"

  # Check if encrypted file exists
  if [[ ! -f "$encrypted_file" ]]; then
    _superman_print_error "Encrypted file not found at $encrypted_file"
    return 1
  fi

  # Decrypt the file using internal function
  if ! _superman_decrypt_file "drjaminchen" "$encrypted_file" "$decrypted_file"; then
    _superman_print_error "Failed to decrypt .zshenv.local.enc"
    return 1
  fi

  # Check if decrypted file was created
  if [[ ! -f "$decrypted_file" ]]; then
    _superman_print_error "Decrypted file not found at $decrypted_file"
    return 1
  fi

  # Source the decrypted file
  if source "$decrypted_file"; then
    return 0
  else
    _superman_print_error "Failed to source .zshenv.local"
    return 1
  fi
}
_superman_decrypt_and_source_local_env
