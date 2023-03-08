# autoclock
* the autoclock script is designed and tested only on c3.large latitude machines running ubuntu. Other OS and machine/disk configurations are not tested, but do feel free to fork or submit PRs to support additional infra
* c3.large machines have 2 disks. one of them is mounted to / and the other one has to be supplied in the defaults
* install ansible locally and edit the hosts.yaml file in the root location to point to your validator's IP address and the ssh parameters
* basic command
* make sure to create `hosts.yaml` file using the `hosts.example.yaml` as a guide
```
ansible-playbook setup.yaml -i hosts.yaml -e id_path=./keys/validator-keypair.json -e vote_path=./keys/vote-account-keypair.json -e region=ny -e cluster=testnet -e rpc_address=https://api.testnet.solana.com -e repo_version=1.14.16-jito
```

* The above assumes that validator-keypair.json and vote-account-keypair.json have been generated using solana-keygen and that the vote-account has already been created. The ansible playbook executes the vote-account command to see that vote-account-keypair.json actually exists and is associated with validator-keypair.json. It will fail before starting the validator if that is not the case.

# defaults

there are 2 main defaults files to edit 
* common https://github.com/dubbelosix/autoclock/blob/master/roles/common/defaults/main.yaml
```
---
ledger_disk: "nvme1n1"
swap_mb: 100000
```
* ledger_disk needs to point to the disk on the c3.large that is not currently mounted. you can verify this using `sudo fdisk -l`
* the ansible script puts ledger on a separate disk and everything else (accounts, snapshots, OS) on the default disk (ledger and snapshot are both write intensive, so its good to separate those to different disks)
* swap_mb is set to 100gb by default. for validators its not that helpful outisde of preventing a crash, but if your machine is swapping, there are other issues that need to be solved anyway.

* jito https://github.com/dubbelosix/autoclock/blob/master/roles/jito/defaults/main.yaml
```
---
# 1. Supply a valid cluster
# testnet, mainnet
cluster: "mainnet"

# 2. Supply a valid jito block engine location
# mainnet: amsterdam, frankfurt, ny, tokyo 
# testnet: dallas, ny
location: "ny"

# commission in basis points. 100 bps = 1%
commission-bps: 800
# optional. sends metricss to solana's public influx. encouraged to set true since its helps labs and others debug
# if something is wrong with your validator
metrics: true
org_name: "jito-foundation"
repo_name: "jito-solana"
repo_dir: "jito-solana"
repo_version: "v1.13.6-jito"
```
* the location as mentioned in the comment needs to be one of the 4 (for mainnet) or one of 2 (for testnet)  - the validator parameters for block engine, relayer etc are set based on the location
* repo_version needs to be modified to whichever tag you want the validator to run. consult jito discord for the latest version expected to be run
* other parameters can be left as is (most validator set commission to 800 basis points, but you can adjust that if you want to

# TODO
* support different disk configurations
* support skipping disk setup
* support flag to make starting the validator optional


