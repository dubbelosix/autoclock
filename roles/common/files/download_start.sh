#!/bin/bash
sudo systemctl stop solana-validator.service
python3 /mnt/snapshot-finder.py --snapshot_path /mnt/solana-snapshots
sudo systemctl start solana-validator.service
