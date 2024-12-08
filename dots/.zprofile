export PATH=/home/stefan/.local/bin:/home/stefan/bin:$PATH

if [[ ! $DISPLAY && ! $TMUX && $XDG_VTNR -eq 1 ]]; then
  exec sway
fi
