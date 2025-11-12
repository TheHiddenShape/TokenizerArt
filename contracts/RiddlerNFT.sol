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

    function safeMint(address to, string memory uri) external onlyOwner {
        require(_nextTokenId <= MAX_SUPPLY, "Max supply reached");
        uint256 tokenId = _nextTokenId++;
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri);
    }

    function updateTokenURI(uint256 tokenId, string memory uri) external onlyOwner {
        _setTokenURI(tokenId, uri);
    }

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