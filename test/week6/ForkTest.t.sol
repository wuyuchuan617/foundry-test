// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {Counter} from "../../src/week6/Counter.sol";

contract ForkTest is Test {
    // the identifiers of the forks
    uint256 mainnetFork;
    address user1;

    function setUp() public {
        // user1 = address(123);
        mainnetFork = vm.createFork("https://eth-mainnet.g.alchemy.com/v2/S7FGzEEsfVR6BassdzCaK8PLJXl53ZTo");
    }

    // creates a new contract while a fork is active
    function testFork() public {
        address BAYC = 0xBC4CA0EdA7647A8aB7C2061c2E118A18a936f13D;
        mainnetFork = vm.createFork("https://eth-mainnet.g.alchemy.com/v2/S7FGzEEsfVR6BassdzCaK8PLJXl53ZTo");
        vm.selectFork(mainnetFork);
        vm.rollFork(12299047);

        vm.startPrank(user1);
        deal(user1, 8 ether);
        (bool success,) = address(BAYC).call{value: 1.6 ether}(abi.encodeWithSignature("mintApe(uint)", 20));
        vm.stopPrank();
    }
}
