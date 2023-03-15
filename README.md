# Autoclock Validator
* The purpose of this Ansible playbook is to provide a fast and straightforward way to spin up a Solana validator running the Jito client. 
* The Autoclock validator script has been designed and tested on c3.large [Latitude](https://www.latitude.sh/) servers running Ubuntu thus far. Other OS and machine/disk configurations are untested yet, but feel free to fork or submit PRs to support additional infra.
* C3.large machines have 2 disks. One of these is mounted to / and the other one needs to be supplied in the defaults.

## Steps
1) Install Ansible locally https://docs.ansible.com/ansible/latest/installation_guide/installation_distros.html
2) Edit the hosts.yaml file in the root location to point to your validator's IP address and the ssh parameters.
3) basic command (???)
4) Make sure to create `hosts.yaml` file using the `hosts.example.yaml` as a guide.
```
ansible-playbook setup.yaml -i hosts.yaml -e id_path=./keys/validator-keypair.json -e vote_path=./keys/vote-account-keypair.json -e region=ny -e cluster=testnet -e rpc_address=https://api.testnet.solana.com -e repo_version=v1.14.16-jito
```

* The above assumes that validator-keypair.json and vote-account-keypair.json have been generated using solana-keygen and that the vote-account has already been created. The Ansible playbook executes the vote-account command to see that vote-account-keypair.json actually exists and is associated with validator-keypair.json. It will fail before starting the validator if that is not the case.

# Defaults

There are 2 main defaults files to edit: 
* common https://github.com/overclock-validator/autoclock-validator/blob/master/roles/common/defaults/main.yaml
```
---
ledger_disk: "nvme1n1"
swap_mb: 100000
```
* ledger_disk needs to point to the disk on the c3.large that is not currently mounted, which you can verify this using `sudo fdisk -l`
* The ansible script puts ledger on a separate disk and everything else (accounts, snapshots, OS) on the default disk (ledger and snapshot are both write intensive, so it's good to separate those to different disks)
* By default, swap_mb is set to 100gb, but for validators it's not that helpful outside of preventing a crash. If your machine is swapping however, there are other issues that need to be solved anyway.

* jito https://github.com/overclock-validator/autoclock-validator/blob/master/roles/jito/defaults/main.yaml
```
---
# 1. Supply a valid cluster
# testnet, mainnet
cluster: "mainnet"

# 2. Supply a valid jito block engine location
# mainnet: amsterdam, frankfurt, ny, tokyo 
# testnet: dallas, ny
location: "ny"

# Commission is in basis points (bps). 100 bps = 1%
commission-bps: 800
# Optional. This sends metricss to Solana's public influx and it is encouraged to set to true since it helps Solana Labs and others debug your validator as well as network issues.
metrics: true
org_name: "jito-foundation"
repo_name: "jito-solana"
repo_dir: "jito-solana"
repo_version: "v1.13.6-jito"
```
* The location as mentioned in the comment needs to be one of the 4 (for mainnet) or one of 2 (for testnet) - the validator parameters for block engine, relayer etc are set based on the location.
* The repo_version needs to be modified to whichever tag you want the validator to run. Consult jito discord (link below) for the latest version expected to be run.
* Other parameters can be left as is (most validator set commission to 800 basis points, but you can adjust that if you want to.

# Helpful Links
* Solana Discord (use validator-support channel)
* Jito Discord

# TODO
* support different disk configurations
* support skipping disk setup
* support flag to make starting the validator optional
* support Labs client as well, later Firedancer
