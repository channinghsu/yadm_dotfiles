# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# zmodload zsh/zprof
# export PATH=$PATH:/Users/channinghsu/.npm-global/lib/node_modules/hexo-cli/bin

# export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.aliyun.com/homebrew/homebrew-bottles
export PATH="/usr/local/opt/llvm/bin:$PATH"
plugins=(git)

function yy() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

# eval "$(starship init zsh)"
eval "$(zoxide init zsh)"
# NVM 配置
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
# 自动使用默认版本
nvm use default &> /dev/null

export https_proxy=http://127.0.0.1:7890 http_proxy=http://127.0.0.1:7890 all_proxy=socks5://127.0.0.1:7890
export PATH="/opt/homebrew/opt/curl/bin:$PATH"
export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"
export PATH="/opt/homebrew/opt/node@14/bin:$PATH"
export PATH="/opt/homebrew/opt/qt@5/bin:$PATH"
export LDFLAGS="-L/opt/homebrew/opt/llvm/lib"
export CPPFLAGS="-I/opt/homebrew/opt/llvm/include"
export PATH="/opt/homebrew/opt/llvm/bin:$PATH"

alias gss='git status'
alias n='nvim'
alias t='tmux -f ~/.config/tmux.conf'
alias c='clear'
alias b='btop'
alias m='musicfox'
alias f='fastfetch'
alias y='yadm'
alias ys='yadm status'

# alias tmux='tmux -f ~/.config/tmux.conf'

source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# eza
alias ls="eza -s Name --group-directories-first --color=always"
alias la="eza -s -a Name --group-directories-first --color=always"
alias lt="eza -T -s Name --group-directories-first --color=always"
alias ll="eza -lag -s Name --group-directories-first --time-style '+%Y-%m-%d %H:%M:%S' --color=always"
alias lg="eza -lag -s Name --group-directories-first --time-style '+%Y-%m-%d %H:%M:%S' --git --color=always"
alias inv='nvim $(fzf -m --preview="bat --style=numbers,changes --color=always {}")'

# completion using arrow keys (based on history)
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
# Check if the history file exists, if not, create it
if [[ ! -f $HISTFILE ]]; then
  touch $HISTFILE
  chmod 600 $HISTFILE
fi

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!

# __conda_setup="$('/Users/channinghsu/opt/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
# if [ $? -eq 0 ]; then
#     eval "$__conda_setup"
# else
#     if [ -f "/Users/channinghsu/opt/anaconda3/etc/profile.d/conda.sh" ]; then
#         . "/Users/channinghsu/opt/anaconda3/etc/profile.d/conda.sh"
#     else
#         export PATH="/Users/channinghsu/opt/anaconda3/bin:$PATH"
#     fi
# fi
# unset __conda_setup

# <<< conda initialize <<<
# zprof
source /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
