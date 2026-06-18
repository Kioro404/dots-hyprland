PROMPT='%B%(!.%F{red}.%F{white})>%f%b '
RPS1='%(?..%F{red}%? ✗%f)'

# ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[green]%}["
# ZSH_THEME_GIT_PROMPT_SUFFIX="] %{$reset_color%}"

# ZSH_THEME_HG_PROMPT_PREFIX="%{$fg[magenta]%}hg:[%{$fg[yellow]%}"
# ZSH_THEME_HG_PROMPT_SUFFIX="%{$fg[magenta]%}] %{$reset_color%}"
# ZSH_THEME_HG_PROMPT_DIRTY=" %{$fg[red]%}✗"
# ZSH_THEME_HG_PROMPT_CLEAN=""

# # TMUX ZSH Theme

# # settings
# typeset +H _current_dir="%{$fg_bold[blue]%}%3~%{$reset_color%} "
# typeset +H _return_status="%{$fg_bold[red]%}%(?..⍉)%{$reset_color%}"
# typeset +H _hist_no="%{$fg[grey]%}%h%{$reset_color%}"

# PROMPT='$(git_prompt_info)$(ruby_prompt_info) %{%(!.${fg[red]}.${fg[white]})%}▶%{$reset_color%} '

# PROMPT2='%{%(!.${fg[red]}.${fg[white]})%}◀%{$reset_color%} '

# # __RPROMPT='$(vi_mode_prompt_info)%{$(echotc UP 1)%}$(_git_time_since_commit) $(git_prompt_status) ${_return_status}%{$(echotc DO 1)%}'
# # if [[ -z $RPROMPT ]]; then
# #   RPROMPT=$__RPROMPT
# # else
# #   RPROMPT="${RPROMPT} ${__RPROMPT}"
# # fi

# # Determine the time since last commit. If branch is clean,
# # use a neutral color, otherwise colors will vary according to time.
# function _git_time_since_commit() {
#   local last_commit now seconds_since_last_commit
#   local minutes hours days years commit_age
#   # Only proceed if there is actually a commit.
#   if last_commit=$(command git -c log.showSignature=false log --format='%at' -1 2>/dev/null); then
#     now=$(date +%s)
#     seconds_since_last_commit=$((now-last_commit))

#     # Totals
#     minutes=$((seconds_since_last_commit / 60))
#     hours=$((minutes / 60))
#     days=$((hours / 24))
#     years=$((days / 365))

#     if [[ $years -gt 0 ]]; then
#       commit_age="${years}y$((days % 365 ))d"
#     elif [[ $days -gt 0 ]]; then
#       commit_age="${days}d$((hours % 24))h"
#     elif [[ $hours -gt 0 ]]; then
#       commit_age+="${hours}h$(( minutes % 60 ))m"
#     else
#       commit_age="${minutes}m"
#     fi

#     echo "${ZSH_THEME_GIT_TIME_SINCE_COMMIT_NEUTRAL}${commit_age}%{$reset_color%}"
#   fi
# }

# MODE_INDICATOR="%{$fg_bold[yellow]%}❮%{$reset_color%}%{$fg[yellow]%}❮❮%{$reset_color%}"

# # Git prompt settings
# ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[green]%}"
# ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
# ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg[red]%}✗%{$reset_color%}"
# ZSH_THEME_GIT_PROMPT_CLEAN=" %{$fg[green]%}✔%{$reset_color%}"
# ZSH_THEME_GIT_PROMPT_ADDED="%{$fg[green]%}✚ "
# ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg[yellow]%}⚑ "
# ZSH_THEME_GIT_PROMPT_DELETED="%{$fg[red]%}✖ "
# ZSH_THEME_GIT_PROMPT_RENAMED="%{$fg[blue]%}▴ "
# ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg[cyan]%}§ "
# ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[white]%}◒ "

# # Ruby prompt settings
# ZSH_THEME_RUBY_PROMPT_PREFIX="%{$fg[grey]%}"
# ZSH_THEME_RUBY_PROMPT_SUFFIX="%{$reset_color%}"

# # Colors vary depending on time lapsed.
# ZSH_THEME_GIT_TIME_SINCE_COMMIT_SHORT="%{$fg[green]%}"
# ZSH_THEME_GIT_TIME_SHORT_COMMIT_MEDIUM="%{$fg[yellow]%}"
# ZSH_THEME_GIT_TIME_SINCE_COMMIT_LONG="%{$fg[red]%}"
# ZSH_THEME_GIT_TIME_SINCE_COMMIT_NEUTRAL="%{$fg[white]%}"

# LS colors, made with https://geoff.greer.fm/lscolors/
export LSCOLORS="exfxcxdxbxegedabagacad"
export LS_COLORS='di=34;40:ln=35;40:so=32;40:pi=33;40:ex=31;40:bd=34;46:cd=34;43:su=0;41:sg=0;46:tw=0;42:ow=0;43:'
export GREP_COLORS='mt=1;33'
