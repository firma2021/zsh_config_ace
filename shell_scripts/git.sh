#!/bin/bash

hashColor='\033[35m'    # 品红
contentColor='\033[36m' # 青色
dateColor='\033[33m'    # 黄色
authorColor='\033[34m'  # 蓝色

alias gco='git checkout'
alias gpo='git push origin $(git symbolic-ref --short -q HEAD)'
alias gpl='git pull origin $(git symbolic-ref --short -q HEAD) --ff-only'
alias gd='git --no-pager diff'
alias gs='git --no-pager status'
alias gss='git --no-pager status -s'
alias gsh='git --no-pager show'
alias gpt='git push origin --tags'

function glt
{
  git tag -n --sort=taggerdate | tail -n "${1-10}"
}

gat()
{
  git tag -a "$1" -m "$2"
}

gam()
{
  git add --all && git commit -m "$*"
}

gitlog()
{
  git --no-pager log --date=format:'%Y-%m-%d %H:%M' --pretty=tformat:"$1" --graph -n "${2-10}"
}

gll()
{
  gitlog "%C(${hashColor})%h %C(${contentColor})%s%Creset" "$1"
}

glll()
{
  gitlog "%C(${hashColor})%h %C(${dateColor})%cd %C(${authorColor})%cn: %C(${contentColor})%s%Creset" "$1"
}

function git_info()
{
  if [[ -z $(command git status --porcelain 2> /dev/null) ]]; then
    echo "${red}The .git directory does not exist.$reset"
    return
  fi
  echo "$cyan$(git branch --show-current 2> /dev/null)$reset"

  local git_status
  git_status=$(git status --porcelain 2> /dev/null | awk '{
    if ($1 == "A") { $1 = "added" }
    else if ($1 == "M") { $1 = "modified" }
    else if ($1 == "R") { $1 = "renamed" }
    else if ($1 == "??") { $1 = "untracked" }
    else if ($1 == "D") { $1 = "deleted" }
    print
    }')
  echo "${green}$git_status${reset}"
}
