// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

interface IERC20 {
    function balanceOf(address account) external view returns (uint256);
}

contract Encode {
    address myTokenAddress = 0xddaAd340b0f1Ef65169Ae5E41A8b10776a75482d;
    IERC20 myToken = IERC20(myTokenAddress);

    event Log(address sender, uint256 value);
    event Log1(address sender, bytes value);

    function getBalanceOf(address user) public returns (uint256) {
        emit Log(msg.sender, myToken.balanceOf(user));
        return myToken.balanceOf(user);
    }

    function callGetTotalSupply(address user) external {
        emit Log(msg.sender, this.getBalanceOf(user));
    }

    function encodeWithSignatureGetTotalSupply(address user) external returns (uint256) {
        (bool success, bytes memory data) = address(this).call(abi.encodeWithSignature("getBalanceOf(address)", user));
        require(success, "Call to getBalanceOf failed");
        uint256 balance = abi.decode(data, (uint256));
        emit Log(msg.sender, balance);
        return balance;
    }

    function encodeWithSelectorGetTotalSupply(address user) external returns (uint256) {
        (bool success, bytes memory data) = address(this).call(abi.encodeWithSelector(this.getBalanceOf.selector, user));
        require(success, "Call to getBalanceOf failed");
        uint256 balance = abi.decode(data, (uint256));
        emit Log(msg.sender, balance);
        return balance;
    }

    function watch_tg_invmru_2f69f1b(address, address) public {}

    // function sign_szabo_bytecode(bytes16,uint128)public{}
}

// internal call vs transaction
