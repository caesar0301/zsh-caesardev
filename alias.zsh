# =====================
# Editor Aliases
# =====================
export EDITOR=vim
alias vi=vim
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
