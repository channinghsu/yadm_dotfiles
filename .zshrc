# ============================================================================
# Powerlevel10k Instant Prompt (必须在最前面)
# ============================================================================
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ============================================================================
# Zsh 基础选项
# ============================================================================
setopt HIST_IGNORE_DUPS HIST_IGNORE_SPACE HIST_FIND_NO_DUPS HIST_REDUCE_BLANKS
setopt SHARE_HISTORY APPEND_HISTORY INC_APPEND_HISTORY

HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=50000

[[ ! -f $HISTFILE ]] && { touch $HISTFILE && chmod 600 $HISTFILE }

# ============================================================================
# PATH 环境变量
# ============================================================================
export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:/opt/homebrew/opt/llvm/bin:/opt/homebrew/opt/curl/bin:/opt/homebrew/opt/openjdk/bin:/opt/homebrew/opt/qt@5/bin:/opt/homebrew/opt/node@22/bin:$PATH"

# ============================================================================
# 编译标志
# ============================================================================
export LDFLAGS="-L/opt/homebrew/opt/llvm/lib"
export CPPFLAGS="-I/opt/homebrew/opt/llvm/include"

# ============================================================================
# 代理配置
# ============================================================================
function proxy_on() {
  export https_proxy="http://127.0.0.1:7890"
  export http_proxy="http://127.0.0.1:7890"
  export all_proxy="socks5://127.0.0.1:7890"
}

function proxy_off() {
  unset https_proxy http_proxy all_proxy
}

proxy_on

# ============================================================================
# Vi 模式配置
# ============================================================================
bindkey -v
bindkey -M viins 'jk' vi-cmd-mode

# ============================================================================
# 键绑定
# ============================================================================
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward

# ============================================================================
# Conda 延迟加载
# ============================================================================
__conda_lazy_load() {
  unset -f conda
  __conda_setup="$('/Users/channinghsu/opt/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
  if [ $? -eq 0 ]; then
    eval "$__conda_setup"
  else
    if [ -f "/Users/channinghsu/opt/anaconda3/etc/profile.d/conda.sh" ]; then
      . "/Users/channinghsu/opt/anaconda3/etc/profile.d/conda.sh"
    else
      export PATH="/Users/channinghsu/opt/anaconda3/bin:$PATH"
    fi
  fi
  unset __conda_setup
}

conda() { __conda_lazy_load && conda "$@"; }

# ============================================================================
# NVM 延迟加载
# ============================================================================
export NVM_DIR="$HOME/.nvm"

nvm_lazy_load() {
  unset -f nvm node npm nvim
  [[ -s "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh"
  nvm use 22 &>/dev/null
}

nvm() { nvm_lazy_load && nvm "$@"; }
node() { nvm_lazy_load && node "$@"; }
npm()  { nvm_lazy_load && npm "$@"; }

# ============================================================================
# 工具初始化
# ============================================================================
eval "$(zoxide init zsh)"

# ============================================================================
# 自定义函数
# ============================================================================

if [[ -n "$TMUX" ]]; then
  function zle-keymap-select {
    if [[ $KEYMAP == vicmd ]]; then
      printf '\033[2 q'
    else
      printf '\033[6 q'
    fi
  }
  zle -N zle-keymap-select
  zle-line-init() {
    zle-keymap-select
  }
  zle -N zle-line-init
fi

yy() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(<"$tmp")" && [[ -n "$cwd" && "$cwd" != "$PWD" ]]; then
    cd -- "$cwd"
  fi
  rm -f -- "$tmp"
}

# ============================================================================
# 别名配置
# ============================================================================

alias gss='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gpl='git pull'
alias gl='git log --oneline --graph --decorate'
alias gd='git diff'
alias gb='git branch'
alias gco='git checkout'

alias n='nvim'
alias t='tmux -f ~/.config/tmux.conf'
alias c='clear'
alias b='btop'
alias m='musicfox'
alias f='fastfetch'
alias y='yadm'
alias ys='yadm status'
alias nc='z nvim && nvim'

alias ca='conda activate'
alias cda='conda deactivate'
alias cenv='conda env list'

alias ls="eza -s Name --group-directories-first --color=always"
alias la="eza -a -s Name --group-directories-first --color=always"
alias lt="eza -T -s Name --group-directories-first --color=always"
alias ll="eza -lag -s Name --group-directories-first --time-style='+%Y-%m-%d %H:%M:%S' --color=always"
alias lg="eza -lag -s Name --group-directories-first --time-style='+%Y-%m-%d %H:%M:%S' --git --color=always"

alias inv='nvim $(fzf -m --preview="bat --style=numbers,changes --color=always {}")'

# ============================================================================
# 插件加载（放在最后）
# ============================================================================
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source "$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

# ============================================================================
# Powerlevel10k 主题
# ============================================================================
source /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh
