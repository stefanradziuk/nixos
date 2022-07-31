export PATH=/home/stefan/.local/bin:/home/stefan/bin:$PATH

if [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then
  LOG=/home/stefan/sway-log-$(date -Is)
  exec sway > $LOG 2>&1
fi
