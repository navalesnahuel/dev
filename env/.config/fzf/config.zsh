[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# FZF appearance
export FZF_DEFAULT_OPTS=" \
--tmux \
--ansi \
--border=rounded \
--height=100% \
--prompt='▶ ' \
--pointer='>' \
--separator="─" \
--no-mouse \
--preview-window=hidden \
--cycle \
--layout=reverse"


export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS"\
" --color=bg+:#232530,bg:#1c1e26,spinner:#24a8b4,hl:#df5273"\
" --color=fg:#9da0a2,header:#df5273,info:#efb993,pointer:#24a8b4"\
" --color=marker:#24a8b4,fg+:#dcdfe4,prompt:#efb993,hl+:#df5273,gutter:#1c1e26"

# Use ~~ as the trigger sequence instead of the default **
export FZF_COMPLETION_TRIGGER='~~'
export FZF_COMPLETION_OPTS='--border --info=inline'
export FZF_COMPLETION_PATH_OPTS='--walker file,dir,follow,hidden'
export FZF_COMPLETION_DIR_OPTS='--walker dir,follow'
export FZF_DEFAULT_COMMAND='fdfind --type f --strip-cwd-prefix --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"


# Directory navigation - with depth limit and cache
fcd() {
  local dir
  dir=$(fdfind --type d --hidden --strip-cwd-prefix --follow \
    -E ".git" -E "node_modules" -E ".cache" -E ".venv" \
    -E ".vim" -E ".vscode" -E "go/pkg" -E ".npm" \
    -E "dist" -E "build" -E ".idea" -E "__pycache__" \
    | command fzf) && cd "$dir"
  zle reset-prompt
}

zle -N fcd
bindkey '^F' fcd

fcp() {
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

dcp() {
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
