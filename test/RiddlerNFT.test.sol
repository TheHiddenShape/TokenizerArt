// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {RiddlerNFT} from "../contracts/RiddlerNFT.sol";

contract RiddlerNFTTest is Test {
    RiddlerNFT public nft;
    address public owner;
    address public user;

    string constant URI = "ipfs://QmTest/1.json";

    function setUp() public {
        owner = address(this);
        user = address(0x1);
        nft = new RiddlerNFT(owner);
    }

    function testOwner() public view {
        require(nft.owner() == owner);
    }

    function testMint() public {
        nft.safeMint(user, URI);
        require(nft.ownerOf(1) == user);
        require(nft.totalSupply() == 1);
    }

    function testMintOnlyOwner() public {
        vm.prank(user);
        vm.expectRevert();
        nft.safeMint(user, URI);
    }

    function testMaxSupply() public view {
        require(nft.MAX_SUPPLY() == 100);
    }

    function testUpdateURI() public {
        nft.safeMint(user, URI);
        nft.updateTokenURI(1, "ipfs://new.json");
        require(keccak256(bytes(nft.tokenURI(1))) == keccak256(bytes("ipfs://new.json")));
    }
}
