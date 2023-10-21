// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.18;

import {Test, console2} from "forge-std/Test.sol";
import {NoUseful, HW_Token, NFTReceiver} from "../../src/week7/HW1.sol";

contract HW1Test is Test {
    NoUseful public noUsefulInstance;
    HW_Token public hwTokenInstance;
    NFTReceiver public nftReceiverInstance;

    address user1;

    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);

    function setUp() public {
        noUsefulInstance = new NoUseful();
        hwTokenInstance = new HW_Token();
        nftReceiverInstance = new NFTReceiver(address(hwTokenInstance), address(noUsefulInstance));
        user1 = makeAddr("user1");
    }

    function testNoUsefulMint() public{
        vm.startPrank(user1);

        // Step 1: Mint a token to user1
        noUsefulInstance.mint(user1, 0);
        assertEq(noUsefulInstance.balanceOf(user1), 1);
        assertEq(noUsefulInstance.ownerOf(0), user1);

        // Step 2: Set approval for all for NFTReceiver contract
        vm.expectEmit(true, true, false, false, address(noUsefulInstance));
        emit ApprovalForAll(user1, address(nftReceiverInstance), true);
        noUsefulInstance.setApprovalForAll(address(nftReceiverInstance), true);
        assertEq(noUsefulInstance.isApprovedForAll(user1, address(nftReceiverInstance)), true);

        // Step 3: Attempt to transfer token from user1 to nftReceiverInstance
        vm.expectEmit(true, true, true, true);
        emit Transfer(user1, address(nftReceiverInstance), 0);
        noUsefulInstance.safeTransferFrom(user1, address(nftReceiverInstance), 0);

        // Step 4: Check balances after transfer
        assertEq(noUsefulInstance.balanceOf(user1), 1);
        assertEq(hwTokenInstance.balanceOf(user1), 1);
        
        vm.stopPrank();
    }
}

