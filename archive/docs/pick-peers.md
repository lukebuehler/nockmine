# How to pick peers

If too much traffic?


Now just do
`--peer /dnsaddr/nockchain-backbone.zorp.io` if peers need to be picked

Saw this on TG:

```
sudo cat /etc/systemd/system/nockchain-miner.service
[Unit]
Description=Nockchain miner
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
Environment=RUST_LOG=info
WorkingDirectory=/home/ubuntu/nockchain
User=ubuntu
ExecStart=/home/ubuntu/nockchain/target/release/nockchain --mine --mining-pubkey 3Y5VjNGpNXs1YxpkYuKvfHzcrinGnWQfQtG6HY3S8AeVrScJBbUNnZf48aGdXbFa53i2UgQn7htS3aTawF3jfRPQM56nGAUPtvx2niG5inPdjoKVwsmx5bnfzEcWf51nUFXp \
  --peer /ip4/95.216.102.60/udp/3006/quic-v1 \
  --peer /ip4/65.108.123.225/udp/3006/quic-v1 \
  --peer /ip4/65.109.156.108/udp/3006/quic-v1 \
  --peer /ip4/65.21.67.175/udp/3006/quic-v1 \
  --peer /ip4/65.109.156.172/udp/3006/quic-v1 \
  --peer /ip4/34.174.22.166/udp/3006/quic-v1 \
  --peer /ip4/34.95.155.151/udp/30000/quic-v1 \
  --peer /ip4/34.18.98.38/udp/30000/quic-v1 \
  --peer /ip4/96.230.252.205/udp/3006/quic-v1 \
  --peer /ip4/94.205.40.29/udp/3006/quic-v1 \
  --peer /ip4/159.112.204.186/udp/3006/quic-v1 \
  --peer /ip4/88.0.59.61/udp/3006/quic-v1 \
  --peer /ip4/217.14.223.78/udp/3006/quic-v1

```
