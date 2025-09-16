[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# FZF appearance
export FZF_DEFAULT_OPTS=" \
--tmux=82% \
--ansi \
--cycle \
--no-mouse \
--layout=reverse \
--border=rounded \
--info=inline \
--prompt='▶ ' \
--pointer='◆' \
--marker='*' \
--separator='━' \
--color=fg:#d8dee9,bg:#161616,hl:#81a1c1 \
--color=fg+:#e5e9f0,bg+:#2e3440,hl+:#88c0d0 \
--color=info:#ebcb8b,prompt:#81a1c1,pointer:#ebcb8b \
--color=marker:#ebcb8b,spinner:#81a1c1,header:#81a1c1,border:#4c566a"

# Use ~~ as the trigger sequence instead of the default **
export FZF_COMPLETION_TRIGGER='~~'
export FZF_COMPLETION_OPTS='--border --info=inline'
export FZF_COMPLETION_PATH_OPTS='--walker file,dir,follow'
export FZF_COMPLETION_DIR_OPTS='--walker dir,follow'
export FZF_DEFAULT_COMMAND='fdfind --type f --strip-cwd-prefix --follow'

# Directory navigation - with depth limit and cache
fcd() {
  local file
  file=$(fdfind --type f --strip-cwd-prefix --follow \
    | command fzf --prompt="file > ")
  [[ -n $file ]] && nvim "$file"
  zle reset-prompt
}
zle -N fcd
bindkey '^F' fcd

# Directory navigation - with depth limit and cache
dcd() {
  local dir
  dir=$(fdfind --type d  --strip-cwd-prefix --follow \
    | command fzf --prompt="dir > ") && cd "$dir"
  zle reset-prompt
}

zle -N dcd
bindkey '^D' dcd

cpf() {
  local files
  files=$(fd . --type f --hidden ~ | fzf --multi --prompt="files to copy (tab to select) > ")
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
  dirs=$(fd . --type d --hidden ~ | fzf --multi --prompt="folders to copy (tab to select) > ")

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

fpath_any() {
  local last_arg=${LBUFFER##* }
  local dir
  dir=$(eval echo "$last_arg")
  [[ ! -d "$dir" ]] && dir="$PWD"

  local file
  file=$(fd --absolute-path . "$dir" --type f \
    | fzf --prompt="file > " \
          --preview '[[ $(file --mime-type -b {}) == text/* ]] && batcat --color=always {} || ([[ $(file --mime-type -b {}) =~ ^image/ ]] && chafa {} || file --brief {})' \
          --preview-window=right:50%)

  if [[ -n "$file" ]]; then
    LBUFFER="${LBUFFER%$last_arg*}$file "
  fi

  zle reset-prompt
}

zle -N fpath_any
bindkey '^P' fpath_any


bookie() {
    local file
    file=$(fd . /home/nahuel/Dropbox/Apps/Books --type f --hidden --max-depth 1 | fzf --multi --prompt="Select book > ")
    if [[ -n "$file" ]]; then
        echo "$file" | while IFS= read -r f; do
            flatpak run org.kde.okular "$f" & 
        done
    else
        echo "No book selected."
    fi
}
