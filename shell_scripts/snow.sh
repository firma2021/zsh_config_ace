#!/bin/bash

# 在终端中，原点在左上角，x轴正方向是向右，y中正方向是向下。
set -euo pipefail

TERMINAL_LINES=$(tput lines)
COLUMNS=$(tput cols)

declare -A snowflakes # snowflakes[3]=5, 表示第 3 列上的雪花当前位于第 5 行
declare -A lastflakes # 上一次雪花的位置111

readonly ORIGIN='\033[1;1H' # 将光标移动到原点(0, 0)

function set_cursor_position()
{
  printf "\033[%s;%sH $ORIGIN" "$1" "$2"
}
# 移动雪花
# 参数：雪花的列号
function move_snowflake()
{
  i="$1"

  # 如果雪花不存在或者移动到终端底部，将其位置重置为(0, 0),使其重新从顶部下落
  # 否则，将光标移动到雪花的位置，输出空格，以清除旧的雪花
  if [ "${snowflakes[$i]-}" = "" ] || [ "${snowflakes[$i]}" = "$TERMINAL_LINES" ]; then
    snowflakes[$i]=0
  else
    if [ "${lastflakes[$i]}" != "" ]; then
      printf "\033[%s;%sH $ORIGIN " "${lastflakes[$i]}" "$i"
    fi
  fi

  # 打印新的雪花
  printf "\033[%s;%sH\u274$(((RANDOM % 6) + 3))$ORIGIN" "${snowflakes[$i]}" "$i"

  lastflakes[$i]=${snowflakes[$i]}
  snowflakes[$i]=$((${snowflakes[$i]} + 1))
}

clear

while true; do
  column_index=$((RANDOM % COLUMNS))

  move_snowflake $column_index

  # 遍历所有的列，将雪花移动到下一行
  for x in "${!lastflakes[@]}"; do
    move_snowflake "$x"
  done

  sleep 0.1
done
