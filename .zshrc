# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# ==============================================================================
# THEME
# ==============================================================================

# Get a theme: https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
# Random Theme: ZSH_THEME="random" or ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )
ZSH_THEME="agnoster"

# ==============================================================================
# BANNER
# ==============================================================================

# colors.sh
NO_FORMAT="\033[0m"
C_CYAN1="\033[38;2;96;165;250m"
C_GOLD1="\033[38;5;220m"
C_BROWN="\033[38;5;172m"

echo -e -n "${C_CYAN1}"
echo -e "                   /)-._  "
echo -e "                  Y. ${C_GOLD1}'${NO_FORMAT}${C_CYAN1} _]  "
echo -e "           ,.._   | -- =  "
echo -e "          /    \--/   \  "
echo -e " /)      |   |_        \____  "
echo -e " \:::::::\___/_\__\_________\  "
echo -e -n "${NO_FORMAT}"
echo -e " __  __  __       ______  ______  ______  __      ______    "
echo -e "/\ \_\ \/\ \     /\  ___\/\  __ \/\  == \/\ \    /\  __ \   "
echo -e "\ \  __ \ \ \    \ \ \___\ \  __ \ \  __<\ \ \___\ \ \/\ \  "
echo -e " \ \_\ \_\ \_\    \ \_____\ \_\ \_\ \_\ \_\ \_____\ \_____\ "
echo -e "  \/_/\/_/\/_/     \/_____/\/_/\/_/\/_/ /_/\/_____/\/_____/ "

# ==============================================================================
# OTHER
# ==============================================================================

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

# ==============================================================================
# PLUGINS
# ==============================================================================

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)
source $ZSH/oh-my-zsh.sh
eval "$(starship init zsh)"

# ==============================================================================
# USER CONFIGURATION
# ==============================================================================

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
alias ls="eza"

# ==============================================================================
# PATHS
# ==============================================================================

# LazyGit
export XDG_CONFIG_HOME="$HOME/.config"
# bun
export BUN_INSTALL="$HOME/.bun"
# bun completions
[ -s "/Users/carlo/.bun/_bun" ] && source "/Users/carlo/.bun/_bun"
export PATH="$BUN_INSTALL/bin:$PATH"
eval "$(fnm env --use-on-cd --shell zsh)"
export PATH="$PATH:$(go env GOPATH)/bin"

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

## [Completion]
## Completion scripts setup. Remove the following line to uninstall
[[ -f /Users/carlo/.dart-cli-completion/zsh-config.zsh ]] && . /Users/carlo/.dart-cli-completion/zsh-config.zsh || true
## [/Completion]

# Flutter
export PATH=$PATH:"$HOME/fvm/default/bin"

# SPACETIMEDB
export PATH="/Users/carlo/.local/bin:$PATH"

# Added by Windsurf
export PATH="/Users/carlo/.codeium/windsurf/bin:$PATH"

# Dashmon
export PATH="$PATH":"$HOME/.pub-cache/bin"
