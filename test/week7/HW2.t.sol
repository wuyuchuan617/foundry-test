// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.18;

import {Test, console2} from "forge-std/Test.sol";
import {BlindBox} from "../../src/week7/HW2.sol";

contract HW2Test is Test {
    BlindBox public instance;
    address user1;
    string private _unRevealedURI = "https://ipfs.io/ipfs/QmXPXhtK2Vdxr6eYz4avcZXiS5fcHdp3qWpa2trmZKm7Sr/0";
    string private _revealedURI = "https://ipfs.io/ipfs/QmNxv6dAd6njWr7X7ZuSSH1ekd7xL6iDS6dZ7hr31QpnTg/1";

    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);

    function setUp() public {
        instance = new BlindBox();
        user1 = makeAddr("user1");
    }

    function testMint() public{
        vm.startPrank(user1);

        // Step 1: Mint a token to user1
        vm.expectEmit(true, true, true, true);
        emit Transfer(address(0), user1, 1);
        instance.mint(user1, 1);
        assertEq(instance.balanceOf(user1), 1);
        assertEq(instance.ownerOf(1), user1);
        assertEq(instance._isRevealed(1), false);
        assertEq(instance.tokenURI(1), _unRevealedURI);

        // Step 2: Open blind box
        instance.openBlindBox(1);
        assertEq(instance.tokenURI(1), _revealedURI);

        vm.stopPrank();
    }
}

