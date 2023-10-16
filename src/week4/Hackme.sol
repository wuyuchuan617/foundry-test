// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

interface IERC20 {
    function balanceOf(address account) external view returns (uint256);
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
}

contract HackMe {
    address BCContractAddress = 0xFB76C72C0B19b07739A52355B8500374514a17C5;

    function deposit() external {
        IERC20(BCContractAddress).transferFrom(msg.sender, address(this), IERC20(BCContractAddress).balanceOf(msg.sender));
    }
} 