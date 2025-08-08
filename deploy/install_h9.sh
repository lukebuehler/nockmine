#!/usr/bin/env bash
# ------------------------------------------------------------
# install_h9.sh
#
# Installs/updates h9-miner service on the local machine
# Always reinstalls the service when run
# ------------------------------------------------------------

set -euo pipefail

INSTALL_DIR="/root/h9"
SERVICE_NAME="h9-miner"
SERVICE_FILE="/etc/systemd/system/${SERVICE_NAME}.service"

# Create install directory if it doesn't exist
mkdir -p "${INSTALL_DIR}"

# Move new binary from temp if it exists
if [[ -f "/tmp/h9-miner-nock-linux-amd64.new" ]]; then
  echo "Moving new binary into place..."
  mv -f "/tmp/h9-miner-nock-linux-amd64.new" "${INSTALL_DIR}/h9-miner-nock-linux-amd64"
fi

# Make binary executable
if [[ -f "${INSTALL_DIR}/h9-miner-nock-linux-amd64" ]]; then
  chmod +x "${INSTALL_DIR}/h9-miner-nock-linux-amd64"
fi

echo "Installing/updating service..."

# Stop service if running
if systemctl is-active --quiet "${SERVICE_NAME}"; then
  echo "Stopping existing service..."
  # Try graceful stop with 10 second timeout
  if ! timeout 10 systemctl stop "${SERVICE_NAME}" 2>/dev/null; then
    echo "Service didn't stop gracefully, forcing kill..."
    systemctl kill -s KILL "${SERVICE_NAME}" || true
    # Wait a bit for the process to be cleaned up
    sleep 2
  fi
fi

# Copy service file if it exists in temp
if [[ -f "/tmp/${SERVICE_NAME}.service" ]]; then
  cp "/tmp/${SERVICE_NAME}.service" "${SERVICE_FILE}"
fi

# Reload systemd
systemctl daemon-reload

# Enable and start service
systemctl enable "${SERVICE_NAME}"
systemctl start "${SERVICE_NAME}"

echo "Service started successfully"

# Show status
echo ""
echo "Service status:"
systemctl status "${SERVICE_NAME}" --no-pager -l || true

# Cleanup temp files
rm -f "/tmp/${SERVICE_NAME}.service"
rm -f "/tmp/h9-miner-nock-linux-amd64.new"