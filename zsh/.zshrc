# load Zit config
source "${HOME}/.zitrc"

# try to correct the spelling of commands
setopt correct

# pager
export EDITOR="nvim"
export VISUAL="nvim"
export PAGER="less"

# powerlevel9k
export POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir vcs)
export POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status root_indicator background_jobs)
export POWERLEVEL9K_PROMPT_ON_NEWLINE=true

# fzf
FZF_KEY_BINDINGS="/usr/share/fzf/key-bindings.zsh"
if [[ -s "${FZF_KEY_BINDINGS}" ]]; then
  source "${FZF_KEY_BINDINGS}"
  export FZF_CTRL_T_COMMAND="find . -not -path '*/\.*' -printf '%P\n'"
  export FZF_ALT_C_COMMAND="find . -not -path '*/\.*' -type d -printf '%P\n'"
fi

# zsh-autosuggestions
bindkey '^ ' autosuggest-accept
zstyle ':bracketed-paste-magic' active-widgets '.self-*'

# edit current line
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^v' edit-command-line

# aliases
alias gk="gitk &!"
alias http-server="python3 -m http.server"
alias nvimdiff="nvim -d"
alias ssh="TERM=xterm-256color ssh"
alias ln-clean-up="find -L . -name . -o -type d -prune -o -type l -exec rm {} +"

open() { xdg-open "${@}" &> /dev/null &! }

# source contents from ~/.zshrc.d
for file in ${HOME}/.zshrc.d/*.zsh; do
  source ${file}
done
