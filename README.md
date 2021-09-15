# BitCorn
BitCorn Smart Contracts &amp; Application Code

# Test Alchemy API
$ git clone https://github.com/AustinArrington87/BitCorn.git

$ cd BitCorn/scripts

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
