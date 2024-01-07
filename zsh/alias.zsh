# 单引号包裹的字符串，不会进行变量替换，会进行别名替换

alias reload='source ~/.zshrc'
alias restart='exec zsh -l'             # 重启zsh
alias fpath_print='echo ${(j:\n:)fpath}' # 将fpath数组中的元素用\n连接
alias path_print='echo ${(j:\n:)path}' 
alias zshrc='${EDITOR:-vim} "${ZDOTDIR:-$HOME}"/.zshrc'
alias zshbench='for i in {1..10}; do /usr/bin/time zsh -lic exit; done'
alias zshdot='cd ${ZSH_DOT_DIR:-~}'
zman()
{
  if [[ -n $1 ]]; then
    PAGER="less -g -s '+/"$1"'" man zshall
    echo "Search word: $1"
  else
    man zshall
  fi
}

alias sudo='sudo -H' # 重置环境变量
alias ..='cd ..'

alias mkdir='mkdir -pv' # 递归创建，打印创建的文件夹

# 启用以下命令的交互模式，发生冲突时，让用户确认后再执行操作
alias cp='cp -irpf' # 递归复制,保留旧的时间戳，强制覆盖
alias mv='mv -i'
alias rm='rm -I' # 删除多个文件或目录时，让用户确认

alias tarls='tar -tvf' # list verbose file, 查看tar文件的详细信息

alias pstop='watch "ps aux | sort -nrk 3,3 | head -n 5"'
alias e="$EDITOR"

alias make='make -j$(nproc)' # 执行nproc命令，获得cpu数量，然后并行make
alias cm='cmake -B./build -DCMAKE_EXPORT_COMPILE_COMMANDS=ON && make -C ./build'
alias cmr='cmake -B./build -DCMAKE_EXPORT_COMPILE_COMMANDS=ON && make -C ./build && echo "===== output =====" && ./build/$(cat CMakeLists.txt | grep add_executable | sed "s/\s*add_executable\s*(\s*//g" | cut -d " " -f 1)'

alias arch='uname -m' # 显示硬件架构

alias shred='shred -uz' # remove and zero, 删除文件，无法复原

# url encode/decode
alias urldecode='python3 -c "import sys, urllib.parse as ul; \
    print(ul.unquote_plus(sys.argv[1]))"'
alias urlencode='python3 -c "import sys, urllib.parse as ul; \
    print (ul.quote_plus(sys.argv[1]))"'
