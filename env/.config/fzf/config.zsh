[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# FZF appearance
export FZF_DEFAULT_OPTS=" \
--tmux 77% \
--ansi \
--border=rounded \
--prompt='▶ ' \
--pointer='>' \
--separator="─" \
--no-mouse \
--preview-window=hidden \
--cycle \
--layout=reverse"


export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS"\
" --color=bg+:#1f1d2e,bg:#191724,spinner:#9ccfd8,hl:#c4a7e7"\
" --color=fg:#908caa,header:#c4a7e7,info:#ebbcba,pointer:#9ccfd8"\
" --color=marker:#9ccfd8,fg+:#e0def4,prompt:#ebbcba,hl+:#c4a7e7,gutter:#191724"


# Use ~~ as the trigger sequence instead of the default **
export FZF_COMPLETION_TRIGGER='~~'
export FZF_COMPLETION_OPTS='--border --info=inline'
export FZF_COMPLETION_PATH_OPTS='--walker file,dir,follow,hidden'
export FZF_COMPLETION_DIR_OPTS='--walker dir,follow'
export FZF_DEFAULT_COMMAND='fdfind --type f --strip-cwd-prefix --hidden --follow --exclude .git'
bindkey -r '^T'


tt() {
    local session
    session=$(tmux list-sessions -F '#S' | fzf --prompt="tmux > ")
    if [[ -n $session ]]; then
        tmux switch-client -t "$session"
    fi
}
zle -N tt
bindkey '^T' tt

# Directory navigation - with depth limit and cache
fcd() {
  local file 
  dir=$(fdfind --type f --hidden --strip-cwd-prefix --follow \
    -E ".git" -E "node_modules" -E ".cache" -E ".venv" \
    -E ".vim" -E ".vscode" -E "go/pkg" -E ".npm" \
    -E "dist" -E "build" -E ".idea" -E "__pycache__" \
    | command fzf --prompt="file > ") && nvim "$file"
  zle reset-prompt
}

zle -N fcd
bindkey '^F' fcd

# Directory navigation - with depth limit and cache
dcd() {
  local dir
  dir=$(fdfind --type d --hidden --strip-cwd-prefix --follow \
    -E ".git" -E "node_modules" -E ".cache" -E ".venv" \
    -E ".vim" -E ".vscode" -E "go/pkg" -E ".npm" \
    -E "dist" -E "build" -E ".idea" -E "__pycache__" \
    | command fzf --prompt="dir > ") && cd "$dir"
  zle reset-prompt
}

zle -N dcd
bindkey '^D' dcd

cpf() {
  local files
  files=$(fd . --type f --hidden ~ | fzf --multi --prompt="files to copy > ")

  if [[ -n "$files" ]]; then
    echo "$files" | while IFS= read -r file; do
      cp -v "$file" "./$(basename "$file")"
    done
  else
    echo "select a file next time xD."
  fi
}

cpd() {
  local dirs
  dirs=$(fd . --type d --hidden ~ | fzf --multi --prompt="folders to copy > ")

  if [[ -n "$dirs" ]]; then
    echo "$dirs" | while IFS= read -r dir; do
      cp -vr "$dir" "./$(basename "$dir")"
    done
  else
    echo "select a dir next time xD."
  fi
}

# Process management - with optimized process listing and better formatting
fkill() {
  local pid
  if [[ $EUID -ne 0 ]]; then
    pid=$(ps -u "$UID" -o pid,ppid,comm,%cpu,%mem --sort=-%mem \
      | fzf --multi \
      | awk '{print $1}')
  else
    pid=$(ps -eo pid,ppid,comm,%cpu,%mem --sort=-%mem \
      | fzf \
      | awk '{print $1}')
  fi

  [[ -n "$pid" ]] && echo "$pid" | xargs kill -"${1:-9}"
}


zle -N fkill
bindkey '^K' fkill

# Enhanced with container info and faster listings
fdocker() {
  local action
  action=$(echo -e "ps\nlogs\nexec\nstop\nstart\nrestart\nrm\nstats" | 
           fzf --prompt="Docker action: " --height=10%)
  
  case "$action" in
    ps)
      docker ps ;;
    logs)
      local container
      container=$(docker ps --format "{{.Names}} ({{.Image}})" | 
                 fzf --prompt="Select container: " --height=40%)
      [[ -n "$container" ]] && docker logs -f "${container%% *}" ;;
    exec)
      local container
      container=$(docker ps --format "{{.Names}} ({{.Image}})" | 
                 fzf --prompt="Select container: " --height=40%)
      [[ -n "$container" ]] && docker exec -it "${container%% *}" /bin/bash ;;
    stop|start|restart|rm|stats)
      local container
      container=$(docker ps -a --format "{{.Names}} ({{.Status}})" | 
                 fzf --prompt="Select container: " --height=40%)
      [[ -n "$container" ]] && docker "$action" "${container%% *}" ;;
  esac
}
