# Stakeware - Bulk Staking Tool for Solana CLI
Copyright (C) 2021 David White
github: https://github.com/davewhiiite
twitter: https://twitter.com/daveswarez

## MIT License

Copyright (C) 2021 David White

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

##Warning
Let it be known upfront that these are unaudited, barely tested scripts. **They 
are not created by, supported, or in any way endorsed by Solana Labs or the 
Solana Foundation.** They are intended to speed up the job of someone who already 
knows their way around Solana CLI (command-line interface), not to abstract away 
what is happening under the hood. Beware that if any part of the program(s) fail 
you might need to intervene manually, and could lose some, or ALL of your funds. 
The author is not responsible for any personal loss of property, or other damages 
incurred while using these scripts. Please practice on testnet or devnet first, 
and use at your risk! 

## Description
Stakeware is a set of bash shell scripts that complement Solana CLI (command-line 
interface). The scripts execute operations serially, to make the repetitive task of 
splitting your stake, delegating to multiple validators (and/or deactivating, withdrawing) 
require a little less brainpower. They should help you move more quickly, and consistently. 
The scripts are intended to be short and simple to use. For security, the code 
should be easy to quickly review and understand by those familiar with shell scripts. 
As it pertains to "hardening" the programs, I am clearly not an expert and 
welcome any feedback or improvements via pull request.

## How it Works
At the current time the tool:
1. Takes **n** funds (SOL) from a single solana account that serves as the fee-payer, 
stake and withdraw authority. Scripts could be modified for different keys to control 
different things, but that's more keypairs to manage, so currently unsupported. 
2. Loads those funds into a stake account outfile keypair (ex: stake-account.json)
3. Uses the main stake account to derive **m** seed stake accounts, and split the **n** 
SOL tokens evenly among those accounts. Whole coin amounts are used initially, 
with the remainder staying in the original funding account. 
4. Delegates the stakes to a random set of validators that are defined in a plain 
text file called *validator_whitelist.txt*
5. Provides additional scripts to bulk deactivate and withdraw your coins to a 
specified recipient address. 

## Minimum Requirements / 
- Command line environment that supported bash or similar shell. Ex: Mac OS 
Terminal, Linux, Windows Linux Subsystem (WSL), or a virtual machine.
- Solana Command-Line Interface (CLI) tools already installed. The scripts 
were created on *solana-cli 1.6.10*, but are probably compatible with earlier 
versions. If you haven't already, go here to get that installed: 
https://docs.solana.com/cli/install-solana-cli-tools
- Ledger hardware wallet (optional) with Solana application installed on it.

## Preparation
1. Not sure, but you might need to modify the permissions on the shell scripts to
be able to run them: `$ chmod +x *.sh` or `$ chmod 0755 *.sh` should do the trick.
2. *Config file*: go ahead and set your config file to use devnet or testnet, so that
you can practice with play money: 
  * `$ solana config get`
  * `$ nano/vi /path/to/config.yml`
    * edit the following line as: `json_rpc_url: "https://devnet.solana.com"`
3. Get some coins (may have to do it a bunch of times): `solana airdrop <n sol>` 
4. You are ready to play! Please see the head of each script to understand how to
provide inputs and invoke each script. The inputs of each are slightly different.

## Scripts (to be used in sequence, approximately)
- *fund_seed_accounts.sh [1]* -- takes coins from your funding account, generates 
a stake account with **m** seed accounts, and puts the coins in each of the 
seed accounts. 
- *validator_whitelist.txt* -- a prerequisite to staking: you must currently 
supply the validator vote ID addresses that you want to use. The minimum 
number of addresses in this file is one (1). 
- *delegate.sh [1]* -- this will delegate the coins in each of your seed accounts 
to a randomly-selected validator in the *validator_whitelist.txt* file. 
Currently, the random selection occurs using the shuffle function to seed 
$RANDOM variable, using this random number to select a line from the whitelist 
file to read as the validator vote ID.
- *balance.sh* -- prints out gross balance of coins in all seed accounts belonging 
to the main stake account.
- *seed_account_details.sh* -- prints out details of the seed account, including 
rewards history from the number of past epochs you select 
- *deactivate.sh [1]* -- will bulk deactivate all of the seed accounts belonging to 
the main stake account.
- *withdraw.sh [1]* -- will withdraw ALL of the coins in the seed accounts, sending 
them to a user-specified recipient account.

*[1] note: this activity requires you to sign for each seed account 
transaction independently. If using a hardware wallet, you will have to sign 
as many times as seed accounts that you have created.*

## EOF