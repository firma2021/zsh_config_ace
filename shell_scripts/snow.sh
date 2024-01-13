#!/bin/bash

# 在终端中，原点在左上角，x轴正方向是向右，y中正方向是向下。
set -euo pipefail

generate_random_color()
{
  echo -n -e "\e[1;3$((RANDOM % 7 + 1))m"
}

snow_flakes=("\u2743" "\u2744" "\u2745" "\u2746" "\u2747" "\u2748" "\u2729")

generate_random_flake()
{
  random_index=$((RANDOM % ${#snow_flakes[@]}))
  random_snowflake=${snow_flakes[$random_index]}
  echo -n -e "$random_snowflake"
}

handle_terminal_resize()
{
  clear
  generate_random_color
  echo '不要拽人家啦 ✘>﹏<✘'
  sleep 2s
  clear
  terminal_rows=$(tput lines)
  terminal_columns=$(tput cols)
}
trap handle_terminal_resize SIGWINCH

cleanup()
{
  clear

  generate_random_color
  echo -e "愿我们永远纯洁如雪 ✘╹◡╹✘"
  echo -e "May we always be as pure as snow."

  echo -e "\033[0m"   # 重置颜色y
  echo -e "\033[?25h" # 显示光标
}

init_display_process()
{
  trap cleanup EXIT

  clear
  terminal_rows=$(tput lines)
  terminal_columns=$(tput cols)
}

init_io_process()
{
  echo -e "\033[?25l" # 隐藏光标
}

declare -A snowflakes # snowflakes[3]=5, 表示第 3 列上的雪花当前位于第 5 行
declare -A lastflakes # 上一次雪花的位置111

function set_cursor_position()
{
  printf "\033[%s;%sH" "$1" "$2"
}

# 移动由参数指定的列上的雪花
function move_snowflake()
{
  i="$1"

  # 如果雪花不存在或者移动到终端底部，将其位置重置为(0, 0),使其重新从顶部下落
  # 否则，将光标移动到雪花的位置，输出空格，以清除旧的雪花
  if [ "${snowflakes[$i]-}" = "" ] || [ "${snowflakes[$i]}" = "$terminal_rows" ]; then
    snowflakes[$i]=0
  else
    if [ "${lastflakes[$i]}" != "" ]; then
      set_cursor_position "${lastflakes[$i]}" "$i" # 将光标移动到旧雪花的位置
      echo -n " "                                  # 输出空白，以清除旧的雪花
    fi
  fi

  # 打印新的雪花
  generate_random_color
  set_cursor_position "${snowflakes[$i]}" "$i"
  #   echo -n -e "\u274$((RANDOM % 6 + 3))"
  generate_random_flake

  lastflakes[$i]=${snowflakes[$i]}
  snowflakes[$i]=$((${snowflakes[$i]} + 1))
}

snow_loop()
{
  init_display_process

  while true; do
    column_index=$((RANDOM % terminal_columns))

    move_snowflake $column_index

    # 遍历所有的列，将雪花移动到下一行
    for x in "${!lastflakes[@]}"; do
      move_snowflake "$x"
    done

    sleep 0.1
  done
}

read_input()
{
  local old_settings=$(stty -g)
  stty -icanon -echo
  while True; do
    echo ""
  done
  bg_pid=$1

  stty "$old_settings" # 恢复终端设置
}

VERSION="1.0.0"

if [[ $1 == "--version" || $1 == "-v" ]]; then
  script_name="${0##*[\\/]}"
  script_name="${script_name%.sh}"
  echo "$script_name Version: $VERSION"
  exit 0
elif [[ $1 == "--show" ]]; then
  snow_loop
else
  echo "$0"
  bash "$0" --show & # 创建显示进程
  echo "$!"
  read_input $! # 当前进程接收用户的输入
fi
