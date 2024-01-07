ulimit -c unlimited # 允许生成core文件
export DISABLE_DEVICONS=false # 启用devicons图标
REPORTTIME=3
umask 022 # 022是umask的默认值。创建新文件或目录时，所有者具有读写权限，而所属组和其他用户只有读权限

setopt COMPLETE_ALIASES