current_term=""

if [[ "$TERM" == "linux" ]] then
  current_term="tty"
else
  current_term="$(ps -o comm= -p $PPID)"
fi

get_new_tmux_session_name() {
  local SEP
  local next_num

  SEP='_'
  next_num=$(
    command tmux list-sessions -F "#S" 2>/dev/null | \
    grep -E "^${current_term}${SEP}[0-9]+$" | \
    cut -d"${SEP}" -f2 | \
    sort -n | \
    awk 'BEGIN {last=0} {if ($1 > last+1) exit; last=$1} END {print last+1}'
  )

  echo "${current_term}${SEP}${next_num:-1}"
}

alias tmux='tmux new-session -s "$(get_new_tmux_session_name)"'

if [[ -z "$TMUX" && -n "$PS1" && "$TERM" != "linux" ]]; then
  if [[ "$TERM" == "linux" ]]; then
    session_name=$(basename "$(tty)")
  else
    session_name="$(get_new_tmux_session_name)"
  fi

  if [[ $session_name != code_[0-9]* ]]; then
    /usr/bin/tmux new-session -s "$session_name"
  fi
fi
