# =============
#    INIT
# =============
[ -r ~/.zsh_private ] && source ~/.zsh_private


# =============
#    HISTORY
# =============
#履歴ファイルの保存先
export HISTFILE=${HOME}/.zsh_history
# メモリに保存される履歴の件数
export HISTSIZE=1000000
# 履歴ファイルに保存される履歴の件数
export SAVEHIST=1000000
# 重複を記録しない
setopt hist_ignore_dups
# historyを共有
setopt share_history
setopt append_history
# 開始と終了を記録
setopt EXTENDED_HISTORY


# ===================
#    PLUGINS
# ===================
##lika a fish syntax-highright
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
##like a fish suggest
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

gcd() {
  local repo_path=`ghq list --full-path | fzf --reverse --preview "glow -s dark {1}/README.md"`
  \cd ${repo_path}
}


# ===================
#    TMUX
# ===================
#tmux起動
[[ -z "$TMUX" && ! -z "$PS1" ]] && tmux

#tmuxでemacsのキーバインド
bindkey -e


# =============
#    ALIAS
# =============
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias d='dirs -v | head -10'
  
alias ls="ls -G"
alias la="ls -la"

alias vi='vim'

alias dk='docker'
alias dps="docker ps"
alias di="docker images"
alias drm='docker rm $(docker ps --all --quiet)'
alias dc='docker-compose'

alias k='kubectl'
alias kx='kubectx'

alias gc='git commit'
alias sw='git switch'
alias sm='git switch master && git pull'

alias cat='ccat'
alias ee='exit'
alias t="tig status"
alias g='gcd'


# =============
#    THEME
# =============
eval "$(starship init zsh)"
# Customize to your needs...(ターミナルが青くて見にくいので直す)
export CLICOLOR=1
export LSCOLORS=DxGxcxdxCxegedabagacad

