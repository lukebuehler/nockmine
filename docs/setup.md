==========================================
# Prep (if Mac Ghostty)

(for mac so that nano runs)
`export TERM=xterm-256color`

also add to .bashrc

==========================================
## Mount Disks (if needed)

sudo lsblk

(create disks)
https://chatgpt.com/share/682cea63-81ac-800d-aca2-66d28bf36601

==========================================
# Add swap

https://chatgpt.com/share/68305409-bcc0-800d-a822-1c8b83fabfc8


==========================================
# Install Nockchain

```
sudo apt-get update
sudo apt install make build-essential
sudo apt install clang llvm-dev libclang-dev

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

#build kernel issue
sudo sysctl -w vm.overcommit_memory=1

git clone https://github.com/zorp-corp/nockchain.git
cp .env_example .env

make install-hoonc
make build

make install-nockchain-wallet
make install-nockchain

run-nockchain
```