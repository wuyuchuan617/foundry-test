// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import {MyContract} from "./MyContract.sol";

contract MyContract2 is MyContract {
    constructor(address _user1, address _user2) MyContract(_user1, _user2) {}

    event Send(address indexed to, uint256 indexed amount);

    function sendEther(address to, uint256 amount) external payable {
        require(msg.sender == user1 || msg.sender == user2, "only user1 or user2 can send");
        require(address(this).balance >= amount, "insufficient balance");
        (bool success,) = to.call{value: amount}("");
        require(success, "transfer failed");
        emit Send(to, amount);
    }
}
