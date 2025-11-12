# RiddlerNFT - Minimal ERC-721

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## An Overview of the Smart Contract
RiddlerNFT is a minimal ERC-721 NFT contract built using the OpenZeppelin standard contracts library. Development leverages the latest Hardhat framework version and utilizes Ignition with Viem for smart contract deployment. Configuration targets the Sepolia test network through [Alchemy](https://www.alchemy.com/) infrastructure.

ERC-721 is a technical standard for creating non-fungible token (NFT) smart contracts on the Ethereum blockchain. Each token is unique and cannot be replicated, making it ideal for representing ownership of distinct digital or physical assets. The EVM (Ethereum Virtual Machine) executes these contracts identically across all network nodes, ensuring that each transaction modifies the global state in a deterministic and permanent way.

This implementation contains the following functionalities:
- Standard ERC-721 token transfers, approvals, and ownership queries
- Owner-controlled minting with automatic token ID assignment and metadata URI support
- Token burning functionality through ERC721Burnable extension
- Metadata storage and update capability via ERC721URIStorage extension

## NFT Metadata & IPFS

NFT metadata follows the ERC-721 standard and is hosted on IPFS (InterPlanetary File System) for decentralized, immutable storage. Files are uploaded to [Pinata](https://pinata.cloud/), which provides persistent pinning and a free tier.

**Metadata structure:**
```json
{
  "name": "RiddlerNFT #1",
  "description": "A unique NFT from the Riddler collection",
  "image": "ipfs://bafybeieukjol6kj4c4qxsh6xgrpxafgbiwwgye3dxhn3xowojumt2es3v4",
  "attributes": [{"trait_type": "Collection", "value": "Riddler"}]
}
```

**Usage in contract:**
```solidity
safeMint(to, "ipfs://QmYourMetadataHash/metadata.json");
```

> The maximum size for a deployed smart contract on Ethereum is 24 KB (24,576 bytes), introduced with EIP-170.

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/// @title RiddlerNFT
/// @notice Minimal ERC-721 NFT contract with metadata support
contract RiddlerNFT is ERC721, Ownable, ERC721Burnable, ERC721URIStorage {
    uint256 private _nextTokenId = 1;
    uint256 public constant MAX_SUPPLY = 100;

    constructor(address initialOwner) ERC721("RiddlerNFT", "RNFT") Ownable(initialOwner) {
    }

    /// @notice Mint a new NFT with metadata URI
    function safeMint(address to, string memory uri) external onlyOwner {
        require(_nextTokenId <= MAX_SUPPLY, "Max supply reached");
        uint256 tokenId = _nextTokenId++;
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri);
    }

    /// @notice Update the metadata URI of an existing token
    function updateTokenURI(uint256 tokenId, string memory uri) external onlyOwner {
        _setTokenURI(tokenId, uri);
    }

    /// @notice Get the total number of minted tokens
    function totalSupply() external view returns (uint256) {
        return _nextTokenId - 1;
    }

    function tokenURI(uint256 tokenId) public view override(ERC721, ERC721URIStorage) returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId) public view override(ERC721, ERC721URIStorage) returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
```

## Prerequisites

-   Node.js (v22.10.0 or a later LTS version)
-   npm package manager
-   Alchemy API key for Sepolia testnet
-   Private key for deployment wallet with Sepolia ETH
- Metamask Extension / App

### Faucets
You must have at least **0.001 ETH** in your MetaMask wallet on the Ethereum mainnet in order to use faucets.

https://cloud.google.com/application/web3/faucet/ethereum/sepolia  
https://www.alchemy.com/faucets/ethereum-sepolia

## Installation & Configuration

The project includes the following key packages:
-   Hardhat 3
-   OpenZeppelin Contracts
-   Hardhat Ignition
-   Viem
-   Additional Hardhat plugins for testing and verification

```bash
npm install
```

The project is configured to work with the Sepolia testnet through Alchemy. Ensure your environment variables are properly set:

```bash
SEPOLIA_RPC_URL=[RPC URL]
SEPOLIA_PRIVATE_KEY=[PRIVATE KEY]
```

## Testing

```bash
# run all tests
npx hardhat test

# run tests with gas reporting
npx hardhat test --gas-stats

# run tests with coverage analysis
npx hardhat test --coverage
```

For the --gas-stats output, you can calculate the fees (Deployment Cost) using the following formula:

$$
\text{Cost (EUR)} = \frac{\text{Gas Used} \times \text{Gas Price (Gwei)} \times \text{ETH Price (EUR)}}{1\,000\,000\,000}
$$

## Deployment

```bash
# compilation & cleaning
npx hardhat compile
npx hardhat clean

# deploy to sepolia testnet
npx hardhat ignition deploy ignition/modules/RiddlerNFTModule.ts --network sepolia

# verify deployment status
npx hardhat ignition status chain-11155111 --network sepolia

# interact with sepolia network
npx hardhat console --network sepolia
```

## Solidity contract source validation

```bash
# flatten contract for verification & validation on sepolia testnet
npx hardhat flatten > flatten/flattened.sol
```

We use the following in order to verify the smart contract: https://sepolia.etherscan.io/verifyContract
  
Compiler Version: v0.8.28+commit.7893614a  
Optimization Enabled: 1  
Runs: 200

## License

Copyright © 2025 Ammon Netom-El Schiffer
This project is [MIT](LICENSE.md) licensed.
