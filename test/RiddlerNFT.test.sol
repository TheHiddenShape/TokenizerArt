// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {RiddlerNFT} from "../contracts/RiddlerNFT.sol";

contract RiddlerNFTTest is Test {
    RiddlerNFT public nft;
    address public owner;
    address public addr1;
    address public addr2;

    string constant TOKEN_URI = "ipfs://QmTest/metadata.json";

    function setUp() public {
        owner = address(this);
        addr1 = address(0x1);
        addr2 = address(0x2);

        nft = new RiddlerNFT(TOKEN_URI);
    }

    function testOwnerIsSet() public view {
        require(nft.owner() == owner, "Owner not set correctly");
    }

    function testNFTMetadata() public view {
        require(keccak256(bytes(nft.name())) == keccak256(bytes("RiddlerNFT")), "Name incorrect");
        require(keccak256(bytes(nft.symbol())) == keccak256(bytes("RNFT")), "Symbol incorrect");
    }

    function testMint() public {
        nft.mint(addr1);
        require(nft.ownerOf(0) == addr1, "Owner of token incorrect");
        require(nft.balanceOf(addr1) == 1, "Balance should be 1");
    }

    function testMintMultiple() public {
        nft.mint(addr1);
        nft.mint(addr1);
        nft.mint(addr2);

        require(nft.balanceOf(addr1) == 2, "Addr1 balance should be 2");
        require(nft.balanceOf(addr2) == 1, "Addr2 balance should be 1");
    }

    function testMintFailsIfNotOwner() public {
        vm.prank(addr1);
        vm.expectRevert();
        nft.mint(addr2);
    }

    function testTransfer() public {
        nft.mint(addr1);

        vm.prank(addr1);
        nft.transferFrom(addr1, addr2, 0);

        require(nft.ownerOf(0) == addr2, "Owner should be addr2");
        require(nft.balanceOf(addr1) == 0, "Addr1 balance should be 0");
        require(nft.balanceOf(addr2) == 1, "Addr2 balance should be 1");
    }

    function testTransferFailsIfNotOwnerOrApproved() public {
        nft.mint(addr1);

        vm.prank(addr2);
        vm.expectRevert();
        nft.transferFrom(addr1, addr2, 0);
    }

    function testApprove() public {
        nft.mint(addr1);

        vm.prank(addr1);
        nft.approve(addr2, 0);

        require(nft.getApproved(0) == addr2, "Approval not set correctly");
    }

    function testTransferOwnership() public {
        nft.transferOwnership(addr1);
        require(nft.owner() == addr1, "Ownership not transferred");
    }

    function testTokenURI() public {
        nft.mint(addr1);
        require(
            keccak256(bytes(nft.tokenURI(0))) == keccak256(bytes(TOKEN_URI)),
            "Token URI incorrect"
        );
    }

    function testTokenURISameForAllTokens() public {
        nft.mint(addr1);
        nft.mint(addr2);

        require(
            keccak256(bytes(nft.tokenURI(0))) == keccak256(bytes(nft.tokenURI(1))),
            "Token URIs should be the same"
        );
    }

    function testSetTokenURI() public {
        string memory newURI = "ipfs://QmNewHash/metadata.json";
        nft.setTokenURI(newURI);

        nft.mint(addr1);
        require(
            keccak256(bytes(nft.tokenURI(0))) == keccak256(bytes(newURI)),
            "Token URI not updated"
        );
    }

    function testSetTokenURIFailsIfNotOwner() public {
        vm.prank(addr1);
        vm.expectRevert();
        nft.setTokenURI("ipfs://QmNewHash/metadata.json");
    }

    function testFuzzMint(address to) public {
        vm.assume(to != address(0));
        vm.assume(to.code.length == 0);

        nft.mint(to);
        require(nft.balanceOf(to) == 1, "Fuzz mint failed");
    }
}
