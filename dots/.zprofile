export PATH=/home/stefan/.local/bin:/home/stefan/bin:$PATH

if [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then
  echo "DISPLAY=$DISPLAY"
  echo "XDG_VTNR=$XDG_VTNR"
  echo "Starting sway..."
  exec sway > "/home/stefan/sway-log-$(date -Is)" 2>&1
fi
