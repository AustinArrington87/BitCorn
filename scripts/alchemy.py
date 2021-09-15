import requests
import json
# test get balance with Alchemy composer key https://composer.alchemyapi.io/
# https://docs.alchemy.com/alchemy/introduction/why-use-alchemy
# enter API from app from Alchemy UI
url = 'https://eth-ropsten.alchemyapi.io/v2/<enterAPIKey>'
headers = {'content-type': 'application/json'}
# enter Address of Metamask Wallet you are getting balance for (test on Ropsten)
balance = {
    "jsonrpc":"2.0",
    "method":"eth_getBalance",
    "params":["<enter Metamask key>", "latest"],
    "id":0
}
# get Balance (integer of current balance in Wei)
def getBalance(balance):
    balanceInteger = requests.post(url, data = json.dumps(balance), headers=headers)
    return balanceInteger.text

print(getBalance(balance))
# Result is in wei, not ETH. Wei is used as the smallest denomination of ether. The conversion from wei to ETH is 1 eth = 1018 wei. So if we convert 0xde0b6b3a7640000 to decimal we get 1*1018 wei, which equals 1 ETH
