// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {WETH} from "../../src/week6/WETH.sol";

contract WETHTest is Test {
    WETH public instance;
    address public user1;
    address public user2;

    event Transfer(address indexed from, address to, uint256 amount);
    event Approval(address indexed owner, address spender, uint256 amount);
    event Deposit(address indexed from, address to, uint256 amount);
    event Withdraw(address indexed from, address to, uint256 amount);

    function setUp() public {
        user1 = makeAddr("Alice");
        user2 = makeAddr("Bob");
        instance = new WETH("Wrapped Ether", "WETH", 18, 100 ether);
    }

    // 測項 11: 測試 constructor
    function testContructor() public {
        assertEq(instance._name(), "Wrapped Ether");
        assertEq(instance._symbol(), "WETH");
        assertEq(instance._decimals(), 18);
    }

    function testDeposit() public {
        vm.startPrank(user1);
        deal(user1, 1 ether);

        // 測項 3: deposit 應該要 emit Deposit event
        vm.expectEmit(true, false, false, true, address(instance));
        emit Deposit(user1, address(instance), 1 ether);
        instance.deposit{value: 1 ether}();

        // 測項 2: deposit 應該將 msg.value 的 ether 轉入合約
        assertEq(address(instance).balance, 1 ether);

        // 測項 1: deposit 應該將與 msg.value 相等的 ERC20 token mint 給 user
        assertEq(instance.balanceOf(user1), 1e18);

        // 測項 12: transfer 應該要 emit Transfer event
        vm.expectEmit(true, false, false, true, address(instance));
        emit Transfer(user1, user2, 1e18);
        instance.transfer(user2, 1e18);

        // 測項 7: transfer 應該要將 erc20 token 轉給別人
        assertEq(instance.balanceOf(user1), 0);
        assertEq(instance.balanceOf(user2), 1e18);
        vm.stopPrank();
    }

    function testWithdraw() public {
        vm.startPrank(user1);
        deal(user1, 1 ether);
        instance.deposit{value: 1 ether}();

        // 測項 6: withdraw 應該要 emit Withdraw event
        vm.expectEmit(true, false, false, true, address(instance));
        emit Withdraw(address(instance), user1, 1 ether);
        instance.withdraw(1 ether);

        // 測項 4: withdraw 應該要 burn 掉與 input parameters 一樣的 erc20 token
        assertEq(address(instance).balance, 0);

        // 測項 5: withdraw 應該將 burn 掉的 erc20 換成 ether 轉給 user
        assertEq(address(user1).balance, 1 ether);

        // 測項 14: withdraw 超過 balnace 應該要出現 Error "Insufficient balance"
        vm.expectRevert("Insufficient balance");
        instance.withdraw(1 ether);
        vm.stopPrank();
    }

    function testApprove() public {
        vm.startPrank(user1);
        deal(user1, 1 ether);
        instance.deposit{value: 1 ether}();

        vm.expectEmit(true, false, false, false, address(instance));
        emit Approval(user1, user2, 2e18);
        instance.approve(user2, 2e18);

        // 測項 8: approve 應該要給他人 allowance
        assertEq(instance._allowance(user1, user2), 2e18);
        vm.stopPrank();

        vm.startPrank(user2);

        // 測項 13: transferFrom 應該要 emit Transfer event
        vm.expectEmit(true, false, false, false);
        emit Transfer(user1, user1, 1e18);
        instance.transferFrom(user1, user2, 1e18);

        // 測項 10: transferFrom 後應該要減除用完的 allowance
        assertEq(instance._allowance(user1, user2), 1e18);

        // 測項 9: transferFrom 應該要可以使用他人的 allowance
        assertEq(instance._balanceOf(user2), 1e18);

        // 測項 15: transferFrom 超過 allowance 應該要出現 Error "Insufficient allowance"
        vm.expectRevert("Insufficient allowance");
        instance.transferFrom(user1, user2, 4e18);

        // 測項 16: transferFrom 超過 balance 應該要出現 Error "Insufficient balance"
        vm.expectRevert("Insufficient balance");
        instance.transferFrom(user1, user2, 1e18);
        vm.stopPrank();
    }
}
