#!/bin/bash

# example script invocation:
# $ ./balance.sh stake-account.json
stake_keypair_filename=$1 # ex: stake-account.json

stake_pubkey=`solana-keygen pubkey $stake_keypair_filename`
num_seed_accounts=`solana-stake-accounts count $stake_pubkey`

echo "stake keypair source: $stake_keypair_filename"
echo "balance for all seeds accounts belonging to main stake account pubkey: $stake_pubkey"
solana-stake-accounts balance $stake_pubkey --num-accounts $num_seed_accounts

echo ""
echo "total number of seed accounts: $num_seed_accounts"
echo "list of seed account addresses:"
solana-stake-accounts addresses $stake_pubkey --num-accounts $num_seed_accounts
