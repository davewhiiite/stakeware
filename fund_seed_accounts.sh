#!/bin/bash

# example script invocation:
# $ ./fund_seed_accounts.sh usb://ledger?key=0 stake-account.json 4 100
funding_keypair=$1 # ex: usb://ledger?key=0 or /path/to/your/funding_keypair.json
stake_keypair_filename=$2 # an output file, typically stake-account.json
num_seed_accounts=$3 # the number of seed accounts you want to split across
total_stake=$4 # total number of coins to be split across num_seed_accounts

stake_per_seed_account=$(( total_stake / num_seed_accounts )) # the number of coins going to each seed account

solana-keygen new --no-passphrase -o $stake_keypair_filename # create keypair output file for main stake account
stake_pubkey=`solana-keygen pubkey $stake_keypair_filename` # get its pubkey

echo ""
echo "keypair for funding, fee-payer, stake and withdraw authority is: $funding_keypair"
echo ""
echo "the pubkey for $stake_keypair_filename is: $stake_pubkey"
echo ""

# loop to create and fund the seed stake accounts
for (( i=0; i<$num_seed_accounts; i++ ))
do
    # format: solana create-stake-account <STAKE_ACCOUNT_KEYPAIR> <AMOUNT> --config <FILEPATH> --fee-payer <KEYPAIR> --from <KEYPAIR> --seed <STRING> --stake-authority <PUBKEY> --withdraw-authority <PUBKEY>
    echo "solana create-stake-account $stake_keypair_filename $stake_per_seed_account --fee-payer $funding_keypair --from $funding_keypair --seed $i --stake-authority $funding_keypair --withdraw-authority $funding_keypair"
    
    if [[ "$funding_keypair" == *"usb"* ]]; then
        echo "using hardware wallet as funding keypair: please sign on device now."
    fi

    solana create-stake-account $stake_keypair_filename $stake_per_seed_account --fee-payer $funding_keypair --from $funding_keypair --seed $i --stake-authority $funding_keypair --withdraw-authority $funding_keypair
    echo ""
done

# print out the final address list
num_seed_accounts_real=`solana-stake-accounts count $stake_pubkey`
echo "the following seed addresses were created and funded:"
solana-stake-accounts addresses $stake_pubkey --num-accounts $num_seed_accounts_real
