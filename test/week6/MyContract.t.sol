// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {MyContract} from "../../src/week6/MyContract.sol";

contract CounterTest is Test {
    // 1. Set user1, user2
    // 2. Create a new instance of MyContract
    // 3. (optional) label user1 as bob, user2 as alice

    MyContract public instance;
    address public user1;
    address public user2;

    event Receive(address indexed from, uint256 amount);

    function setUp() public {
        user1 = makeAddr("Bob");
        user2 = makeAddr("Alice");
        instance = new MyContract(user1, user2);
    }

    function testConstructor() public {
        // 1. Assert instance.user1() is user1
        // 2. Assert instance.user2() is user2
        assertEq(instance.user1(), user1);
        assertEq(instance.user2(), user2);
    }

    function testReceiveEther() public {
        // 1. pretending you are user1
        vm.startPrank(user1);

        // 2. let user1 have 1 ether
        deal(user1, 1 ether);

        // 3. test Receive event
        vm.expectEmit(true, false, false, true, address(instance));
        emit Receive(user1, 1 ether);

        // 4. send 1 ether to instance
        (bool sent,) = address(instance).call{value: 1 ether}("");

        require(sent, "Fail");

        // 5. Assert instance has 1 ether in balance
        assertEq(address(instance).balance, 1 ether);

        // 6. stop pretending
        vm.stopPrank();
    }
}
