#!/bin/bash

# 随机生成雪花字符
snowflakes=(✩ ❆ ❅ ❄ ☃ ❅ ❆ ✩)

while :
do 
  # 随机打印40个雪花字符
  for ((i=0; i<40; i++)); do
    echo -en "\e[${RANDOM}%255;${RANDOM}%255m${snowflakes[$RANDOM % ${#snowflakes[@]}]} "
  done
  # 清空当前行
  echo -ne "\e[0m\r"

  # 小睡一下
  sleep 0.2
done

