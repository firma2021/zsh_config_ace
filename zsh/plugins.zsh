# 克隆一个插件的仓库，并加载它的初始化文件
function load_plugin
{
  local repo plugdir initfile initfiles=()
  
  # 如果没有定义ZPLUGINDIR环境变量，则将其设置为默认值~/.config/zsh/plugins
  : ${ZSH_PLUGIN_DIR:=${ZSH_DOT_DIR:-~/.config/zsh}/plugins}
  for repo in $@; do
    plugdir=$ZSH_PLUGIN_DIR/${repo:t} # ${repo:t}从文件路径中提取文件名
    initfile=$plugdir/${repo:t}.plugin.zsh # ${repo:t}从文件名中提取没有后缀的文件名

    # 检查插件目录是否存在，如果不存在，则克隆插件的代码库到该目录
    if [[ ! -d $plugdir ]]; then
      echo "正在克隆 $repo..."
      git clone -q --depth 1 --recursive --shallow-submodules \
        https://github.com/$repo $plugdir
    fi

    # 检查插件的初始化文件是否存在，如果不存在，则查找插件目录中的所有初始化文件，并选择第一个文件作为插件的初始化文件
    if [[ ! -e $initfile ]]; then
      initfiles=($plugdir/*.{plugin.zsh,zsh-theme,zsh,sh}(N))
      (( $#initfiles )) || { echo >&2 "找不到初始化文件 '$repo'." && continue }
      ln -sf $initfiles[1] $initfile
    fi

    # 将插件目录添加到fpath中，以便在搜索函数时能够找到插件
    fpath+=$plugdir

    # 如果存在zsh-defer函数，则使用它来延迟加载插件的初始化文件，否则直接加载初始化文件
    (( $+functions[zsh-defer] )) && zsh-defer . $initfile || . $initfile
  done
}

function update_plugin
{
  ZSH_PLUGIN_DIR=${ZSH_PLUGIN_DIR:-$HOME/.config/zsh/plugins}
  for d in $ZSH_PLUGIN_DIR/*/.git(/); do
    echo "Updating ${d:h:t}..."
    command git -C "${d:h}" pull --ff --recurse-submodules --depth 1 --rebase --autostash
  done
}

function list_plugin
{
	for d in $ZSH_PLUGIN_DIR/*/.git; do
	  git -C "${d:h}" remote get-url origin
	done
}
