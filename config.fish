set fish_greeting

alias ls="exa -al --icons --color=always"
alias vim="nvim"
alias tmux="tmux -u"


# Starship setup
starship init fish | source

# Zoxide
zoxide init fish | source
