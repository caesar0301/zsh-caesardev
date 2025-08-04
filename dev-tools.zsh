# =====================
# Development Utilities
# =====================

# --- Maven Utilities ---
# Quick start a Maven project with template
maven-quickstart() {
  if ! command -v mvn >/dev/null 2>&1; then
    echo "[maven-quickstart] Error: mvn not found in PATH" >&2
    return 1
  fi
  mvn archetype:generate -DarchetypeGroupId=org.apache.maven.archetypes \
    -DarchetypeArtifactId=maven-archetype-quickstart \
    -DarchetypeVersion=1.4 "$@"
}

# --- Local HTTP Server ---
# Quick start a local HTTP server with Python
local-http-server() {
  if ! command -v python >/dev/null 2>&1; then
    echo "[local-http-server] Error: python not found in PATH" >&2
    return 1
  fi
  PYV=$(python -c "import sys; print(sys.version_info[0])" 2>/dev/null)
  if [ "$PYV" = "3" ]; then
    python -m http.server 8899
  else
    python -m SimpleHTTPServer 8899
  fi
}

# --- File Utilities ---
# Open file window (cross-platform)
openw() {
  local KNAME KREL EXE
  KNAME=$(uname -s)
  KREL=$(uname -r)
  EXE='nautilus'
  if [[ $KNAME == "Linux" ]]; then
    if [[ $KREL =~ "microsoft-standard" ]]; then
      EXE='explorer.exe'
    fi
  elif [[ $KNAME == "Darwin" ]]; then
    EXE='open'
  fi
  if ! command -v "$EXE" >/dev/null 2>&1; then
    echo "[openw] Error: $EXE not found in PATH" >&2
    return 1
  fi
  "$EXE" "$@"
}

# Grep and replace in files
# Usage: greprp [spath] oldstr newstr
# If spath omitted, defaults to '.'
greprp() {
  if ! command -v grep >/dev/null 2>&1 || ! command -v awk >/dev/null 2>&1 || ! command -v sed >/dev/null 2>&1; then
    echo "[greprp] Error: grep, awk, or sed not found in PATH" >&2
    return 1
  fi
  if [ $# -lt 2 ] || [ $# -gt 3 ]; then
    echo "[greprp] Usage: greprp [spath] oldstr newstr" >&2
    return 1
  fi
  local spath oldstr newstr
  if [ $# -eq 2 ]; then
    spath='.'
    oldstr=$1
    newstr=$2
  else
    spath=$1
    oldstr=$2
    newstr=$3
  fi
  grep -rl -- "$oldstr" "$spath" | while IFS= read -r file; do
    sed -i -E "s|$oldstr|$newstr|g" "$file"
  done
}

# --- Docker Utilities ---
# Reset Colima environment (dangerous: removes all data)
colima-reset-all() {
  rm -rf ~/.colima ~/.lima ~/.docker
}
