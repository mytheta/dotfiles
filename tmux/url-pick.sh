#!/bin/sh
# 指定ペインから URL を抽出し、fzf で選んだものを OSC 52 で手元のクリップボードへ送る。
# tmux は折り返しを別行として描くため、Ghostty の cmd+click では長い URL が途中で切れる。
# capture-pane -J で折り返しを連結してから抽出することで URL 全体を取れる。
#
# usage: url-pick.sh <pane_id>          (tmux の run-shell から呼ぶ)
#        url-pick.sh --pick <pane_id>   (popup 内で実行される)
set -eu

if [ "${1:-}" != "--pick" ]; then
  # display-popup のコマンドは #{pane_id} が展開されないため、ここで pane を渡し直す
  exec tmux display-popup -E -w 80% -h 40% -T ' URL -> clipboard ' "$0 --pick $1"
fi

pane=$2
url=$(
  tmux capture-pane -J -p -S -5000 -t "$pane" |
    grep -oE 'https?://[^][:space:]<>"]+' |
    awk '!seen[$0]++' |
    "$HOME/.local/share/mise/shims/fzf" --tac --no-sort
) || exit 0

[ -n "$url" ] || exit 0
tmux set-buffer -w -- "$url"
tmux display-message "copied: $url"
