# nockmine

This is my nockchain mining setup.

See: https://github.com/zorp-corp/nockchain

_I use this mostly for myself, hence the bad documentaion, but if you find use, go ahead._

## How To
Follow the instructions in [setup](/docs/setup.md)

Clone this repo to the mining server. 

Then run:
```
run_miners 1
``` 

To run a single miner process.

Incerase the number slowly as you start up miners.

Once miners are running connect to them with:

```
tmux attach -t miners
```

## Automated Setup with Ansible

Instead of running all setup steps manually you can use the included Ansible
playbook. See [docs/ansible.md](docs/ansible.md) for details. A typical run is:

```
ansible-playbook -i ansible/inventory ansible/provision.yml --tags setup
ansible-playbook -i ansible/inventory ansible/provision.yml --tags bootstrap
ansible-playbook -i ansible/inventory ansible/provision.yml --tags service
```

This installs dependencies, builds the software, bootstraps using your
`state.jam` file and installs the systemd service.
