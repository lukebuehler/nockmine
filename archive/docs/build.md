make install-hoonc
export PATH="$HOME/.cargo/bin:$PATH"

make build
mkdir assets

make install-nockchain-wallet
export PATH="$HOME/.cargo/bin:$PATH"

make install-nockchain
export PATH="$HOME/.cargo/bin:$PATH"