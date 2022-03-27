
#### FIG ENV VARIABLES ####
# Please make sure this block is at the start of this file.
[ -s ~/.fig/shell/pre.sh ] && source ~/.fig/shell/pre.sh
#### END FIG ENV VARIABLES ####
# =============
#    INIT
# =============
[ -r ~/.zsh_private ] && source ~/.zsh_private
setopt +o nomatch 


# =============
#    HISTORY
# =============
#履歴ファイルの保存先
export HISTFILE=${HOME}/.zsh_history
# メモリに保存される履歴の件数
export HISTSIZE=1000000
# 履歴ファイルに保存される履歴の件数
export SAVEHIST=1000000
# 直前の重複を記録しない
setopt hist_ignore_dups
# 重複を記録しない
setopt hist_ignore_all_dups
# historyを共有
setopt share_history
setopt append_history
# 開始と終了を記録
setopt EXTENDED_HISTORY


# ===================
#    TMUX
# ===================
#tmux起動
[[ -z "$TMUX" && ! -z "$PS1" ]] && tmux -u

#tmuxでemacsのキーバインド
bindkey -e


# ===================
#    PLUGINS
# ===================
##lika a fish syntax-highright
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
##like a fish suggest
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

function gcd() {
  local repo_path=`ghq list --full-path | fzf --reverse --preview "bat  --color=always --style=header,grid --line-range :100 {1}/README.md"`
  \cd ${repo_path}
}

function select-history() {
    BUFFER=$(history -n -r 1 | peco --query "$LBUFFER" --prompt="History > ")
      CURSOR=$#BUFFER
}
zle -N select-history
bindkey '^r' select-history



# =============
#    ALIAS
# =============
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias d='dirs -v | head -10'
  
alias ls='exa -G'
alias la='exa -la'

alias vi='vim'

alias dk='docker'
alias dps='docker ps'
alias di='docker images'
alias drm='docker rm $(docker ps --all --quiet)'
alias dc='docker-compose'

alias k='kubectl'
alias kx='kubectx'

alias gc='git commit'
alias sw='git switch'
alias sm='git switch master && git pull'
alias gsm='git for-each-ref refs/heads/ "--format=%(refname:short)" | while read branch; do mergeBase=$(git merge-base master $branch) && [[ $(git cherry master $(git commit-tree $(git rev-parse $branch\^{tree}) -p $mergeBase -m _)) == "-"* ]] && git branch -D $branch; done'

alias cat='ccat'
alias ee='exit'
alias t='tig status'
alias gl='gcd'


# =============
#    THEME
# =============
eval "$(starship init zsh)"
# Customize to your needs...(ターミナルが青くて見にくいので直す)
export CLICOLOR=1
export LSCOLORS=DxGxcxdxCxegedabagacad
