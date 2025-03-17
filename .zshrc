# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH
#zmodload zsh/zprof

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git zsh-syntax-highlighting zsh-autosuggestions) 

#####################PERFORMANCE#########################
# Skip compaudit security checks and speed up compinit
# zstyle ':omz:plugins' disable:compinit yes
#zstyle ':omz:plugins:nvm' lazy yes

#autoload -Uz compinit
#if [[ -n ${ZDOTDIR}/.zcompdump(#qN.mh+24) ]]; then
#	compinit;
#else
#	compinit -C;
#fi;


# autoload -Uz compinit
# compinit -C -D
########################################################

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='nvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

alias pret="npx prettier --write ."
alias nrbd="npm install && npm run build && npm run start"
alias nrbdi="npm install && npm run build && npm run dev"
alias 0="xdg-open . && exit"
alias zload="source ~/.zshrc && bash ~/Repositories/personal/configs/dotfiles/commit.sh"
alias zconf="nano ~/.zshrc"
alias aconf="sudo nano $HOME/.config/alacritty/alacritty.toml"
alias repo="cd ~/Repositories && ls"
alias hist="history | less"
alias now="date +'%Y-%m-%d %H:%M:%S'"
alias tarup="tar -czvf"
alias untar="tar -xzvf"
alias npmglobal="npm list -g --depth 0"
alias fastpush="git add "updates" && git commit -m . && git push"
alias dockererase="docker ps -q | grep -q . && docker stop \$(docker ps -aq) && docker rm \$(docker ps -aq); docker images -q | grep -q . && docker rmi \$(docker images -q) -f; docker volume prune -f && docker network prune -f && docker system prune -af --volumes"
alias upgrade='sudo apt update && sudo apt upgrade -y --allow-downgrades && sudo apt dist-upgrade -y && sudo apt full-upgrade -y && sudo apt autoremove -y && sudo apt autoclean && sudo apt clean && sudo dpkg --configure -a && sudo apt install -f && sudo ubuntu-drivers autoinstall'
alias ff='fastfetch'

#Virtualbox
#alias govm1="ssh volks@127.0.0.1 -p 2222"
#alias vms="VBoxManage list runningvms"

###### Old nvm configs
#export NVM_DIR="$HOME/.nvm"
#[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
#[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

###### New nvm configs
#export NVM_DIR="$HOME/.nvm"
#[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" --no-use

#lazy loading Node from .nvmrc
#NODE_DEFAULT_PATH="${NVM_DIR}/versions/default/bin"
#PATH="${NODE_DEFAULT_PATH}:${PATH}"

#switchNode() {
#  local NODE_PATH TARGET_NODE_VERSION
#  if [ -f '.nvmrc' ]; then
#    TARGET_NODE_VERSION="$(nvm version $(cat .nvmrc))"
#    NODE_PATH="${NVM_DIR}/versions/node/${TARGET_NODE_VERSION}/bin"
#  else
#    TARGET_NODE_VERSION="$(nvm version default)"
#    NODE_PATH="${NODE_DEFAULT_PATH}"
#  fi
#
#  # Remove old Node.js PATH
#  PATH=$(echo $PATH | sed -e "s|${NVM_DIR}/versions/node/[^/]*/bin:||g")
#
#  # Add new NODE_PATH to PATH if =! version
#  if [ "${TARGET_NODE_VERSION}" != "$(nvm current)" ]; then
#    PATH="${NODE_PATH}:${PATH}"
#  fi
#}

# Add hook to automatically change version after change directory
#add-zsh-hook chpwd switchNode

#export PATH=/usr/local/go/bin:$PATH

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
#export SDKMAN_DIR="$HOME/.sdkman"
#[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
#
#export JAVA_HOME=$(sdk home java 21.0.4-jbr)
#export PATH=$JAVA_HOME/bin:$PATH



#zprof
