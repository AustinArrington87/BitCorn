const bear_paw_corn_1 = {
    "description": "A popcorn created by Glenn Thomson of Vermont and grown between 1930 and the mid-1960's. It was served in the Vermont exhibition of the World's Fair.",
    "external_url": "https://gateway.pinata.cloud/ipfs/QmS72SCpo6b1dSorPTpoSdxrEFkNVwHfhozga23d76u6HB",// <-- this can link to a page for the specific file too
    "image": "https://gateway.pinata.cloud/ipfs/QmS72SCpo6b1dSorPTpoSdxrEFkNVwHfhozga23d76u6HB",
    "name": "Bear Paw Corn",
    "seed_id": "bff_2021_001", // <-- reference to seedpack uuid (also used for QR code)
    "parent_ids": ["bff_2021_003", "bff_2021_002", "bff_2021_001"] // <-- reference to parent stock ID
    "dominant_traits": [
       {
         "trait_type": "kernel_color", // expressed in NFT image 
         "value": "yellow",
         "selection_type": "fixed" // <-- gene selection method
       },
       {
         "trait_type": "kernel_shape", // expressed in NFT image 
         "value": "rounded",
         "selection_type": "fixed"
       },
       {
         "trait_type": "husk_color", // expressed in NFT image 
         "value": "yellow",
         "selection_type": "fixed"
       },
       {
        "trait_type": "stalk_color", // expressed in NFT image 
        "value": "green",
        "selection_type": "fixed"
       },
       {
        "trait_type": "root_color", // expressed in NFT image 
        "value": "green",
        "selection_type": "fixed"
       },
       {
         "trait_type": "Eyes",
         "value": "sunglasses" // <-- design trait can be randomized 
         "selection_type": "random"
       },
       {
          "trait_type": "Head", // <-- design trait can be randomized 
          "value": "ponytail",
          "selection_type": "random"
       },
       {
         "trait_type": "Accessory", // <-- ie sword or laser gun 
         "value": "None",
         "selection_type": "random"
       },
       {
         "trait_type": "DroughtTolerance", // <-- Values from CORN research, not necessarily shown in NFT
         "value": "high", // <-- These values will help gamify breeding and trading of CORN NFTs for different traits
         "selection_type": "fixed"
        },
       {
        "traight_type": "PestResistance",
        "value": "medium",
        "selection_type": "fixed"
       },
       {
         "trait_type": "FungusResistance",
         "value": "medium",
         "selection_type": "fixed"
       },
       {
        "trait_type": "N-fixing gel",
         "value": "development", // <-- when a value is in development, that means it is actively in breeding project to embed trait
         "type": "fixed"
        },
       {
         "trait_type": "UniqueTrait", // <-- This is like thier unique super power 
         "value": "The most unusual trait, which gives the corn it's name, is the prevalence of two cobs in each husk."
         "selection_type": "fixed"
        }
    ],
    "recessive_traits": [ // <-- burning NFT creates 2 seeds each (1/2 value), that can be planted and modeled in a virtual agronommic world 
        // experimenting with real-world and virtual modeling of dominant and recessive trait combinations will enable us to 
        // develop novel climate-adapting corn varieties within our 7-year goal. 
        { 
          "trait_type": "kernel_color", // someone can choose to burn NFT (creating 2 seeds to be planted and grown into new NFTs to be traded or bred)
          "value": "sunflower yellow",
          "type": "random" // trait selection can be randomized from 34 heriloom varieties since originating from open pollination project
        },
        {
          "trait_type": "kernel_shape", 
          "value": "pointed",
          "type": "random" // <-- default for all recessives is random, but should be able to change to fixed ? 
        },
        {
          "trait_type": "husk_color",
          "value": "orange-brown",
          "type": "random"
        },
        {
         "trait_type": "stalk_color",
         "value": "green",
         "type": "random"
        },
        {
         "trait_type": "root_color",
         "value": "purple",
         "type": "random"
        },
        {
          "trait_type": "Eyes",
          "value": "googly" // <-- design trait can be randomized 
          "type": "random"
        },
        {
           "trait_type": "Head", // <-- design trait can be randomized 
           "value": "pirate-hat",
           "type": "random"
        },
        {
          "trait_type": "Accessory", // <-- ie sword or laser gun 
          "value": "sword",
         "type": "random"
        },
        {
          "trait_type": "DroughtTolerance", // <-- Values from CORN research, not necessarily shown in NFT
          "value": "high", // <-- These values will help gamify breeding and trading of CORN NFTs for different traits
          "type": "random"
         },
        {
         "traight_type": "PestResistance",
         "value": "high",
         "type": "random"
        },
        {
          "trait_type": "FungusResistance",
          "value": "medium",
          "type": "random"
        },
        {
         "trait_type": "N-fixing gel",
          "value": "development", // <-- when a value is in development, that means it is actively in breeding project to embed trait
          "type": "fixed"
         },
        {
          "trait_type": "UniqueTrait", // <-- This is like thier unique super power 
          "value": "The most unusual trait, which gives the corn it's name, is the prevalence of two cobs in each husk."
          "type": "random"
         }
     ]
  }
