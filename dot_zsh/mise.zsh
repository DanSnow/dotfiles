# Configuration
MISE_CACHE_DIR="${XDG_CACHE_DIR:-$HOME/.cache}/zsh"
MISE_CACHE_FILE="$MISE_CACHE_DIR/mise.zsh"

# 1. Ensure the directory exists
[[ -d "$MISE_CACHE_DIR" ]] || mkdir -p "$MISE_CACHE_DIR"

if [[ -f "$MISE_CACHE_FILE" ]]; then
    # Case A: Cache exists (99% of the time)
    # 1. Source it deferred so prompt is instant
    zsh-defer source "$MISE_CACHE_FILE"
    
    # 2. Refresh in background for NEXT session
    (
        if (( $+commands[mise] )); then
            mise activate zsh > "$MISE_CACHE_FILE"
        fi
    ) &>/dev/null &!
else
    # Case B: First run or cache cleared
    # We MUST run this synchronously once so your tools work immediately
    if (( $+commands[mise] )); then
        mise activate zsh > "$MISE_CACHE_FILE"
        source "$MISE_CACHE_FILE"
    fi
fi
