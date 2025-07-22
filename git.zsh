# =====================
# Git Aliases
# =====================
alias ga="git add"
alias gb="git branch"
alias gba="git branch -av"
alias gcmm="git commit -m"
alias gd="git diff --ws-error-highlight=all"
alias gdc="git diff --cached"
alias ghf="git log --follow -p --"
alias gll="git log | less"
alias grsh="git reset --soft HEAD^ && git reset --hard HEAD"
alias gsrh="git submodule foreach --recursive git reset --hard"
alias gsur="git submodule update --init --recursive"
alias gqu="git-quick-update"

# =====================
# Submodule Utilities
# =====================
# Pull all submodules to latest master
git-submodule-latest() {
  git submodule foreach git pull origin master
}

# Reset and clean repo and submodules
git-reset-recurse-submodules() {
  git reset --hard
  git submodule sync --recursive
  git submodule update --init --force --recursive
  git clean -ffdx
  git submodule foreach --recursive git clean -ffdx
}

# =====================
# Prune Utilities
# =====================
# Remove deleted files from git cache
git-prune-cache() {
  FILES=$(git ls-files -d)
  if [[ -n $FILES ]]; then
    git rm $FILES
  else
    echo "No deleted files"
  fi
}

# Remove git submodule
git-prune-submodule() {
  local SUBMODULE=$1
  if [[ -z $SUBMODULE ]]; then
    echo "Usage: git-prune-submodule <submodule_path>" >&2
    return 1
  fi
  git submodule deinit -f -- "$SUBMODULE"
  rm -rf .git/modules/$SUBMODULE
  git rm -f $SUBMODULE
}

# =====================
# Quick Update Utility
# =====================
# Commit and push all modified files with a generated message
git-quick-update() {
  local modified_files commit_message
  modified_files=$(git diff --name-only && git diff --cached --name-only | sort -u)
  if [ -z "$modified_files" ]; then
    echo "No modified files to commit."
    return 1
  fi
  commit_message="Update:"
  for file in $modified_files; do
    commit_message="$commit_message \"$file\""
  done
  commit_message="$commit_message [skip ci]"

  # Stage the modified files
  git add -u
  if git commit -m "$commit_message" && git push; then
    echo "Changes committed and pushed successfully."
  else
    echo "Failed to commit and push changes."
    return 1
  fi
}

# =====================
# Branch Prune Utility
# =====================
# Remove a branch locally and remotely
git-prune-branch() {
  if [ $# -eq 0 ]; then
    echo "Usage: git-prune-branch <branch_name>" >&2
    echo "Removes specified branch locally and from origin remote"
    return 1
  fi
  local branch="$1"
  local current_branch=$(git symbolic-ref --short HEAD 2>/dev/null)
  if [ "$current_branch" = "$branch" ]; then
    echo -e "\033[1;31mError: Cannot delete current branch ($branch)\033[0m"
    echo "Switch to another branch first."
    return 1
  fi
  echo -e "\033[1;33mRemoving branch: $branch\033[0m"
  if git branch -D "$branch" >/dev/null 2>&1; then
    echo -e "\033[1;32mLocal branch removed\033[0m"
  else
    echo -e "\033[1;31mLocal branch removal failed (maybe already gone?)\033[0m"
  fi
  if git push origin --delete "$branch" >/dev/null 2>&1; then
    echo -e "\033[1;32mRemote branch removed from origin\033[0m"
  else
    echo -e "\033[1;31mRemote branch removal failed (maybe it didn't exist?)\033[0m"
  fi
  git fetch --prune --quiet >/dev/null 2>&1
}
