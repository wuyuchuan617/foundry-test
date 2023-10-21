// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract Bank {
    // 用來儲存每個地址的餘額
    mapping(address => uint256) private Accounts;

    function deposit() external payable {
        // 存款金額必須大於零才會繼續執行
        require(msg.value > 0, "Amount must be greater than 0");

        // 增加 sender 的餘額
        Accounts[msg.sender] += msg.value;
    }

    function withdraw(uint256 amount) external {
        // 提款金額必須大於零才會繼續執行
        require(amount > 0, "Amount must be greater than 0");

        // sender 餘額必須大於等於提款金額才會繼續執行
        require(Accounts[msg.sender] >= amount, "Insufficient balance");

        // 減少 sender 的餘額
        Accounts[msg.sender] -= amount;

        // 把這個 address 變成 payable 才能收錢
        address payable Receiver = payable(msg.sender);

        // transfer amount 給 sender
        Receiver.transfer(amount);
    }

    function withdrawAll() external {
        require(Accounts[msg.sender] > 0, "0 balance");
        Accounts[msg.sender] = 0;
        address payable Receiver = payable(msg.sender);
        Receiver.transfer(address(this).balance);
    }

    function checkBalance() external view returns (uint256) {
        // 返回 sender 的餘額
        return Accounts[msg.sender];
    }
}
