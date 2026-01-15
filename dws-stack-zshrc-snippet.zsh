# Dicklesworthstone stack updater
# Point this to wherever you save dicklesworthstone-stack.sh
export DWS_STACK_SCRIPT="$HOME/Developer/Scripts/dicklesworthstone/dicklesworthstone-stack.sh"

# One command to update everything
dws-update() {
  if [ -x "$DWS_STACK_SCRIPT" ]; then
    "$DWS_STACK_SCRIPT" update
  else
    echo "dws-update: not found or not executable: $DWS_STACK_SCRIPT" >&2
    return 1
  fi
}

# Optional short alias
alias dwsu='dws-update'
