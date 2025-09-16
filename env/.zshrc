# source
export ZSH="$HOME/.oh-my-zsh"
source $ZSH/oh-my-zsh.sh
source ~/.zsh_profile


# setup tools
[ -f ~/.config/fzf/config.zsh ] && source ~/.config/fzf/config.zsh
eval "$(starship init zsh)"
export BAT_STYLE="changes,header"
export BAT_PAGER="less -FRX"
eval "$(zoxide init zsh)"
export LS_COLORS="..."
export EZA_COLORS="..."

# alias
alias pbcopy='xclip -selection clipboard'
alias pbpaste='xclip -selection clipboard -o'
unalias ls 2>/dev/null
alias vim=nvim
alias ls='eza'
alias l='eza -l'
alias la='eza -la'
alias lt='eza --tree'
alias fd="fdfind"
alias bat="batcat"
alias cat="bat --paging=never"
alias rg='rg --no-ignore'
alias okular="flatpak run org.kde.okular"
alias cd="z"
alias kubectl="minikube kubectl --"
setopt IGNORE_EOF
bindkey '^[w' forward-word     
