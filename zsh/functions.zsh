#! /bin/bash

function countfiles()
{
  if [ -z "$1" ]; then
    cur_path="."
  else
    cur_path="$1"
  fi

  files_num=$(ls -A "$cur_path" | wc -l) # -A不包括.和..
  echo "$files_num files in $cur_path"
}

# tar
function tar_list
{
  tar -tvf # t即list，列出归档文件中的所有文件

}
function tar_make
{
  echo "tar -czvf ${1}.tar.gz $1: create, gzip, verbose, file"
  local dest="$1".tar.gz
  shift
  local src="$@"
  tar -czvf "$dest" "$src"
}
function tar_unmake
{
  echo "tar -zxvf $1: extract, gzip, verbose, file"
  tar -xzvf "$1"
}

function extract()
{
  if [ -f "$1" ]; then
    case $1 in
      *.7z) 7z x "$1" ;;
      *.lzma) unlzma "$1" ;;
      *.rar) unrar x "$1" ;;
      *.tar) tar xvf "$1" ;;
      *.tar.bz2) tar xvjf "$1" ;;
      *.bz2) bunzip2 "$1" ;;
      *.tar.gz) tar xvzf "$1" ;;
      *.gz) gunzip "$1" ;;
      *.tar.xz) tar Jxvf "$1" ;;
      *.xz) xz -d "$1" ;;
      *.tbz2) tar xvjf "$1" ;;
      *.tgz) tar xvzf "$1" ;;
      *.zip) unzip "$1" ;;
      *.Z) uncompress ;;
      *) echo "don't know how to extract $1..." ;;
    esac
  else
    echo "Error: $1 is not a valid file!"
  fi
}

psgrep()
{
  ps aux | grep $@ | grep -v grep
}

function hist()
{
  echo "Use !number to execute the command"
  history -i
}

function mkcd()
{
  # parents, 递归地创建目录，如果父目录不存在，自动创建
  mkdir -p $1
  cd $1
}

function note()
{
  if [ -z "$1" ]; then
    "$EDITOR" "$HOME/.notes/note_${countfiles}.txt"
  else
    "$EDITOR" "$HOME/.notes/$1"
  fi
}

function sshf()
{
  if [[ ! -e ~/.ssh/config ]]; then
    echo 'There is no SSH config file!'
    return
  fi

  hostnames=$(awk ' $1 == "Host" { print $2 } ' ~/.ssh/config)
  if [[ -z ${hostnames} ]]; then
    echo 'There are no host entries in the SSH config file'
    return
  fi

  selected=$(printf "%s\n" "${hostnames[@]}" | fzf --reverse --border=rounded --cycle --height=30% --header='pick a host')
  if [[ -z ${selected} ]]; then
    echo 'Nothing was selected :('
    return
  fi

  echo "SSH to ${selected}..."
  ssh "$selected"
}

local green="\033[32m"
local cyan="\033[36m"
local reset="\033[0m"
local red="\e[31m"
local yellow="\033[33m"

function get_git_info()
{
  local git_version='✘>﹏<✘'
  if command -v git > /dev/null 2>&1; then
    git_version=$(git --version | cut -d' ' -f3)
  fi
  echo "${green}git: $cyan$git_version$reset"
}

function get_c_info()
{
  local gcc_version='✘>﹏<✘'
  if command -v gcc > /dev/null 2>&1; then
    gcc_version=$(gcc --version | head -n 1 | cut -d' ' -f3)
  fi
  local clang_version='✘>﹏<✘'
  if command -v clang > /dev/null 2>&1; then
    clang_version=$(clang --version | head -n 1 | cut -d' ' -f3)
  fi
  echo "${green}gcc: $cyan$gcc_version ${green}clang: $cyan$clang_version$reset"
}

function get_python_info()
{
  local python_version='✘>﹏<✘'
  if command -v python > /dev/null 2>&1; then
    python_version=$(python --version 2>&1 | cut -d' ' -f2)
  elif command -v python3 > /dev/null 2>&1; then
    python_version=$(python --version 2>&1 | cut -d' ' -f2)
  fi
  local venv_info='✘>﹏<✘'
  if [[ $VIRTUAL_ENV =~ "venv$" ]]; then
    venv_info=${VIRTUAL_ENV:h:t}
  elif [ -n "$VIRTUAL_ENV" ]; then
    venv_info="${VIRTUAL_ENV:t}"
  fi
  echo "${green}python: $cyan$python_version ${green}virtual env: $cyan$venv_info$reset"
}

function get_go_info()
{
  local go_version='✘>﹏<✘'
  if command -v go > /dev/null 2>&1; then
    go_version=$(go version | cut -d' ' -f3)
    go_version=${go_version/go/}
  fi
  echo "${green}go: $cyan$go_version$reset"
}

function dev_tools_info()
{
  get_git_info
  get_c_info
  get_python_info
  get_go_info
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

function loadavg()
{
  if [[ ! -f "/proc/loadavg" ]]; then
    echo "/proc/loadavg does not exist"
  fi

  local loadavg
  loadavg=$(cat /proc/loadavg 2> /dev/null)

  if [[ -n $loadavg ]]; then
    local loadavg_fields=($(echo "$loadavg" | cut -d' ' -f1-))
    printf "load_average_1_minute:\t\t%s\n" "${loadavg_fields[1]}"
    printf "load_average_5_minutes:\t\t%s\n" "${loadavg_fields[2]}"
    printf "load_average_15_minutes:\t%s\n" "${loadavg_fields[3]}"
    printf "runnable_processes/total_processes: \t%s\n" "${loadavg_fields[4]}"
    printf "last_process_id\t%s\n" "${loadavg_fields[5]}"
  else
    echo "cannot read /proc/loadavg"
  fi
}

function proxy_set()
{
  local __user=$(
    read -p "username: "
    echo ${REPLY}
  )
  local __pass=$(
    read -sp "password: "
    echo ${REPLY}
  )

  # Deal with no newlines after `read -p`.
  echo

  local __serv=${1-$(
    read -p "server: "
    echo ${REPLY}
  )}
  local __prot=${2-$(
    read -p "protocol: "
    echo ${REPLY}
  )}

  # Create proxy url.
  local __prox="${__prot}://${__user}:${__pass}@${__serv}"

  export HTTP_PROXY="${__prox}"
  export HTTPS_PROXY="${__prox}"
  export SOCKS_PROXY="${__prox}"
  export FTP_PROXY="${__prox}"
  export ALL_PROXY="${__prox}"

  export http_proxy="${__prox}"
  export https_proxy="${__prox}"
  export socks_proxy="${__prox}"
  export ftp_proxy="${__prox}"
  export all_proxy="${__prox}"
}

function proxy_unset()
{
  unset HTTP_PROXY HTTPS_PROXY SOCKS_PROXY FTP_PROXY ALL_PROXY
  unset http_proxy https_proxy socks_proxy ftp_proxy all_proxy
}

function nvim_clean()
{
  rm -rf ~/.config/nvim
  rm -rf ~/.local/share/nvim
  rm -rf ~/.local/state/nvim
  rm -rf ~/.cache/nvim
}

function gap()
{
  if [[ -z $1 ]]; then
    echo "please commit message input!!" 1>&2
    exit 1
  fi
  git add . && git commit -m "$1" && git push
}
