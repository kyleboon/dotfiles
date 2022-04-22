# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export HOSTNAME=$(hostname)

## GENERAL EXPORTS ############################################################################################################

export CLICOLOR="xterm-color"

export WORDS=/usr/share/dict/words

## GENERAL ############################################################################################################

alias dh='dirs -v'  # directory history

alias is_port_open='nc -z localhost'

function wait_for_8080() {
    echo "waiting for port 8080 to open up"
    while ! is_port_open 8080; do sleep 0.1; done;
}

# grep history
alias ghist='fc -l 0 | grep'

alias spwd='pwd | pbcopy'  # copy the current working directory to the clipboard
alias pwp='pwd -P'

# give it an url and it will see how long it takes to make 100 requests with 10 connections
alias absimple='ab -n 100 -c 10 -g gnuplot.tsv'

export VIM_EDITOR=mvim
alias v='$VIM_EDITOR'
alias vz='v $ZSHDIR'

alias agrep='alias | grep -i'

# copy the last command to your clipboard
alias clc='fc -ln -1 | pbcopy && echo $(pbpaste)'

# builtins don't have their own man page
alias manbi='man zshbuiltins'

alias myip="curl icanhazip.com"

alias curltime="curl -sL -w '   namelookup: %{time_namelookup}\n      connect: %{time_connect}\n   appconnect: %{time_appconnect}\n  pretransfer: %{time_pretransfer}\n     redirect: %{time_redirect}\nstarttransfer: %{time_starttransfer}\n        total: %{time_total}\n' "

alias httpcode='curl --write-out %{http_code} --head --silent --output /dev/null'

# global aliases
alias -g 21="2>&1"
alias -g G='| grep'
alias -g GI='| grep -i'
alias -g GV='| grep -v'
alias -g GE='| egrep'
alias -g PC="| pc"
alias -g XGI="| xargs grep -ni"
alias -g XG="| xargs grep -n"
alias -g L='| less'
alias -g PBC='| pbcopy'
alias -g X1="| xargs -L1"

alias -g ND='*(/om[1])' # newest directory
alias -g NF='*(.om[1])' # newest file

rot13 () { tr "[a-m][n-z][A-M][N-Z]" "[n-z][a-m][N-Z][A-M]" }

alias duc='du -sh *(/)'
alias duca='du -sh ./*'

## VERSION CONTROL ############################################################################################################

alias gs="git status"
alias grh="git reset --hard"
alias grs="git reset --soft"

alias gd="git diff"
alias gdt="git diff"
alias gds="git diff --stat"

alias gdth1="git difftool HEAD~1"
alias gdh1="git diff HEAD~1"
alias gdtom="git difftool origin/master"
alias gdom="git diff origin/master"

alias gcb="git branch | grep -v "master" | xargs git branch -D"

alias -g H1="HEAD~1"
alias -g OM="origin/master"

alias gw='nocorrect ./gradlew'

## Fuzzy Finder Auto Completion

if [[ -d "/opt/homebrew/opt/fzf/shell" ]]; then
  FZF_SHELL="/opt/homebrew/opt/fzf/shell"
else
  FZF_SHELL="/usr/local/opt/fzf/shell"
fi

if [[ -d "$FZF_SHELL" ]]; then
  export FZF_CTRL_R_OPTS="--min-height=20 --exact --preview 'echo {}' --preview-window down:3:wrap"
  export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow -g "!{.git,node_modules,build}/*" 2> /dev/null'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_CTRL_T_OPTS=$'--min-height=20 --preview \'[[ $(file --mime {}) =~ binary ]] && echo {} is a binary file ||
                  (bat --style=numbers --color=always {} ||
                    cat {}) 2> /dev/null | head -500
  \''


  source "${FZF_SHELL}/completion.zsh" 2> /dev/null
  source "${FZF_SHELL}/key-bindings.zsh"

  alias fzfp="fzf $FZF_CTRL_T_OPTS"
  alias -g F='| fzfp'
else
  echo "missing fzf: brew install fzf ripgrep bat"
fi

jqpath_cmd='
def path_str: [.[] | if (type == "string") then "." + . else "[" + (. | tostring) + "]" end] | add;

. as $orig |
  paths(scalars) as $paths |
  $paths |
  . as $path |
  $orig |
  [($path | path_str), "\u00a0", (getpath($path) | tostring)] |
  add
'

# pipe json in to use fzf to search through it for jq paths, uses a non-breaking space as an fzf column delimiter
alias jqpath="jq -rc '$jqpath_cmd' | cat <(echo $'PATH\u00a0VALUE') - | column -t -s $'\u00a0' | fzf +s -m --header-lines=1"

## Antibody ZSH Plugins

if command -v antibody >/dev/null 2>&1; then
  source <(antibody init)
  antibody bundle zsh-users/zsh-autosuggestions
  antibody bundle zsh-users/zsh-completions
  antibody bundle zsh-users/zsh-history-substring-search
  antibody bundle zsh-users/zsh-syntax-highlighting
  antibody bundle romkatv/powerlevel10k
else
  echo "antibody?"
  echo "brew install getantibody/tap/antibody"
fi

. "$HOME/bin/z.sh"

eval "$(direnv hook zsh)"

export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

# keep history file between sessions
DIRSTACKSIZE=15
HISTSIZE=50000
SAVEHIST=10000
HISTFILE=~/.history

#--- zsh options ---
#
setopt autopushd # turn cd into pushd for all situations
setopt APPEND_HISTORY
setopt AUTO_CD # cd if no matching command
setopt EXTENDED_HISTORY # saves timestamps on history
setopt EXTENDED_GLOB # globs #, ~ and ^
setopt PUSHDMINUS       # make using cd -3 go to the 3rd directory history (dh) directory instead of having to use + (the default)
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE # don't put commands starting with a space in history
setopt AUTO_PARAM_SLASH # adds slash at end of tabbed dirs
setopt CHECK_JOBS # check bg jobs on exit
setopt CORRECT # corrects spelling
setopt CORRECT_ALL # corrects spelling

setopt EXTENDED_HISTORY # timestamp the history + more
setopt GLOB_DOTS # find dotfiles easier
setopt HASH_CMDS # save cmd location to skip PATH lookup
setopt HIST_NO_STORE # don't save 'history' cmd in history
setopt HIST_IGNORE_DUPS # don't save duplicate entries in history
setopt INC_APPEND_HISTORY # append history as command are entered
setopt LIST_ROWS_FIRST # completion options left-to-right, top-to-bottom
setopt LIST_TYPES # show file types in list
setopt MARK_DIRS # adds slash to end of completed dirs
setopt NUMERIC_GLOB_SORT # sort numerically first, before alpha
setopt SHARE_HISTORY # share history between open shells

unsetopt beep

# zmodload zsh/complist
autoload -Uz compinit && compinit

# by default: export WORDCHARS='*?_-.[]~=/&;!#$%^(){}<>'
# we take out the slash, period, angle brackets, dash here.
export WORDCHARS='*?_[]~=&;!#$%^(){}'

# Completion
setopt auto_menu
setopt always_to_end
setopt complete_in_word
unsetopt flow_control
unsetopt menu_complete
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z-_}={A-Za-z_-}' 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion::complete:*' use-cache 1
zstyle ':completion::complete:*' cache-path $ZSH_CACHE_DIR
zstyle ':completion:*' list-colors ''
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'

# Other
setopt prompt_subst # adds support for command substitution

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

eval "$(pyenv init -)"

if command -v navi >/dev/null 2>&1; then
  source <(navi widget zsh)
fi

nice_val=20
  function _tnice-process() {
    proc_name=$1
    pid=$(ps -Af | grep -w "$proc_name" | grep -v grep | head -1 | awk '{print $2}')
    if [[ -z "$pid" ]]; then
      echo "process not found: $proc_name"
    else
      current_nice=$(ps -Afl -C $pid | awk '{print $11}' | grep -v NI | head -n 1)
      # Get current NICE value
      if [[ "$current_nice" != "$nice_val" ]]; then
        echo "'T-Nice'-ing $proc_name ($current_nice -> $nice_val)"
        sudo renice -n "$nice_val" -p $pid
        ps -Afl -C $pid
      else
        echo "$proc_name is already nice"
      fi
    fi
  }
  function tnice() {
    _tnice-process EPClassifier
    _tnice-process TaniumClient
    _tnice-process TaniumCX
    _tnice-process TaniumDetectEngine
    _tnice-process crowdstrike
    _tnice-process nessusd
    _tnice-process ZscalerService
    _tnice-process ZscalerTunnel
  }
