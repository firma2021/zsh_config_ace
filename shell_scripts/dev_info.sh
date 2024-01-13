#!/bin/bash

function echo_colorful_version()
{
  local cyan="\033[1;36m"
  local green="\033[1;32m"
  local reset="\033[0m"

  echo -e "${green}$1: ${cyan}$2$reset"
}

function get_git_info()
{
  local git_version='✘>﹏<✘'
  if command -v git &> /dev/null; then
    git_version=$(git --version | cut -d' ' -f3)
  fi

  echo_colorful_version 'git' "$git_version"
}

function get_c_info()
{
  local gcc_version='✘>﹏<✘'
  if command -v gcc &> /dev/null; then
    gcc_version=$(gcc --version | head -n 1 | cut -d' ' -f3)
  fi
  local clang_version='✘>﹏<✘'
  if command -v clang &> /dev/null; then
    clang_version=$(clang --version | head -n 1 | cut -d' ' -f3)
  fi

  echo_colorful_version 'gcc' "$gcc_version"
  echo_colorful_version 'clang' "$clang_version"
}

function get_python_info()
{
  local python_version='✘>﹏<✘'
  if command -v python &> /dev/null; then
    python_version=$(python --version 2>&1 | cut -d' ' -f2)
  elif command -v python3 &> /dev/null; then
    python_version=$(python --version 2>&1 | cut -d' ' -f2)
  fi
  local venv_info='✘>﹏<✘'
  if [[ $VIRTUAL_ENV =~ "venv$" ]]; then
    venv_info=${VIRTUAL_ENV:h:t}
  elif [ -n "$VIRTUAL_ENV" ]; then
    venv_info="${VIRTUAL_ENV:t}"
  fi

  echo_colorful_version 'python' "$python_version"
  echo_colorful_version 'virtual env' "$venv_info"
}

function get_go_info()
{
  local go_version='✘>﹏<✘'
  if command -v go &> /dev/null; then
    go_version=$(go version | cut -d' ' -f3)
    go_version=${go_version/go/}
  fi

  echo_colorful_version 'go' "$go_version"
}

function get_java_info()
{
  local java_version='✘>﹏<✘'
  if command -v java &> /dev/null; then
    java_version=$(java -version 2>&1 | awk -F '"' '/version/ {print $2}')
  fi

  echo_colorful_version 'java' "$java_version"
}

function get_rust_info()
{
  local rust_version='✘>﹏<✘'
  if command -v rustc &> /dev/null; then
    rust_version=$(rustc --version | cut -d' ' -f2)
  fi

  echo_colorful_version 'rust' "$rust_version"
}

function get_nodejs_info()
{
  local node_version='✘>﹏<✘'
  if command -v node &> /dev/null; then
    node_version=$(node --version | cut -d' ' -f2)
    node_version=${node_version:1}
  fi

  echo_colorful_version 'node.js' "$node_version"
}

function get_npm_info()
{
  local npm_version='✘>﹏<✘'
  if command -v npm &> /dev/null; then
    npm_version=$(npm --version)
  fi
  echo_colorful_version 'npm' "$npm_version"
}

function dev_tools_info()
{
  get_git_info
  get_c_info
  get_python_info
  get_go_info
  get_java_info
  get_rust_info
  get_nodejs_info
  get_npm_info
}
