// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/// @title RiddlerNFT
/// @notice Minimal ERC-721 NFT contract with metadata support
contract RiddlerNFT is ERC721, Ownable {
    uint256 private _nextTokenId;
    string private _tokenURI;

    /// @param tokenURI_ IPFS URI pointing to the metadata JSON
    constructor(string memory tokenURI_) ERC721("RiddlerNFT", "RNFT") Ownable(msg.sender) {
        _tokenURI = tokenURI_;
    }

    /// @notice Mint a new NFT
    /// @param to Address that will receive the NFT
    function mint(address to) external onlyOwner {
        _safeMint(to, _nextTokenId++);
    }

    /// @notice Returns the metadata URI for all tokens
    /// @dev All tokens share the same metadata (same image)
    function tokenURI(uint256) public view override returns (string memory) {
        return _tokenURI;
    }

    /// @notice Update the metadata URI (in case you need to change it)
    /// @param newTokenURI New IPFS URI
    function setTokenURI(string memory newTokenURI) external onlyOwner {
        _tokenURI = newTokenURI;
    }
}