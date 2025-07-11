[Unit]
Description=Nockchain miner
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
Environment=RUST_LOG=info
WorkingDirectory=/opt/nockchain
User=root
ExecStartPre=/usr/bin/rm -rf /opt/nockchain/.socket
ExecStart=/usr/local/bin/optimizednockchain --mine --mining-pubkey REDACTED \
  --peer /dnsaddr/nockchain-backbone.zorp.io