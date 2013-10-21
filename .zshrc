# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="robbyrussell"

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable bi-weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment to change how often before auto-updates occur? (in days)
# export UPDATE_ZSH_DAYS=13

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want to disable command autocorrection
# DISABLE_CORRECTION="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Uncomment following line if you want to disable marking untracked files under
# VCS as dirty. This makes repository status check for large repositories much,
# much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git)

source $ZSH/oh-my-zsh.sh

# Customize to your needs...

# Path variables
export PATH=$PATH:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin
export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig
export PYTHONPATH=$PYTHONPATH:/usr/local/lib/python2.7/site-packages
export PATH="$HOME/Library/Haskell/bin:$PATH"
export PATH=$PATH:/usr/local/go/bin
export PYTHONPATH=/usr/local/lib/python2.7/site-packages:$PYTHONPATH

# Random utility commands
## Dictionary
function dict() {
    curl dict://dict.org/d:$1
}
## Generate a file named $1 with $2 count blocks.
function rfile() {
    dd if=/dev/urandom of=$1 bs=2048 count=$2
}

# Setup Amazon EC2 Command-Line Tools
export EC2_HOME=~/.ec2
export PATH=$PATH:$EC2_HOME/bin
export EC2_PRIVATE_KEY=`ls $EC2_HOME/pk-*.pem`
export EC2_CERT=`ls $EC2_HOME/cert-*.pem`
export JAVA_HOME=/System/Library/Frameworks/JavaVM.framework/Home/

# added by Anaconda 1.6.1 installer
#export PATH="/Users/mookerji/anaconda/bin:$PATH"
#export PYTHONPATH=/Users/mookerji/anaconda/lib/python2.7/site-packages:$PYTHONPATH

# unix aliases
alias ls='ls -lahF'
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias mkdir='mkdir -pv'
alias diff='colordiff'
alias h='history'
alias j='jobs -l'
alias path='echo -e ${PATH//:/\\n}'
alias now='date +"%T'
alias nowtime=now
alias nowdate='date +"%d-%m-%Y"'
alias ping='ping -c 5'
alias fastping='ping -c 100 -s.2'
alias weather="telnet rainmaker.wunderground.com"


# hdfs shell aliases
function start-hadoop() {
    /usr/local/Cellar/hadoop/1.1.2/libexec/bin/start-all.sh
}
function stop-hadoop() {
    /usr/local/Cellar/hadoop/1.1.2/libexec/bin/stop-all.sh
}
alias hls='hadoop fs -ls'
alias hrm='hadoop fs -rm -r -f -skipTrash'
alias hput='hadoop fs -put'
alias hget='hadoop fs -get'
alias hcat='hadoop fs -cat'
alias hstart='start-hadoop'
alias hstop='stop-hadoop'
