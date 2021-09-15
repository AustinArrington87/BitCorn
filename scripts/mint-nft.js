require("dotenv").config()

console.log(process.env.API_URL)
//const API_URL = process.env.API_URL;
const API_URL = "https://eth-ropsten.alchemyapi.io/v2/T0QVTK9-9Qky6mCT-7Nf7FdTrAb3OWzi"
const { createAlchemyWeb3 } = require("@alch/alchemy-web3")
const web3 = createAlchemyWeb3(API_URL)

// grab contract ABI (Application Binary Interface)
const contract = require("../artifacts/contracts/MyNFT.sol/MyNFT.json")
console.log(JSON.stringify(contract.abi))
