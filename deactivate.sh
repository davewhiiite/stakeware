#!/bin/bash

# example script invocation:
# $ ./deactivate.sh usb://ledger?key=0 stake-account.json
funding_keypair=$1 # usb://ledger?key=0 or /path/to/funding_keypair.json
stake_keypair_filename=$2 # stake-account.json

stake_pubkey=`solana-keygen pubkey $stake_keypair_filename`

num_seed_accounts=`solana-stake-accounts count $stake_pubkey`
solana-stake-accounts addresses $stake_pubkey --num-accounts $num_seed_accounts > seed_account_list_tmp.txt

echo ""
echo "keypair for funding, fee-payer, stake and withdraw authority is: $funding_keypair"
echo ""
echo "the pubkey for $stake_keypair_filename is: $stake_pubkey"
echo ""
echo "the number of seed accounts belonging to $stake_pubkey is: $num_seed_accounts"
echo ""
while IFS= read -r line
do
    echo "seed account $line will be deactivated."
    if [[ "$funding_keypair" == *"usb"* ]]; then
        echo "using hardware wallet as funding keypair: please sign on device now."
    fi
    solana deactivate-stake --stake-authority $funding_keypair $line --fee-payer $funding_keypair
done < seed_account_list_tmp.txt

rm seed_account_list_tmp.txt
