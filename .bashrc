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
export TERM=xterm-256color
export EDITOR=vim
export GEMEDITOR=vim
export CLICOLOR=1
export HISTCONTROL="ignoreboth"

if [ -f /usr/local/bin/brew ]; then
  eval "$(/usr/local/bin/brew shellenv)"
elif [ -f /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Paths
if [ "$(uname)" = "Darwin" ]; then
  export PNPM_HOME="$HOME/Library/pnpm" # pnpm
  export PATH="$PNPM_HOME:$PATH" # pnpm
fi
export PATH="$HOME/Code/go/bin:$PATH" # go
export PATH="$HOME/.cargo/bin:$PATH" # rustup
if which pyenv > /dev/null; then
  eval "$(pyenv init -)"
fi
if which rbenv > /dev/null; then
  eval "$(rbenv init -)"
fi
export PATH="$HOME/bin:$PATH" # custom stuff

# Go
export GOPATH="$HOME/Code/go"

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
alias e="exa"

# Include custom magic pattern files for file(1)
alias file="file -m ~/.config/file/magic"

# Changing directories
c() { cd ~/Code/$1; }

# Completions
[[ -r "$HOMEBREW_PREFIX/etc/profile.d/bash_completion.sh" ]] && . "$HOMEBREW_PREFIX/etc/profile.d/bash_completion.sh"
for completion_file in \
  bat \
  brew \
  fd.bash \
  git-completion.bash \
  kubectl \
  npm \
  rg.bash \
  sd.bash
do
  if [ "$(uname)" = "Darwin" ]; then
    full_completion_file="$HOMEBREW_PREFIX/etc/bash_completion.d/$completion_file"
  else
    full_completion_file="/usr/share/bash-completion/completions/$completion_file"
  fi
  if [ -r $full_completion_file ]; then
    source $full_completion_file
  fi
done

if which rustc >/dev/null; then
  cargo_completion=$(rustc --print sysroot)/etc/bash_completion.d/cargo
  [ -f "$cargo_completion" ] && source $cargo_completion
fi

fzf_base_path="$HOMEBREW_PREFIX/opt/fzf/shell"
for completion_file in \
  completion.bash \
  key-bindings.bash
do
  if [ -f "$fzf_base_path/$completion_file" ]; then
    source "$fzf_base_path/$completion_file"
  fi
done

_c_complete() {
  local cur matches
  cur="${COMP_WORDS[COMP_CWORD]}"
  matches=$(basename -a ~/Code/*)
  COMPREPLY=( $(compgen -W "${matches}" -- ${cur}) )
}

complete -o default -F _c_complete c

# Searching. This affects fzf.vim's `:Files` command in Vim.
if which rg >/dev/null; then
  export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git/*"'
else
  echo 'fzf default command cannot be set without ripgrep. Run `brew install rg`.' >&2
fi

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

# Colored man pages
if which bat >/dev/null; then
  export MANPAGER="sh -c 'col -bx | bat -l man -p'"
else
  echo 'Colored man pages are not available. Activate them with `brew install bat`.' >&2
fi

# Prompt
export PROMPT_COMMAND='jobsrunning=$(jobs -p)'
export PS1="\[\033]0;\007\]\[${blue}\][\$(hostname -s)] \[${green}\]\w\[${darkcyan}\] \$(_parse_git_branch)\[${yellow}\]\${jobsrunning:+(\j) }\[${green}\]\\$\[${end}\] "

# Local (private) settings
if [ -f ~/.localrc ]; then
  source ~/.localrc
fi
