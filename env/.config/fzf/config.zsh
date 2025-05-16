[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# FZF core setup
export FZF_DEFAULT_COMMAND='fdfind --type f'
export FZF_CTRL_T_COMMAND='fdfind --type f'

# FZF appearance
export FZF_DEFAULT_OPTS=" \
--border=rounded \
--height=40% \
--no-info \
--prompt='▶ ' \
--pointer='-' \
--separator="─" \
--scrollbar="" \
--color=bg:#1e1e1e,fg:#a0a0a0 \
--color=bg+:#303030,fg+:#e0e0e0:bold \
--color=hl:#87afd7:bold \
--color=hl+:#e0e0e0:bold \
--color=pointer:#e0e0e0:bold \
--color=prompt:#e0e0e0,spinner:#606060,header:#606060 \
--color=border:#1e1e1e,label:#a0a0a0,gutter:#1e1e1e \
--no-hscroll \
--preview-window=hidden \
--cycle \
--tabstop=4 \
--layout=reverse
"

# Directory navigation - with depth limit and cache
dir_jumper() {
  local selected_dir
  selected_dir=$(fd --type d --hidden \
    -E ".git" \
    -E ".git/**" \
    -E "node_modules" \
    -E "node_modules/**" \
    -E ".cache" \
    -E ".cache/**" \
    -E ".venv" \
    -E ".vim" \
    -E ".venv/**" \
    -E ".vscode" \
    -E ".vscode/**" \
    -E "go/pkg" \
    -E "go/pkg/**" \
    -E ".npm" \
    -E ".npm/**" \
    -E "dist" \
    -E "dist/**" \
    -E "build" \
    -E "build/**" \
    -E ".idea" \
    -E "__pycache__" | fzf)
  [[ -n "$selected_dir" ]] && cd "$selected_dir"
}
bindkey -s '^G' 'dir_jumper\n'

# Process management - with optimized process listing and better formatting
process_killer() {
  local pid
  pid=$(ps -eo pid,pcpu,pmem,comm --sort=-pcpu | 
         grep -v PID | 
         head -30 | 
         fzf --header="PID %CPU %MEM COMMAND" --header-lines=0 |
         awk '{print $1}')
  [[ -n "$pid" ]] && kill -9 "$pid"
}
bindkey -s '^K' 'process_killer\n'

# Git operations - with branch info and faster checkout
git_checkout() {
  local branch
  branch=$(git branch --sort=-committerdate --format='%(refname:short) (%(committerdate:relative))' 2>/dev/null | 
           fzf --no-multi --header="Select branch to checkout" | 
           awk '{print $1}')
  [[ -n "$branch" ]] && git checkout "$branch"
}
bindkey -s '^B' 'git_checkout\n'

# Enhanced with container info and faster listings
fzf_docker() {
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
# Docker shortcut
bindkey -s '^D' 'fzf_docker\n'
