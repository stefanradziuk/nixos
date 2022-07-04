export PATH=/home/stefan/.local/bin:/home/stefan/bin:$PATH

if [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then
  exec sway
fi
