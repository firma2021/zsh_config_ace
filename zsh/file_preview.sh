# 如果$1是test.cpp， 得到text/x-c++
mime_type=$(file -b -L --mime-type "$1") # brief, follow symbolic links.

# 这是参数扩展语法。
# **删除匹配的后缀部分，/*匹配/后的任意字符序列。
# 即从变量 $mime_type 的末尾开始，删除最长的匹配模式 /*
# 效果为提取出text
file_type=${mime_type%%/*}

echo "$1 : $mime_type"

if [ -d "$1" ]; then
  eza --icons --oneline --long -o --header -all --time-style long-iso --sort extension --hyperlink --color=always "$1"
elif [ "$mime_type" = "text/html" ]; then
  w3m -dump "$1"
elif [ "$mime_type" = "application/zip" ]; then
  unzip -l "$1"
elif [ "$mime_type" = "application/x-pie-executable" ]; then
  objdump -D "$1" | bat -n --language=asm --color=always # --disassemble-all
elif [ "$file_type" = "text" ]; then
  bat -n --color=always "$1" # 如果不指定--color=always，则不会高亮显示
elif [ "$file_type" = "image" ]; then
  viu -w 16 -h 10 "$1"
else
  bat -n --color=always "$1"
fi
