#!/bin/bash

# example script invocation:
# $ ./balance.sh 5kBpxHgCV1HbJniXJW3fv7HQZEUooeHNsbCfddtPoimE 10
seed_account_pubkey=$1 # ex: 5kBpxHgCV1HbJniXJW3fv7HQZEUooeHNsbCfddtPoimE
num_rewards_epochs=$2 # ex: 10

echo "stake account details for seed pubkey: $seed_account_pubkey"
solana stake-account $seed_account_pubkey --with-rewards --num-rewards-epochs $num_rewards_epochs
