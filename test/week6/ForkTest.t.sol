// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.21;

import {Test, console2} from "forge-std/Test.sol";

contract ForkTest is Test {
    // the identifiers of the forks
    uint256 mainnetFork;
    address user1;

    function setUp() public {
        user1 = makeAddr("Bob");
        mainnetFork = vm.createFork("https://eth-mainnet.g.alchemy.com/v2/S7FGzEEsfVR6BassdzCaK8PLJXl53ZTo");
    }

    // creates a new contract while a fork is active
    function testFork() public {
        address BAYC = 0xBC4CA0EdA7647A8aB7C2061c2E118A18a936f13D;
        mainnetFork = vm.createFork("https://eth-mainnet.g.alchemy.com/v2/S7FGzEEsfVR6BassdzCaK8PLJXl53ZTo");
        vm.selectFork(mainnetFork);
        vm.rollFork(12_299_047);

        vm.startPrank(user1);
        deal(user1, 8 ether);

        uint256 beforeBalance = address(BAYC).balance;

        for (uint256 i = 0; i < 5; i++) {
            (bool success,) = address(BAYC).call{value: 1.6 ether}(abi.encodeWithSignature("mintApe(uint256)", 20));
            require(success);
        }
        (bool sb, bytes memory returnData) = address(BAYC).call(abi.encodeWithSignature("balanceOf(address)", user1));
        require(sb);
        (uint256 balanceValue) = abi.decode(returnData, (uint256));
        assertEq(balanceValue, 100);

        uint256 afterBalance = address(BAYC).balance;
        assertEq(afterBalance - beforeBalance, 8 ether);

        vm.stopPrank();
    }
}

// forge test --fork-url https://eth-mainnet.g.alchemy.com/v2/S7FGzEEsfVR6BassdzCaK8PLJXl53ZTo
