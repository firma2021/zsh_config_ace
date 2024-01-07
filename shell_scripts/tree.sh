#!/bin/bash

# 设置树的初始高度
TREE_HEIGHT=10
TRUNK_HEIGHT=2
TRUNK_WIDTH=3

# 设置树的初始位置
tree_position=0

# 绘制树的函数
draw_tree()
{
  local height=$1
  local spaces=$((TREE_HEIGHT - height))
  local stars=$((height * 2 - 1))

  # 打印空格
  for ((i = 0; i < spaces + tree_position; i++)); do
    printf " "
  done

  # 打印星号
  for ((i = 0; i < stars; i++)); do
    printf "*"
  done

  printf "\n"
}

# 绘制树干的函数
draw_trunk()
{
  local trunk_spaces=$((TREE_HEIGHT - TRUNK_HEIGHT + tree_position))
  local trunk_width=$TRUNK_WIDTH

  for ((i = 0; i < TRUNK_HEIGHT; i++)); do
    # 打印空格
    for ((j = 0; j < trunk_spaces; j++)); do
      printf " "
    done

    # 打印树干
    for ((j = 0; j < trunk_width; j++)); do
      printf "|"
    done

    printf "\n"
  done
}

# 处理键盘输入的函数
handle_input()
{
  local key

  # 读取单个字符输入
  IFS= read -rsn1 key

  case "$key" in
    # 按w键，树和树干高度等比例增加
    w)
      TREE_HEIGHT=$((TREE_HEIGHT + 1))
      TRUNK_HEIGHT=$((TRUNK_HEIGHT + 1))
      ;;
    # 按s键，树和树干高度等比例减小
    s)
      if ((TREE_HEIGHT > 1)); then
        TREE_HEIGHT=$((TREE_HEIGHT - 1))
        TRUNK_HEIGHT=$((TRUNK_HEIGHT - 1))
      fi
      ;;
    # 按a键，树向左移动
    a)
      tree_position=$((tree_position - 1))
      ;;
    # 按d键，树向右移动
    d)
      tree_position=$((tree_position + 1))
      ;;
    # 按q键，退出程序
    q)
      exit 0
      ;;
  esac
}

# 清屏
clear

# 无限循环，持续绘制圣诞树
while true; do
  # 清屏
  clear

  # 绘制圣诞树
  for ((i = 1; i <= TREE_HEIGHT; i++)); do
    draw_tree $i
  done

  # 绘制树干
  draw_trunk

  # 处理键盘输入
  handle_input
done
