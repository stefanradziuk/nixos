export PATH=/home/stefan/.local/bin:/home/stefan/bin:$PATH

if [[ ! $DISPLAY && ! $TMUX && $XDG_VTNR -eq 1 ]]; then
  logfile="sway-$(date -Iseconds).log"
  echo "Starting sway, logging to $logfile..."
  exec sway > "$logfile" 2>&1
fi
