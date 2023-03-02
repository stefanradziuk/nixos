#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Source Prezto.
ZPREZTODIR=~/.nix-profile/share/zsh-prezto
[[ -s "${ZPREZTODIR}/init.zsh" ]] && source "${ZPREZTODIR}/init.zsh"

# based on prezto's smiley
PROMPT='%T $python_info[virtualenv]$ruby_info[version]${git_info:+${(e)git_info[prompt]}} %B%c%b %(?:%F{green}ツ %f:%F{yellow}ツ %f)'

# set up z
ZDIR=~/.nix-profile/share/zsh-z
[[ -r "$ZDIR/zsh-z.plugin.zsh" ]] && source "$ZDIR/zsh-z.plugin.zsh"

REPORTTIME=5
TIMEFMT=$'\e[0;37m%J  %U user %S system %P cpu %*E total\e[0m'

setopt print_exit_value

export NIX_PATH=nixpkgs=/home/stefan/nixpkgs:nixos-config=/etc/nixos/configuration.nix:/nix/var/nix/profiles/per-user/root/channels

export EDITOR='nvim'
export BROWSER='google-chrome-beta'
export XDG_DATA_HOME=/home/stefan/.local/share
export XDG_CONFIG_HOME="$HOME/.config"

unsetopt correct

alias l="exa -laa"
alias genpasswd="strings /dev/urandom | grep -o '[[:alnum:]]' | head -n 16 | tr -d '\n'; echo"
alias sudo=$'nocorrect sudo\t'
alias :q="exit"
alias :e="nvim -p"
alias vi="nvim -p"
alias vim="nvim -p"
alias nvim="nvim -p"
alias vimi="nvim -c 'startinsert'"
alias svim="sudo -E nvim -p"
alias icat="kitty +kitten icat"
alias gdiff="git difftool --no-symlinks --dir-diff"
alias git="noglob git"
alias nix="noglob nix"
alias diff="wdiff"
alias ayy="yay"
alias sicstus="rlwrap /usr/local/sicstus4.4.1/bin/sicstus"
alias pyton="python"
alias pytonne="python"
alias copy="xclip -selection clipboard"
alias cate="cksum"
alias colorpicker="colorpicker --short --preview"

bindkey -v

# gui-like ctrl word jumping
bindkey "^[Od"	backward-word
bindkey "^[Oc"	forward-word
bindkey "^H"	backward-kill-word
bindkey "^[[3^"	kill-word

bindkey '^R' history-incremental-search-backward
bindkey '^F' history-incremental-search-forward

if [ -n "${commands[fzf-share]}" ]; then
  source "$(fzf-share)/key-bindings.zsh"
  source "$(fzf-share)/completion.zsh"

  # open fzf in a tmux pane
  export FZF_TMUX_OPTS=-p

  # TODO set up a .ignore file
  export FZF_CTRL_T_COMMAND='ag -l \
    --ignore .local \
    --ignore .steam \
    --ignore .cache \
    --ignore .cargo \
    --nocolor \
    --hidden \
    -g ""'
fi

source "$HOME/.secrets"

eval "$(direnv hook zsh)"

gi() {
  touch .gitignore
  curl "https://www.toptal.com/developers/gitignore/api/$1" >> .gitignore
}

mann() {
  curl "cheat.sh/$1" | bat
}

mailman_sync() {
  echo "docsoc's password: "
  read -sr
  echo "$REPLY" | ssh docsoc 'mailmansub/run.sh'
}

# touches a file, creating parent dirs as necessary
mktouch() {
  mkdir -p "$(dirname "$1")" && touch "$1"
}

py() {
  python -c "print($*)"
}

unlink() {
  FILE="$1"
  TMP_FILE=$(mktemp)
  cp $FILE $TMP_FILE
  mv $TMP_FILE $FILE
  chmod +w $FILE
}

tmpdir-shell() {
  TMPDIR=$(mktemp -d)
  (
    cd $TMPDIR
    zsh
  )
  rm -rf $TMP_FILE
}

# selected git aliases from zprezto
# Branch (b)
alias gb='git branch'
alias gbc='git checkout -b'

# Commit (c)
alias gcm='git commit --message'
alias gca='git commit --all'
alias gcam='git commit --all --message'
alias gco='git checkout'
alias gcf='git commit --amend --reuse-message HEAD'
alias gcl='git-commit-lost'

# Fetch (f)
alias gf='git fetch'
alias gfm='git pull'
alias gfr='git pull --rebase'
alias gfra='git pull --rebase --autostash'

# Index (i)
alias gia='git add'
alias giA='git add --patch'
alias giu='git add --update'
alias gid='git diff --no-ext-diff --staged'
alias giD='git diff --no-ext-diff --staged --word-diff'

# Log (l)
alias gl='git log --topo-order --pretty=format:"$_git_log_medium_format"'
alias gls='git log --topo-order --stat --pretty=format:"$_git_log_medium_format"'
alias gld='git log --topo-order --stat --patch --full-diff --pretty=format:"$_git_log_medium_format"'
alias glo='git log --topo-order --pretty=format:"$_git_log_oneline_format"'
alias glg='git log --topo-order --graph --pretty=format:"$_git_log_oneline_format"'
alias glb='git log --topo-order --pretty=format:"$_git_log_brief_format"'
alias glc='git shortlog --summary --numbered'
alias glS='git log --show-signature'

# Merge (m)
alias gm='git merge'
alias gmC='git merge --no-commit'
alias gmF='git merge --no-ff'
alias gma='git merge --abort'

# Push (p)
alias gp='git push'
alias gpf='git push --force-with-lease'

# Rebase (r)
alias gr='git rebase'
alias gra='git rebase --abort'
alias grc='git rebase --continue'
alias gri='git rebase --interactive'
alias grs='git rebase --skip'

# Remote (R)
alias gR='git remote'
alias gRa='git remote add'
alias gRs='git remote show'
alias gRb='git-hub-browse'

# Stash (s)
alias gs='git stash'
alias gsp='git stash pop'

# Working Copy (w)
alias gws='git status --ignore-submodules=$_git_status_ignore_submodules'
alias gwS='git status --ignore-submodules=$_git_status_ignore_submodules --short'
alias gwd='git diff --no-ext-diff'
alias gwD='git diff --no-ext-diff --word-diff'
