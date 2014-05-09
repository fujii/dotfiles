##  -*- shell-script -*-

export LESS='-i -z-3 -R'
export LS_COLORS="di=1;36:ln=01;32:ex=1:"

HISTFILE=$HOME/.zsh_history
HISTSIZE=1000
SAVEHIST=1000
MAILCHECK=300
DIRSTACKSIZE=20
ZLS_COLORS=$LS_COLORS
WORDCHARS='*?~=!#$%^'

## Search path for the cd command
#cdpath=(.. ~ )
# Filename suffixes to ignore during completion
fignore=(.o .~ .old .pro )
## Hosts to use for completion
#hosts=(`hostname` ftp.math.gatech.edu prep.ai.mit.edu wuarchive.wustl.edu)

zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

alias mv='nocorrect mv'
alias cp='nocorrect cp'
alias rm='nocorrect rm'
alias mkdir='nocorrect mkdir'
alias dpkg='nocorrect dpkg'

alias s='cd ..'
alias p='cd -'
alias j=jobs
alias h=history

alias ls='ls -F --color=auto'
alias ll='ls -l'
alias la='ls -a'
alias lla='ls -la'

alias apt-get='sudo apt-get'

alias -g L="|less"
alias -g M="|more"
alias -g H="|head"
alias -g T="|tail"
alias -g G="|grep"
alias -g EG="|egrep"
alias -g S="|sort"
alias -g N="&>/dev/null&"
alias -g O="2>&1"

setopt correct
#setopt autolist
#setopt longlistjobs
#setopt noclobber
setopt extendedglob
#setopt numericglobsort
setopt histignorealldups
setopt histignorespace
#setopt noautoparamslash 
setopt nohup
setopt autopushd  pushdsilent pushdignoredups
setopt printeightbit
setopt nopromptcr
setopt sharehistory

#
autoload -U compinit
compinit -u

# ignore case
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# tty
stty stop undef start undef

bindkey -e               # emacs key bindings
bindkey "^W" kill-region

bindkey "^[[2~" yank
bindkey "^[[3~" delete-char
bindkey "^[[1~" beginning-of-line
bindkey "^[[4~" end-of-line
bindkey "^[[5~" up-line-or-history
bindkey "^[[6~" down-line-or-history

## Emacs
if test "$EMACS" = t -o "$TERM" = dumb
then
    PS1="%n@%m %(!.#.$) "
    RPS1=
    alias ls='ls -F'
    unsetopt zle
else
    PS1="%n@%m %(!.#.$) "
    PS1=$'%{\e[1m%}'$PS1$'%{\e[0m%}'
    RPS1=' %~'
fi
