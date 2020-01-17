setopt prompt_subst

# https://qiita.com/nishina555/items/f4f1ddc6ed7b0b296825
function get-git-current-branch-status {
  local branch_name git_status color message

  if [ ! -e  ".git" ]; then
    return
  fi
  branch_name=`git rev-parse --abbrev-ref HEAD 2> /dev/null`
  git_status=`git status 2> /dev/null`
  if [[ -n `echo "$git_status" | grep "^nothing to"` ]]; then
    color='green'
    message=''
  elif [[ -n `echo "$git_status" | grep "^Changes not staged for commit"` ]]; then
    color='yellow'
    message='+'
  elif [[ -n `echo "$git_status" | grep "^Changes to be committed"` ]]; then
    color='yellow'
    message='!'
  elif [[ -n `echo "$git_status" | grep "^Untracked files"` ]]; then
    color='red'
    message='+'
  elif [[ -n `echo "$git_status" | grep "^rebase in progress"` ]]; then
    color='red'
    message='!'
  else
    color='blue'
    message='?'
  fi
  echo "%F{${color}}${branch_name}${message}%f "
}

autoload -U compinit
compinit -u
compdef g=git

eval "$(rbenv init - zsh)"
export PATH=$PATH:~/Applications
export RUBY_CONFIGURE_OPTS="--with-openssl-dir=$(brew --prefix openssl@1.1)"
PROMPT='%~ `get-git-current-branch-status`%F{yellow}\$%f '

