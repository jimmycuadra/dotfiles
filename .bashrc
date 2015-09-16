#!/usr/bin/env bash

# Shell options
shopt -s globstar 2>/dev/null # requires Bash 4

# Colors
e=`printf "\033"`
end="$e[0m"
red="$e[1;31m"
green="$e[1;32m"
yellow="$e[1;33m"
blue="$e[1;34m"
magenta="$e[1;35m"
darkcyan="$e[1;36m"

# Miscellaneous
export EDITOR=vim
export GEMEDITOR=vim
export CLICOLOR=1
export HISTCONTROL="ignoreboth"

# Paths
export PATH="/usr/local/bin:/usr/local/sbin:$PATH" # Homebrew
export PATH="/usr/local/share/npm/bin:$PATH" # npm
# pyenv (adds to paths)
export PYENV_ROOT=/usr/local/opt/pyenv
if which pyenv > /dev/null; then
  eval "$(pyenv init -)"
fi
# rbenv (adds to paths)
export RBENV_ROOT=/usr/local/opt/rbenv
if which rbenv > /dev/null; then
  eval "$(rbenv init -)"
fi

# Git
_parse_git_branch() {
  ref=$(command git symbolic-ref HEAD 2> /dev/null) || return
  echo "("${ref#refs/heads/}") "
}

# SVN
svndiff() { svn diff $@ | colordiff | less -R; }
alias svnadd="svn status | grep ^? | sed 's/^.* /svn add /' | bash"
alias svnrevert="svn revert -R ."
alias svnclean='for i in $(svn st | grep \? | cut -c 9-); do echo $i && rm -r $i; done'

# File and directory listings
alias ls="ls -F"
alias l="ls -lAh"
alias ll="ls -l"
alias la="ls -A"

# Changing directories
c() { cd ~/Code/$1; }

# Completions
for completion_file in \
  ag.bashcomp.sh \
  cargo \
  docker \
  docker-compose \
  git-completion.bash \
  go-completion.bash.sh
do
  full_completion_file="/usr/local/etc/bash_completion.d/$completion_file"
  if [ -f $full_completion_file ]; then
    source $full_completion_file
  fi
done

_c_complete() {
  local cur matches
  cur="${COMP_WORDS[COMP_CWORD]}"
  matches=$(basename ~/Code/*)
  COMPREPLY=( $(compgen -W "${matches}" -- ${cur}) )
}

complete -o default -F _c_complete c

# Bash functions
ports() {
  lsof -iTCP -sTCP:LISTEN -P "$@"
}

# Ruby
export RUBY_GC_HEAP_INIT_SLOTS=800000
export RUBY_HEAP_FREE_MIN=100000
export RUBY_HEAP_SLOTS_INCREMENT=300000
export RUBY_HEAP_SLOTS_GROWTH_FACTOR=1
export RUBY_GC_MALLOC_LIMIT=79000000

alias be="bundle exec"

railsapp() {
  local template=~/Code/railsapp/template.rb
  [ -e $template ] && rails new $1 --skip-bundle -T -m $template
}

# C
alias marvin="gcc -Wall -Wextra -ansi -pedantic"

# Local (private) settings
if [ -f ~/.localrc ]; then
  source ~/.localrc
fi

# Prompt
export PROMPT_COMMAND='jobsrunning=$(jobs -p)'
export PS1="\[\033]0;\007\]\[${blue}\][\$(hostname -s)] \[${red}\][\$(rbenv version-name)] \[${darkcyan}\][\$(pyenv version-name)] \[${green}\]\w\[${darkcyan}\] \$(_parse_git_branch)\[${yellow}\]\${jobsrunning:+(\j) }\[${green}\]\\$\[${end}\] "
