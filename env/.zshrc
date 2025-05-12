export ZSH="$HOME/.oh-my-zsh"
source $ZSH/oh-my-zsh.sh
source ~/.zsh_profile

# ENVIRONMENT VARIABLES
export BAT_STYLE="changes,header"
export BAT_PAGER="less -FRX"

# OH MY ZSH SETUP
if [ -d "$HOME/.oh-my-zsh" ]; then
    export ZSH="$HOME/.oh-my-zsh"
    plugins=(git tmux tldr)
    source $ZSH/oh-my-zsh.sh
fi

# PROMPT CONFIGURATION
autoload -Uz vcs_info
precmd() { vcs_info }
zstyle ':vcs_info:git:*' formats '%b '
setopt PROMPT_SUBST
PROMPT='%F{220}%n%f %F{254}%1~%f %F{168}${vcs_info_msg_0_}%f%F{15}→%f '

# Node Version Manager
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Zoxide (smarter cd)
eval "$(zoxide init zsh)"

# FZF core setup
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_COMMAND='fdfind --type f'
export FZF_CTRL_T_COMMAND='fdfind --type f'

# FZF appearance
export FZF_DEFAULT_OPTS=" \
--border=rounded \
--height=20% \
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

# File operations
alias pbcopy='xclip -selection clipboard'
alias pbpaste='xclip -selection clipboard -o'
unalias ls 2>/dev/null
alias ls='eza'
alias l='eza -l'
alias la='eza -la'
alias lt='eza --tree'

# Enhanced tools
alias fd="fdfind --hidden --follow --exclude .git"
alias bat="batcat"
alias cat="bat --paging=never"
alias rg='rg --no-ignore'
alias tldr="tldr -t base16"
alias cd="z"
alias kubectl="minikube kubectl --"

# Neovim file selection
nvim_finder() {
  local selected_file
  selected_file=$(fd --type f --hidden \
    -E ".git" \
    -E ".git/**" \
    -E "node_modules" \
    -E "node_modules/**" \
    -E ".cache" \
    -E ".cache/**" \
    -E ".venv" \
    -E ".venv/**" \
    -E ".vscode" \
    -E ".vim" \
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
    -E "__pycache__" \
    -E "*.pyc" \
    -E "*.o" \
    -E "*.so" \
    -E "*.dylib" \
    -E "*.dll" \
    -E "*.class" \
    -E "*.exe" \
    -E "*.bin" \
    -E "*.lock" | 
    fzf --preview 'bat --color=always --style=numbers --line-range=:50 {}')
  [[ -n "$selected_file" ]] && nvim "$selected_file"
}
bindkey -s '^N' 'nvim_finder\n'

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

# Theme toggle shortcut
bindkey -s '^U' 'bash ~/toggle-theme.sh\n'
