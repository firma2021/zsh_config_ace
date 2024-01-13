
function plugin_load
{
  local repo plugdir initfile initfiles=()
  : ${ZSH_PLUGIN_DIR:=${ZSH_DOT_DIR:-~/.config/zsh}/plugins}
  for repo in $@; do
    plugdir=$ZSH_PLUGIN_DIR/${repo:t}
    initfile=$plugdir/${repo:t}.plugin.zsh
    if [[ ! -d $plugdir ]]; then
      echo "将 $repo... 克隆到 $plugdir"
      git clone -q --depth 1 --recursive --shallow-submodules https://github.com/$repo $plugdir # 静默克隆，只克隆最近的一次提交，递归地克隆子模块，只克隆子模块的最近一次提交
    fi
    if [[ ! -e $initfile ]]; then
      initfiles=($plugdir/*.{plugin.zsh,zsh-theme,zsh,sh}(N))
      (( $#initfiles )) || { echo >&2 "在 $repo 中找不到zsh文件" && continue }
      ln -sf $initfiles[1] $initfile # 创建符号链接文件，下次执行时不需要再搜索文件
    fi
    fpath+=$plugdir
    (( $+functions[zsh-defer] )) && zsh-defer . $initfile || . $initfile
  done
}

function plugin_update
{
  ZSH_PLUGIN_DIR=${ZSH_PLUGIN_DIR:-$HOME/.config/zsh/plugins}
  for d in $ZSH_PLUGIN_DIR/*/.git(/); do
    echo "更新 ${d:h:t}..."
    command git -C "${d:h}" pull --ff --recurse-submodules --depth 1 --rebase --autostash
  done
}

function plugin_list
{
	for d in $ZSH_PLUGIN_DIR/*/.git; do
    git -C "${d:h}" remote get-url origin
    done
}

function plugin_remove
{
    echo "删除插件: $1"
    rm -rfi $ZSH_PLUGIN_DIR/$1
}
