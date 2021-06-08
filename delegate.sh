#!/bin/bash

# example script invocation:
# $ ./delegate.sh usb://ledger?key=0 stake-account.json
funding_keypair=$1 # ex: usb://ledger?key=0 or /path/to/funding_keypair.json
stake_keypair_filename=$2 # stake-account.json

stake_pubkey=`solana-keygen pubkey $stake_keypair_filename`

# create a temporary list of the active seed stake accounts
num_seed_accounts=`solana-stake-accounts count $stake_pubkey`
solana-stake-accounts addresses $stake_pubkey --num-accounts $num_seed_accounts > seed_account_list_tmp.txt

validator_count=`wc -l < validator_whitelist.txt`

echo ""
echo "keypair for funding, fee-payer, stake and withdraw authority is: $funding_keypair"
echo ""
echo "the pubkey for $stake_keypair_filename is: $stake_pubkey"
echo ""
echo "the number of seed accounts belonging to $stake_pubkey is: $num_seed_accounts"
echo ""
while IFS= read -r line
do
    seed_for_random_number=`shuf -i 0-999 -n1`
    RANDOM=`echo $seed_for_random_number`
    random_validator_line_number=$(( RANDOM % validator_count + 1 ))
    echo "random_validator_line_number is: $random_validator_line_number"
    validator_vote_id=`cat validator_whitelist.txt | head -n $random_validator_line_number | tail -n 1`
    echo "seed account $line will be staked with validator: $validator_vote_id"

    if [[ "$funding_keypair" == *"usb"* ]]; then
        echo "using hardware wallet as funding keypair: please sign on device now."
    fi
    solana delegate-stake $line $validator_vote_id --stake-authority $funding_keypair --fee-payer $funding_keypair
done < seed_account_list_tmp.txt

rm seed_account_list_tmp.txt

echo "delegate.sh script completed."