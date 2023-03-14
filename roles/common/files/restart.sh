#!/bin/bash
if [ $# -eq 0 ]
  then
    python3 /mnt/snapcheck.py
fi
sudo systemctl stop solana-validator.service
sudo systemctl start solana-validator.service
