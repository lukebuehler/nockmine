# Automated miner setup with Ansible

This repository now includes a simple Ansible playbook to provision a new
machine for running a `nockchain` miner.

## Prerequisites

* Ansible installed on the control machine
* SSH access to the target miner host
* `state.jam` file available on the control machine

## Usage

1. Copy `ansible/inventory.example` to `ansible/inventory` and edit the host
   information.
2. Place your `state.jam` file in the root of this repository (or adjust the
   `state_jam_local_path` variable).
3. Run the playbook:
   ```bash
   ansible-playbook -i ansible/inventory ansible/provision.yml --tags setup
   ansible-playbook -i ansible/inventory ansible/provision.yml --tags bootstrap
   ansible-playbook -i ansible/inventory ansible/provision.yml --tags service
   ```

The `setup` tag installs dependencies and builds the miner. The `bootstrap`
step launches the bootstrap script using the provided `state.jam` file. This
process can take a long time and may require manual cancellation once complete.
Finally the `service` tag installs and starts the systemd service using the
`install_miner` script.

Variables such as the repository location and worker thread count can be
overridden on the command line, for example:

```bash
ansible-playbook -i ansible/inventory ansible/provision.yml \
  -e repo_dir=/opt/nockchain -e worker_threads=8 --tags setup
```

