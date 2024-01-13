autoload -U compaudit compinit
autoload -U compinit && compinit

export ZSH_DOT_DIR="$HOME/.config/zsh"
export ZSH_PLUGIN_DIR="$ZSH_DOT_DIR/plugins"

for file in $ZSH_DOT_DIR/*.zsh; do
  source $file
done

source $HOME/.config/shell_scripts/greeting.sh

plugin_repos=(
  zsh-users/zsh-syntax-highlighting
  zsh-users/zsh-autosuggestions
  zsh-users/zsh-history-substring-search
  zsh-users/zsh-completions
  Aloxaf/fzf-tab
)

plugin_load $plugin_repos

# export FZF_DEFAULT_OPTS=" \
# --color=bg+:#ccd0da,bg:#eff1f5,spinner:#dc8a78,hl:#d20f39 \
# --color=fg:#4c4f69,header:#d20f39,info:#8839ef,pointer:#dc8a78 \
# --color=marker:#dc8a78,fg+:#4c4f69,prompt:#8839ef,hl+:#d20f39"

#  must be added after compinit is called
eval "$(zoxide init zsh)"
