setopt HIST_IGNORE_ALL_DUPS # 不记录所有重复的命令
setopt HIST_IGNORE_DUPS # 不记录连续重复的命令
setopt HIST_VERIFY # 通过!number执行历史命令时，不直接执行，需要再按个回车才能执行
setopt SHARE_HISTORY
setopt HIST_REDUCE_BLANKS
HISTORY_IGNORE="(ls|cd|pwd|zsh|exit|cd ..)"

HISTSIZE=500 # 内存中保存的最大记录数
SAVEHIST=1000 # 文件中保存的最大记录数
HISTFILE="${HOME}/.zsh_history"


setopt interactivecomments # 允许在交互模式下使用注释
