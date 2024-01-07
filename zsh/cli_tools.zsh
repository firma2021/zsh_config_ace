#eza
# -o输出8进制的文件权限
alias ls='eza --icons'
alias ll='ls --oneline --long -o --header --time-style long-iso --sort extension --hyperlink'
alias lg='ll --git'
alias la='ll --all'
alias lt='ll --tree'

# bat
config_dir=$(bat --config-dir)
if [ ! -d "$config_dir/themes" ]; then
  git clone https://github.com/catppuccin/bat.git "$config_dir/themes"
  bat cache --build
  bat --generate-config-file
  echo '--theme="Catppuccin-latte"' >> "$config_dir/config"
  echo '--paging=never' >> "$config_dir/config"
fi

alias cat='bat -n'
# export MANPAGER="sh -c 'col -bx | bat -l man -p'"

# dust
alias du='dust'

# duf
alias df='duf --theme light --all'

# gping
alias ping='gping'

# procs
alias proc='procs'

# 显示匹配文本的行号、列号
# 将搜索模式作为字符串而不是正则表达式进行匹配
# 递归地跟踪符号链接
# 搜索所有文件，排除以 .git/ 开头的路径
alias rg_all='rg --column --line-number --fixed-strings --ignore-case --follow --hidden --glob "!.git/*" --color "always"'
