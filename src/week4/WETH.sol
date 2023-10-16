// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

contract WETH {
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    event Deposit(address indexed account, uint256 amount);
    event Withdraw(address indexed account, uint256 amount);

    string public name;
    string public symbol;
    uint8 public decimals;
    uint256 _totalSupply;
    mapping (address => uint256) _balance;
    mapping (address => mapping(address => uint256)) _allowance;


    constructor() {
        name = "Wrapped Ether";
        symbol = "WETH";
        decimals = 18;
    }

    fallback() external payable {
        deposit();
    }

    receive() external payable {
        deposit();
    }

    function deposit() public payable {
        _balance[msg.sender] += msg.value;
        _totalSupply += msg.value;
        emit Deposit(msg.sender, msg.value);
    }

    function withdraw(uint256 amount) external {
        require(_balance[msg.sender] >= amount, "Insufficient balance");
        
        _balance[msg.sender] -= amount;
        _totalSupply -= amount;
        payable(msg.sender).transfer(amount);
        emit Withdraw(msg.sender, amount);
        emit Transfer(address(this), msg.sender, amount);
    }

    function totalSupply() public view returns (uint256){
        return _totalSupply;
    }

    function balanceOf(address who) public view returns (uint256){
        return _balance[who];
    }

    function _transfer(address from, address to, uint value) internal{
        require(_balance[from] >= value, "Not enought token to transfer");
        require(to != address(0), "Send to 0x00 address");
        _balance[from] -= value;
        _balance[to] += value;
        emit Transfer(from, to, value);
    }

    function transfer(address to, uint256 value) public returns (bool){
        _transfer(msg.sender, to, value);
        return true;
    }

    function _approve(address owner, address spender, uint256 value)internal {
        _allowance[owner][spender] = value;
        emit Approval(owner, spender, value);
    }

    function approve(address spender, uint256 value) public returns (bool){
        _approve(msg.sender, spender, value);
        return true;
    }

    function allowance(address owner, address spender) public view returns (uint256){
        return _allowance[owner][spender];
    }

    function transferFrom(address from, address to, uint256 value) public returns (bool){
        require(_allowance[from][msg.sender] >= value, "Not enought allowance to transfer");
        _approve(msg.sender, to, value);
        _transfer(from, to, value);
        return true;
    }
}