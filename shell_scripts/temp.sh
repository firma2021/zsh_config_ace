#!/bin/bash

# 保存终端设置
old_settings=$(stty -g)

# 设置终端以非规范模式和无回显模式读取输入
stty -icanon -echo

# 读取用户输入的单个字符
read -n 1 key

# 恢复终端设置
stty "$old_settings"

# 根据用户输入的字符判断方向
case "$key" in
  "A")
    echo "用户按下了上箭头键"
    ;;
  "B")
    echo "用户按下了下箭头键"
    ;;
  "C")
    echo "用户按下了右箭头键"
    ;;
  "D")
    echo "用户按下了左箭头键"
    ;;
  *)
    echo "用户按下了其他键"
    ;;
esac
