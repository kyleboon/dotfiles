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

alias is_port_open='nc -z localhost'

alias spwd='pwd | pbcopy'  # copy the current working directory to the clipboard
alias pwp='pwd -P'


export VIM_EDITOR=nvim
alias v='$VIM_EDITOR'
alias vz='v $ZSHDIR'

alias agrep='alias | grep -i'

# copy the last command to your clipboard
alias clc='fc -ln -1 | pbcopy && echo $(pbpaste)'
alias myip="curl icanhazip.com"

alias curltime="curl -sL -w '   namelookup: %{time_namelookup}\n      connect: %{time_connect}\n   appconnect: %{time_appconnect}\n  pretransfer: %{time_pretransfer}\n     redirect: %{time_redirect}\nstarttransfer: %{time_starttransfer}\n        total: %{time_total}\n' "

alias httpcode='curl --write-out %{http_code} --head --silent --output /dev/null'

rot13 () { tr "[a-m][n-z][A-M][N-Z]" "[n-z][a-m][N-Z][A-M]" }

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
alias uncommitted="find . -type d -name '.git' -execdir sh -c 'git status --porcelain | grep -q . && echo "${PWD%/.git}"' \;"

eval "$(/opt/homebrew/bin/brew shellenv)"

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
eval "$(rbenv init - zsh)"

if command -v navi >/dev/null 2>&1; then
  source <(navi widget zsh)
fi

alias mamba="docker pull --platform linux/amd64 wayfair/mamba:latest && docker run --platform linux/amd64 -it wayfair/mamba:latest"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/kb512g/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/kb512g/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/kb512g/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/kb512g/google-cloud-sdk/completion.zsh.inc'; fi

eval "$(mcfly init zsh)"
export MCFLY_LIGHT=TRUE
export BUILDKIT_NO_CLIENT_TOKEN=1
