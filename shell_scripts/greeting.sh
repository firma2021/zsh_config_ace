#!/bin/bash

function greeting()
{
  local normal='\033[0m'
  local green='\033[1;32m'
  local cyan='\033[1;36m'
  local yellow='\033[1;33m'
  local magenta='\033[1;35m'

  local hour=$(date +%H)
  hour=${hour#0} # 去除前导0
  local greeting
  if [[ $hour -lt 6 ]]; then
    greeting='快去睡觉,'
  elif [[ $hour -lt 9 ]]; then
    greeting='早上好,'
  elif [[ $hour -lt 12 ]]; then
    greeting='上午好,'
  elif [[ $hour -lt 14 ]]; then
    greeting='中午好,'
  elif [[ $hour -lt 18 ]]; then
    greeting='下午好,'
  else
    greeting='晚上好,'
  fi
  echo -e "               " "$green" "$greeting $USER !" "今天也要加油哦 ✘╹◡╹✘" "$normal" # -e的作用是启用转义字符
  echo -e "$cyan" "如果你正处于低潮期，正好可以静下心来思考呢！你要坚持读书、锻炼，厚积薄发哦！"
  local cur_time=$(date +"%Y-%m-%d %H:%M:%S %A")
  echo -e "                " "$yellow" "现在是" "$cur_time" "$normal"

  echo -e "     " "$magenta" "$(lsb_release -is) $(uname -r) 已经运行了" "$(uptime -p | cut -d' ' -f 2-)" "$normal"

  echo ""
}

greeting
