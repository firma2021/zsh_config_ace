#! /bin/bash

# 打印pacman常用命令小抄,展示常用命令及其描述
# 通过遍历命令和描述的关联数组来输出
# 使用颜色和对齐格式化输出,提高可读性

function print_pacman_cheatsheet
{
  local -A commands

  commands=(
    ["sudo pacman -Syu"]="同步包数据库，更新包 (sync upgrade)"
    ["sudo pacman -Syyu"]="刷新包数据库，同步包数据库，更新包 (sync refresh upgrade)"
    ["sudo pacman -Rns"]="移除包和它的依赖、它的配置文件 (remove unneeded settings)"
    ["sudo pacman -U"]="从本地文件安装包 (upgrade)"
    ["pacman -Ss"]="在包数据库中搜索包 (synchronize search)"
    ["pacman -Si"]="显示包数据库中，包的信息 (query information)"
    ["sudo pacman -Sc"]="删除旧的包和缓存 (synchronize clean)"
    ["sudo pacman -Scc"]="删除所有缓存 (synchronize clean cache)"
    ["pacman -Qi"]="显示本地包的信息 (query installed)"
    ["pacman -Qe"]="查询用户主动安装的包 (query explicit)；加上q参数后，不显示包的版本等信息"
    ["pacman -Qs"]="查找本地包 (query search)"
    ["pacman -Qm"]="查找从aur安装的包 (query foreign)"
    ["sudo pacman -Qdt"]="列出所有孤儿包 (query dangling topologies)"
    ['sudo pacman -Rs $(pacman -Qtdq)']="删除所有孤儿包"
    ["pacman -Ql"]="显示已安装包的文件列表 (query list)"
    ["pacman -Qo"]="查询指定文件或目录属于哪个已安装包 (query own)"
    ["/etc/pacman.conf"]="pacman配置文件目录"
  )

  local max_command_length=0
  for command in "${!commands[@]}"; do                 # 获取关联数组的所有key，遍历之
    if [[ ${#command} -gt $max_command_length ]]; then # 获取key的长度
      max_command_length=${#command}
    fi
  done

  local magenta='\e[1;35m'
  local reset='\e[0m'
  local green='\e[1;32m'
  for command in "${!commands[@]}"; do
    # %-*s 中，-表示左对齐
    # %*s类似于%10s，只不过宽度并不是固定值10,而是由参数决定
    printf "$magenta %-*s \t $green %s $reset \n" "$max_command_length" "$command" "${commands[$command]}"
  done
}

print_pacman_cheatsheet
