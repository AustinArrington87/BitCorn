/* eslint no-use-before-define: "warn" */
const fs = require("fs");
const chalk = require("chalk");
const { config, ethers } = require("hardhat");
const { utils } = require("ethers");
const R = require("ramda");
const ipfsAPI = require('ipfs-http-client');
const ipfs = ipfsAPI({host: 'ipfs.infura.io', port: '5001', protocol: 'https' })

const delayMS = 1000 //sometimes xDAI needs a 6000ms break lol 😅

const main = async () => {

  // ADDRESS TO MINT TO (Metamask wallet address):
  //const toAddress = "0x33dE1309578F0b8F478F94A323a80abc5903255F"
  const toAddress = "localhost:3000"


  console.log("\n\n 🎫 Minting to "+toAddress+"...\n");

  const { deployer } = await getNamedAccounts();
  const yourCollectible = await ethers.getContract("YourCollectible", deployer);

  const bear_paw_corn_1 = {
    "description": "A popcorn created by Glenn Thomson of Vermont and grown between 1930 and the mid-1960's. It was served in the Vermont exhibition of the World's Fair.",
    "external_url": "https://gateway.pinata.cloud/ipfs/QmS72SCpo6b1dSorPTpoSdxrEFkNVwHfhozga23d76u6HB",// <-- this can link to a page for the specific file too
    "image": "https://gateway.pinata.cloud/ipfs/QmS72SCpo6b1dSorPTpoSdxrEFkNVwHfhozga23d76u6HB",
    "name": "Bear Paw Corn",
    "seed_id": "bff_2021_001", // <-- reference to seedpack uuid (also used for QR code)
    "attributes": [
       {
         "trait_type": "LeafColor",
         "value": "green"
       },
       {
         "trait_type": "Eyes",
         "value": "sunglasses" // <-- design trait can be randomized 
       },
       {
          "trait_type": "Character", // <-- design trait can be randomized 
          "value": "ponytail"
       },
       {
         "trait_type": "DroughtTolerance", // <-- Values from CORN research
         "value": "high" // <-- These values will help gamify breeding and trading of CORN NFTs for different traits
       },
       {
        "traight_type": "PestResistance",
        "value": "medium"
       },
       {
         "trait_type": "FungusResistance",
         "value": "medium"
       },
       {
         "trait_type": "UniqueTrait", // <-- This is like thier unique super power 
         "value": "The most unusual trait, which gives the corn it's name, is the prevalence of two cobs in each husk."
       }
    ]
  }
  console.log("Uploading Bear Paw Corn...")
  const uploaded = await ipfs.add(JSON.stringify(bear_paw_corn_1))

  console.log("Minting Bear Paw Corn with IPFS hash ("+uploaded.path+")")
  await yourCollectible.mintItem(toAddress,uploaded.path,{gasLimit:10000000})


  await sleep(delayMS)


  const bear_paw_corn_2 = {
    "description": "A popcorn created by Glenn Thomson of Vermont and grown between 1930 and the mid-1960's. It was served in the Vermont exhibition of the World's Fair.",
    "external_url": "https://gateway.pinata.cloud/ipfs/QmS72SCpo6b1dSorPTpoSdxrEFkNVwHfhozga23d76u6HB",// <-- this can link to a page for the specific file too
    "image": "https://gateway.pinata.cloud/ipfs/QmS72SCpo6b1dSorPTpoSdxrEFkNVwHfhozga23d76u6HB",
    "name": "Bear Paw Corn",
    "seed_id": "bff_2021_002", // <-- reference to seedpack uuid (also used for QR code)
    "attributes": [
       {
         "trait_type": "LeafColor",
         "value": "green"
       },
       {
         "trait_type": "Eyes",
         "value": "glasses" // <-- design trait can be randomized 
       },
       {
          "trait_type": "Character", // <-- design trait can be randomized 
          "value": "ponytail"
       },
       {
         "trait_type": "DroughtTolerance", // <-- Values from CORN research
         "value": "high" // <-- These values will help gamify breeding and trading of CORN NFTs for different traits
       },
       {
        "traight_type": "PestResistance",
        "value": "medium"
       },
       {
         "trait_type": "FungusResistance",
         "value": "medium"
       },
       {
         "trait_type": "UniqueTrait", // <-- This is like thier unique super power 
         "value": "The most unusual trait, which gives the corn it's name, is the prevalence of two cobs in each husk."
       }
    ]
  }
  console.log("Uploading Bear Paw Corn...")
  const uploaded_2 = await ipfs.add(JSON.stringify(bear_paw_corn_2))

  console.log("Minting Bear Paw Corn with IPFS hash ("+uploaded_2.path+")")
  await yourCollectible.mintItem(toAddress,uploaded_2.path,{gasLimit:10000000})


  await sleep(delayMS)



  const teosinte_1 = {
    "description": "Teosinte, any of four species of tall, stout grasses in the genus Zea of the family Poaceae. Teosintes are native to Mexico, Guatemala, Honduras, and Nicaragua. Domesticated corn, or maize (Zea mays mays), was derived from the Balsas teosinte (Z. mays parviglumis) of southern Mexico in pre-Columbian times more than 6,000 years ago.",
    "external_url": "https://gateway.pinata.cloud/ipfs/QmYQU4naYiLXTDcw9Kk2N2GvEwjx8kk9HAkapRNRJSFBL7",// <-- this can link to a page for the specific file too
    "image": "https://gateway.pinata.cloud/ipfs/QmYQU4naYiLXTDcw9Kk2N2GvEwjx8kk9HAkapRNRJSFBL7",
    "name": "Tosinte",
    "seed_id": "bff_2021_300", // <-- reference to seedpack uuid (also used for QR code)
    "attributes": [
       {
         "trait_type": "LeafColor",
         "value": "green"
       },
       {
         "trait_type": "Eyes",
         "value": "googly" // <-- design trait can be randomized 
       },
       {
         "trait_type": "Character",
         "value": "sombrero"
       },
       {
         "trait_type": "DroughtTolerance",
         "value": "high"
       },
       {
        "traight_type": "PestResistance",
        "value": "high"
       },
       {
         "trait_type": "FungusResistance",
         "value": "high"
       },
       {
         "trait_type": "UniqueTrait",
         "value": "Teosinte is highly branched, and its ears have only two rows of hard kernels."
       }
    ]
  }
  console.log("Uploading Teosinte...")
  const uploaded_3 = await ipfs.add(JSON.stringify(teosinte_1))

  console.log("Minting Teosinte with IPFS hash ("+uploaded_3.path+")")
  await yourCollectible.mintItem(toAddress,uploaded_3.path,{gasLimit:10000000})



  await sleep(delayMS)


  const teosinte_2 = {
    "description": "Teosinte, any of four species of tall, stout grasses in the genus Zea of the family Poaceae. Teosintes are native to Mexico, Guatemala, Honduras, and Nicaragua. Domesticated corn, or maize (Zea mays mays), was derived from the Balsas teosinte (Z. mays parviglumis) of southern Mexico in pre-Columbian times more than 6,000 years ago.",
    "external_url": "https://gateway.pinata.cloud/ipfs/QmWFhesN3utHD9rEGe6uf6iR7tCZ8Ya5bT5jyzEk9QdAHW",// <-- this can link to a page for the specific file too
    "image": "https://gateway.pinata.cloud/ipfs/QmWFhesN3utHD9rEGe6uf6iR7tCZ8Ya5bT5jyzEk9QdAHW",
    "name": "Tosinte",
    "seed_id": "bff_2021_301", // <-- reference to seedpack uuid (also used for QR code)
    "attributes": [
       {
         "trait_type": "LeafColor",
         "value": "green"
       },
       {
         "trait_type": "Eyes",
         "value": "googly" // <-- design trait can be randomized 
       },
       {
         "trait_type": "Character",
         "value": "army" // <-- design trait can be randomized 
       },
       {
         "trait_type": "DroughtTolerance",
         "value": "high"
       },
       {
        "traight_type": "PestResistance",
        "value": "high"
       },
       {
         "trait_type": "FungusResistance",
         "value": "high"
       },
       {
         "trait_type": "UniqueTrait",
         "value": "Teosinte is highly branched, and its ears have only two rows of hard kernels."
       }
    ]
  }
  console.log("Uploading Teosinte...")
  const uploaded_4 = await ipfs.add(JSON.stringify(teosinte_2))

  console.log("Minting Teosinte with IPFS hash ("+uploaded_4.path+")")
  await yourCollectible.mintItem(toAddress,uploadedteosinte.path,{gasLimit:10000000})


  await sleep(delayMS)

  const teosinte_3 = {
    "description": "Teosinte, any of four species of tall, stout grasses in the genus Zea of the family Poaceae. Teosintes are native to Mexico, Guatemala, Honduras, and Nicaragua. Domesticated corn, or maize (Zea mays mays), was derived from the Balsas teosinte (Z. mays parviglumis) of southern Mexico in pre-Columbian times more than 6,000 years ago.",
    "external_url": "https://gateway.pinata.cloud/ipfs/QmXTN3dCQXNfv8z38kHb4Yxs8skFNe6PrCxrivep9sSpQ5",// <-- this can link to a page for the specific file too
    "image": "https://gateway.pinata.cloud/ipfs/QmWFhesN3utHD9rEGe6uf6iR7tCZ8Ya5bT5jyzEk9QdAHW",
    "name": "Tosinte",
    "seed_id": "bff_2021_301", // <-- reference to seedpack uuid (also used for QR code)
    "attributes": [
       {
         "trait_type": "LeafColor",
         "value": "green"
       },
       {
         "trait_type": "Eyes",
         "value": "googly" // <-- design trait can be randomized 
       },
       {
         "trait_type": "Character",
         "value": "chef" // <-- design trait can be randomized 
       },
       {
         "trait_type": "DroughtTolerance",
         "value": "high"
       },
       {
        "traight_type": "PestResistance",
        "value": "high"
       },
       {
         "trait_type": "FungusResistance",
         "value": "high"
       },
       {
         "trait_type": "UniqueTrait",
         "value": "Teosinte is highly branched, and its ears have only two rows of hard kernels."
       }
    ]
  }
  console.log("Uploading Teosinte...")
  const uploaded_5 = await ipfs.add(JSON.stringify(teosinte_3))

  console.log("Minting Teosinte with IPFS hash ("+uploaded_5.path+")")
  await yourCollectible.mintItem(toAddress,uploadedteosinte.path,{gasLimit:10000000})


  //await sleep(delayMS)

  // console.log("Transferring Ownership of YourCollectible to "+toAddress+"...")

  // await yourCollectible.transferOwnership(toAddress)

  // await sleep(delayMS)

  /*


  console.log("Minting zebra...")
  await yourCollectible.mintItem("0xD75b0609ed51307E13bae0F9394b5f63A7f8b6A1","zebra.jpg")

  */


  //const secondContract = await deploy("SecondContract")

  // const exampleToken = await deploy("ExampleToken")
  // const examplePriceOracle = await deploy("ExamplePriceOracle")
  // const smartContractWallet = await deploy("SmartContractWallet",[exampleToken.address,examplePriceOracle.address])



  /*
  //If you want to send value to an address from the deployer
  const deployerWallet = ethers.provider.getSigner()
  await deployerWallet.sendTransaction({
    to: "0x34aA3F359A9D614239015126635CE7732c18fDF3",
    value: ethers.utils.parseEther("0.001")
  })
  */


  /*
  //If you want to send some ETH to a contract on deploy (make your constructor payable!)
  const yourContract = await deploy("YourContract", [], {
  value: ethers.utils.parseEther("0.05")
  });
  */


  /*
  //If you want to link a library into your contract:
  // reference: https://github.com/austintgriffith/scaffold-eth/blob/using-libraries-example/packages/hardhat/scripts/deploy.js#L19
  const yourContract = await deploy("YourContract", [], {}, {
   LibraryName: **LibraryAddress**
  });
  */

};

function sleep(ms) {
  return new Promise(resolve => setTimeout(resolve, ms));
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
