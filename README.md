# BitCorn
BitCorn Smart Contracts &amp; Application Code

# Test Alchemy API
$ git clone https://github.com/AustinArrington87/BitCorn.git

$ cd BitCorn/scripts
* *enter Alchemy API key and MetaMask private key into alchemy.py*

$ python3 alchemy.py

# Create NFT 

$ cd BitCorn

$ npm init 

$ npm install --save-dev hardhat

$ npx hardhat

* *Hardhat is a development environment to compile, deploy, test, and debug your Ethereum software. It helps developers when building smart contracts and dApps locally before deploying to the live chain.*
* *choose ❯ Create an empty hardhat.config.js*

$ npm install @openzeppelin/contracts

* *@openzeppelin/contracts/token/ERC721/ERC721.sol contains the implementation of the ERC-721 standard, which our NFT smart contract will inherit. (To be a valid NFT, your smart contract must implement all the methods of the ERC-721 standard.)*
* *@openzeppelin/contracts/utils/Counters.sol provides counters that can only be incremented or decremented by one. Our smart contract uses a counter to keep track of the total number of NFTs minted and set the unique ID on our new NFT. (Each NFT minted using a smart contract must be assigned a unique ID—here our unique ID is just determined by the total number of NFTs in existence. For example, the first NFT we mint with our smart contract has an ID of "1," our second NFT has an ID of "2," etc.)*
* *@openzeppelin/contracts/access/Ownable.sol sets up access control on our smart contract, so only the owner of the smart contract (you) can mint NFTs. (Note, including access control is entirely a preference. If you'd like anyone to be able to mint an NFT using your smart contract, remove the word Ownable on line 10 and onlyOwner on line 17.)*
* *In our ERC-721 constructor, you’ll notice we pass 2 strings, “BitCorn” and “CORN.” The first variable is the smart contract’s name, and the second is its symbol. You can name each of these variables whatever you wish!*
* *string memory tokenURI is a string that should resolve to a JSON document that describes the NFT's metadata. An NFT's metadata is really what brings it to life, allowing it to have configurable properties, such as a name, description, image, and other attributes. In part 2 of this tutorial, we will describe how to configure this metadata.*

$ npm install dotenv --save
* *create a .env file in the root directory of our project, and add your MetaMask private key and HTTP Alchemy API URL to it.*

$ npm install --save-dev @nomiclabs/hardhat-ethers 'ethers@^5.0.0'
* *Ethers.js is a library that makes it easier to interact and make requests to Ethereum by wrapping standard JSON-RPC methods with more user friendly methods.*

Update hardhat.config.js file 

```/**
 * @type import('hardhat/config').HardhatUserConfig
 */
require('dotenv').config();
require("@nomiclabs/hardhat-ethers");
const { API_URL, PRIVATE_KEY } = process.env;
module.exports = {
   solidity: {
    compilers: [
      {
        version: "0.5.7"
      },
      {
        version: "0.8.0"
      },
      {
        version: "0.6.12"
      }
    ]
   },
   defaultNetwork: "ropsten",
   networks: {
      hardhat: {},
      ropsten: {
         url: API_URL,
         accounts: [process.env.PRIVATE_KEY ]
      }
   },
}
```

$ npx hardhate compile

$ npx hardhat run scripts/deploy.js
* *Should return Contract deployed to address: etc.*
* *Go to https://ropsten.etherscan.io/ and enter contract address*
* *The From address should match your MetaMask account address*
* *Click into the transaction and you will see the Contract address in the "To" field*

 # You just deployed your NFT smart contract to the Ethereum chain!
