// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {MyContract2} from "../../src/week6/MyContract2.sol";

contract CounterTest is Test {
    MyContract2 public instance;
    address public user1;
    address public user2;

    event Send(address indexed to, uint256 indexed amount);

    function setUp() public {
        user1 = makeAddr("user1");
        user2 = makeAddr("user2");
        instance = new MyContract2(user1, user2);
    }

    function testConstructor() public {
        // 1. Assert instance.user1() is user1
        // 2. Assert instance.user2() is user2
        assertEq(instance.user1(), user1);
        assertEq(instance.user2(), user2);
    }

    function testInvalidUserRevert() public {
        vm.startPrank(makeAddr("user3"));
        vm.expectRevert("only user1 or user2 can send");
        instance.sendEther(user1, 1 ether);
        vm.stopPrank();
    }

    function testInsufficientBalance() public {
        vm.startPrank(user1);
        deal(address(instance), 2e18);
        vm.expectRevert("insufficient balance");
        instance.sendEther(user1, 3e18);
        vm.stopPrank();
    }

    function testSendEther() public {
        vm.startPrank(user1);

        deal(address(instance), 1e18);

        // test Send event
        vm.expectEmit(true, true, false, true, address(instance));
        emit Send(user1, 1e18);

        instance.sendEther(user1, 1e18);
        assertEq(address(user1).balance, 1e18);

        vm.stopPrank();      
    }
}
