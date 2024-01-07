# 定义关联数组：信号值和信号名
declare -A signals=(
  [1]="SIGHUP"
  [2]="SIGINT"
  [3]="SIGQUIT"
  [4]="SIGILL"
  [5]="SIGTRAP"
  [6]="SIGABRT"
  [7]="SIGBUS"
  [8]="SIGFPE"
  [9]="SIGKILL"
  [10]="SIGUSR1"
  [11]="SIGSEGV"
  [12]="SIGUSR2"
  [13]="SIGPIPE"
  [14]="SIGALRM"
  [15]="SIGTERM"
  [16]="SIGSTKFLT"
  [17]="SIGCHLD"
  [18]="SIGCONT"
  [19]="SIGSTOP"
  [20]="SIGTSTP"
  [21]="SIGTTIN"
  [22]="SIGTTOU"
  [23]="SIGURG"
  [24]="SIGXCPU"
  [25]="SIGXFSZ"
  [26]="SIGVTALRM"
  [27]="SIGPROF"
  [28]="SIGWINCH"
  [29]="SIGIO"
  [30]="SIGPWR"
  [31]="SIGSYS"
)

autoload -U colors && colors

function check_background_jobs()
{
  local bj_jobs
  bj_jobs=$(jobs | tail -n 1)
  if [[ $bj_jobs == "" ]]; then
    bg_jobs_info=""
  else
    bg_jobs_info="%F{green}&%f"
  fi
}

function check_last_cmd_exit_code()
{
  last_cmd_exit_info="%F{magenta}%{√%}%f"

  if [[ "$last_cmd_exit_code" -ne 0 ]]; then
    last_cmd_exit_info="%F{red}[$last_cmd_exit_code]%f"
    if [ "$last_cmd_exit_code" -gt 128 ] && [ "$last_cmd_exit_code" -lt 160 ]; then
      local signal_number=$((last_cmd_exit_code - 128))
      local signal_name="${signals[$signal_number]}"
      if [[ -n $signal_name ]]; then
        last_cmd_exit_info+=": %F{red}$signal_name($signal_number)%f"
      fi
    fi
  fi
}

function calculate_cmd_exec_elapsed_time()
{
  cmd_exec_elapsed_time=""
  if [ "$cmd_exec_begin_time" ]; then
    cmd_exec_end_time=$(print -P %D{%s%3.})
    local d_ms=$((cmd_exec_end_time - cmd_exec_begin_time))
    local d_s=$((d_ms / 1000))
    local ms=$((d_ms % 1000))
    local s=$((d_s % 60))
    local m=$(((d_s / 60) % 60))
    local h=$((d_s / 3600))

    if ((h > 0)); then
      cmd_exec_elapsed_time=${h}h${m}m${s}s
    elif ((m > 0)); then
      cmd_exec_elapsed_time=${m}m${s}.$(printf $((ms / 100)))s # 1m12.3s
    elif ((s > 9)); then
      cmd_exec_elapsed_time=${s}.$(printf %02d $((ms / 10)))s # 12.34s
    elif ((s > 0)); then
      cmd_exec_elapsed_time=${s}.$(printf %03d $ms)s # 1.234s
    else
      cmd_exec_elapsed_time=${ms}ms
    fi
    cmd_exec_elapsed_time="%B%F{yellow}${cmd_exec_elapsed_time} %f%b"
    unset cmd_exec_begin_time
  fi
}

# 执行命令前调用
function preexec()
{
  cmd_exec_begin_time=$(print -P %D{%s%3.})
}

# 命令执行完毕后，生成提示符前调用
function precmd()
{
  last_cmd_exit_code=$?
  check_last_cmd_exit_code
  calculate_cmd_exec_elapsed_time
  
  check_background_jobs
}

setopt prompt_subst

RPROMPT='${cmd_exec_elapsed_time} ${bg_jobs_info} ${last_cmd_exit_info} %F{blue}%*%f '
PROMPT='%F{green}%(5~|%-1~/.../%3~|%4~)%f %F{magenta}%(!.#.>)%f '

myprompt="%B%F{cyan}%n@%m:%d/ %h%(!.#.>)%f%b"
