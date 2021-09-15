import requests
import json
import sys
from decimal import Decimal
from web3 import Web3
#https://web3py.readthedocs.io/en/stable/web3.main.html

# test get balance with Alchemy composer key https://composer.alchemyapi.io/
# https://docs.alchemy.com/alchemy/introduction/why-use-alchemy
# enter API from app from Alchemy UI
url = 'https://eth-ropsten.alchemyapi.io/v2/T0QVTK9-9Qky6mCT-7Nf7FdTrAb3OWzi'
headers = {'content-type': 'application/json'}
# enter API from app from Alchemy UI - this is for Ropsten test network
mmWalletAddress = "0x33dE1309578F0b8F478F94A323a80abc5903255F"
# wallet address from contracts/MyNFT.sol 0xDCfa0E058796cEBA7bbe554eeEf787f66e25ca0A
# wallet address from token/CORN1.0.sol 0x33dE1309578F0b8F478F94A323a80abc5903255F

balance = {
    "jsonrpc":"2.0",
    "method":"eth_getBalance",
    "params":[mmWalletAddress, "latest"],
    "id":0
}
# get Balance
def getBalance(balance):
    balanceInteger = requests.post(url, data = json.dumps(balance), headers=headers)
    #integer of the current balance for the given address in wei.
    wei = balanceInteger.text
    return wei
# convert hexadecimal to int, then wei into ether
def convertBalance2Int (weiBalance):
    wei = Web3.toInt(hexstr=weiBalance)
    eth = Web3.fromWei(Web3.toInt(hexstr=weiBalance),'ether')
    return {"wei": wei, 'eth': eth}

# Result is in wei, not ETH. Wei is used as the smallest denomination of ether. The conversion from wei to ETH is 1 eth = 10^18 wei. So if we convert 0xde0b6b3a7640000 to decimal we get 1*1018 wei, which equals 1 ETH
weiBalance = json.loads(getBalance(balance))["result"]
print(weiBalance, "balance for MetaMask wallet address ", mmWalletAddress)

balanceInt = convertBalance2Int(weiBalance)
print("Balance (Wei): ", balanceInt["wei"])
print("Balance (ETH): ", balanceInt["eth"])
