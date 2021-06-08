#!/bin/bash

# example script invocation:
# $ ./withdraw.sh usb://ledger?key=0 stake-account.json 2ETrrFcKsKpnE1RCLpxDfdwDA1fBVRKZmWQmEBi4sBqv 
funding_keypair=$1 # ex: usb://ledger?key=0
stake_keypair_filename=$2 # stake-account.json
recipient_address=$3 # <receiving solana address>, ex: 2ETrrFcKsKpnE1RCLpxDfdwDA1fBVRKZmWQmEBi4sBqv
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
    echo "seed account $line will have ALL funds withdrawn to: $recipient_address."
    if [[ "$funding_keypair" == *"usb"* ]]; then
        echo "using hardware wallet as funding keypair: please sign on device now."
    fi
    solana withdraw-stake --withdraw-authority $funding_keypair $line $recipient_address ALL --fee-payer $funding_keypair

done < seed_account_list_tmp.txt

rm seed_account_list_tmp.txt
