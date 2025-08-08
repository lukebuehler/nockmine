#!/usr/bin/env bash
# ------------------------------------------------------------
# cleanup.sh [HOST1,HOST2,...]
#
# Cleans up old h9 miner setup (tmux sessions and v1.0.2-2-linux directory)
# If no hosts provided, uses hosts from .env file (MINERS_SSH)
# ------------------------------------------------------------

set -euo pipefail

# ---------- 0. Parse arguments ------------------------------
HOSTS="${1:-}"

# ---------- 1. Load .env if hosts not provided -------------
if [[ -z "$HOSTS" ]]; then
  if [[ -f ".env" ]]; then
    set -a
    source .env
    set +a
    HOSTS="${MINERS_SSH:-}"
  fi
  
  if [[ -z "$HOSTS" ]]; then
    echo "Error: No hosts specified and MINERS_SSH not found in .env"
    echo "Usage: $0 [host1,host2,...]"
    exit 1
  fi
fi

# ---------- 2. Clean up each host ---------------------------
IFS=',' read -ra HOST_ARRAY <<< "$HOSTS"

echo "============================================================"
echo "Starting cleanup of old h9 miner setup"
echo "============================================================"
echo ""

for host in "${HOST_ARRAY[@]}"; do
  # Trim whitespace
  host=$(echo "$host" | xargs)
  
  if [[ -z "$host" ]]; then
    continue
  fi
  
  echo "------------------------------------------------------------"
  echo "Cleaning up: $host"
  echo "------------------------------------------------------------"
  
  # Run cleanup commands on remote host
  ssh -o ConnectTimeout=10 -o BatchMode=yes "root@$host" '
    # Kill tmux session named "h9" if it exists
    if tmux list-sessions 2>/dev/null | grep -q "^h9:"; then
      echo "Killing tmux session: h9"
      tmux kill-session -t h9
    else
      echo "No tmux session named h9 found"
    fi
    
    # Remove old miner directory
    if [[ -d "/root/v1.0.2-2-linux" ]]; then
      echo "Removing directory: /root/v1.0.2-2-linux"
      rm -rf /root/v1.0.2-2-linux
    else
      echo "Directory /root/v1.0.2-2-linux not found"
    fi
    
    # Optional: List any remaining tmux sessions
    echo ""
    echo "Remaining tmux sessions:"
    tmux list-sessions 2>/dev/null || echo "No tmux sessions running"
  ' || {
    echo "Error: Failed to clean up $host (check SSH access)"
    continue
  }
  
  echo "Cleanup completed for $host"
  echo ""
done

echo "============================================================"
echo "Cleanup completed!"
echo ""
echo "You can now run the deployment script:"
echo "  ./deploy.sh"
echo "============================================================"