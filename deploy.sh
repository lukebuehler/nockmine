#!/usr/bin/env bash
# ------------------------------------------------------------
# deploy.sh [HOST1,HOST2,...] [THREADS]
#
# Deploys h9-miner to remote hosts
# If no hosts provided, uses hosts from .env file (MINERS_SSH)
# THREADS: Number of mining threads (default: 60)
# ------------------------------------------------------------

set -euo pipefail

# ---------- 0. Parse arguments ------------------------------
HOSTS="${1:-}"
THREADS="${2:-60}"

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
    echo "Usage: $0 [host1,host2,...] [threads]"
    echo "  threads: Number of mining threads (default: 60)"
    exit 1
  fi
fi

# Validate threads parameter
if ! [[ "$THREADS" =~ ^[0-9]+$ ]]; then
  echo "Error: THREADS must be a positive number"
  exit 1
fi

# ---------- 2. Check deploy files exist ---------------------
DEPLOY_DIR="deploy"
REQUIRED_FILES=(
  "$DEPLOY_DIR/h9-miner-nock-linux-amd64"
  "$DEPLOY_DIR/config.yaml"
  "$DEPLOY_DIR/h9-miner.service"
  "$DEPLOY_DIR/install_h9.sh"
)

for file in "${REQUIRED_FILES[@]}"; do
  if [[ ! -f "$file" ]]; then
    echo "Error: Required file not found: $file"
    exit 1
  fi
done

# ---------- 3. Deploy to each host --------------------------
IFS=',' read -ra HOST_ARRAY <<< "$HOSTS"

for host in "${HOST_ARRAY[@]}"; do
  # Trim whitespace
  host=$(echo "$host" | xargs)
  
  if [[ -z "$host" ]]; then
    continue
  fi
  
  echo "============================================================"
  echo "Deploying to: $host"
  echo "============================================================"
  
  # Create h9 directory on remote host
  echo "Creating directory /root/h9..."
  ssh -o ConnectTimeout=10 -o BatchMode=yes "root@$host" "mkdir -p /root/h9" || {
    echo "Error: Failed to create directory on $host (check SSH access)"
    continue
  }
  
  # Copy files
  echo "Copying files..."
  
  # Copy binary (to temp location first to avoid in-use issues)
  echo "  - Copying miner binary..."
  scp "$DEPLOY_DIR/h9-miner-nock-linux-amd64" "root@$host:/tmp/h9-miner-nock-linux-amd64.new" || {
    echo "Error: Failed to copy miner binary to $host"
    continue
  }
  
  # Create config with replacements and copy
  echo "  - Preparing config for $host with $THREADS threads..."
  sed -e "s/<machine_name>/$host/g" -e "s/<number_of_threads>/$THREADS/g" "$DEPLOY_DIR/config.yaml" > "/tmp/config-$host.yaml"
  scp "/tmp/config-$host.yaml" "root@$host:/root/h9/config.yaml" || {
    echo "Error: Failed to copy config to $host"
    rm -f "/tmp/config-$host.yaml"
    continue
  }
  rm -f "/tmp/config-$host.yaml"
  
  # Copy service file to temp location
  echo "  - Copying service file..."
  scp "$DEPLOY_DIR/h9-miner.service" "root@$host:/tmp/" || {
    echo "Error: Failed to copy service file to $host"
    continue
  }
  
  # Copy install script
  echo "  - Copying install script..."
  scp "$DEPLOY_DIR/install_h9.sh" "root@$host:/root/h9/" || {
    echo "Error: Failed to copy install script to $host"
    continue
  }
  
  # Run install script
  echo ""
  echo "Running installation script..."
  ssh -o ConnectTimeout=30 -o BatchMode=yes "root@$host" "bash /root/h9/install_h9.sh" || {
    echo "Error: Installation failed on $host"
    continue
  }
  
  echo ""
  echo "Deployment to $host completed!"
  echo "------------------------------------------------------------"
  echo ""
done

echo "============================================================"
echo "All deployments completed!"
echo ""
echo "Useful commands:"
echo "  Check status:  ssh root@HOST 'systemctl status h9-miner'"
echo "  View logs:     ssh root@HOST 'journalctl -u h9-miner -f'"
echo "  Restart:       ssh root@HOST 'systemctl restart h9-miner'"
echo "  Stop:          ssh root@HOST 'systemctl stop h9-miner'"
echo ""
echo "To update configuration:"
echo "  ./deploy.sh HOST THREADS"
echo "============================================================"