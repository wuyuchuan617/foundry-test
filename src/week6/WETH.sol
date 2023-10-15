// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

interface IERC20 {
    event Transfer(address indexed from, address to, uint256 amount);
    event Approval(address indexed owner, address spender, uint256 amount);

    function totalSupply() external view returns (uint256); 
    function balanceOf(address owner) external view returns (uint256);
    function transfer(address to, uint256 amount) external returns (bool); 

    function approve(address spender, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function transferFrom(address owner, address to, uint256 amount) external returns (bool);
}

contract WETH is IERC20{
    event Withdraw(address indexed from, address to, uint256 amount);
    event Deposit(address indexed from, address to, uint256 amount);

    string public _name;
    string public _symbol;
    uint public _decimals;
    uint256 public _totalSupply;
    mapping(address => uint256) public _balanceOf;
    mapping(address => mapping(address => uint256)) public _allowance;

    constructor(string memory name, string memory symbol, uint256 decimals, uint256 initialSupply){
        _name = name;
        _symbol = symbol;
        _decimals = decimals;
        _totalSupply = initialSupply;
    }

    function totalSupply() external view returns (uint256){
        return _totalSupply;
    }

    function balanceOf(address owner) external view returns (uint256){
        return _balanceOf[owner];
    }

    function transfer(address to, uint256 amount) external returns (bool){
        require(to != address(0), "Invalid address");
        _balanceOf[msg.sender] -= amount;
        _balanceOf[to] += amount;
        emit Transfer(msg.sender, to, amount);
        return true;
    }

    function approve(address spender, uint256 amount) external returns (bool){
        require(spender != address(0), "Invalid address");
        _allowance[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function allowance(address owner, address spender) external view returns (uint256){
        return _allowance[owner][spender];
    }

    function transferFrom(address owner, address to, uint256 amount) external returns (bool){
        require(owner != address(0), "Invalid address");
        require(to != address(0), "Invalid address");
        require(_allowance[owner][to] >= amount, "Insufficient allowance");
        require(_balanceOf[owner] >= amount, "Insufficient balance");
        _allowance[owner][to] -= amount;
        _balanceOf[owner] -= amount;
        _balanceOf[to] += amount;
        emit Transfer(owner, to, amount);
        return true;
    }

    function deposit() external payable returns (bool){
        _balanceOf[msg.sender] += msg.value;
        _totalSupply += msg.value;
        emit Deposit(msg.sender, address(this), msg.value);
        return true;
    }

    function withdraw(uint256 amount) external returns (bool){
        require(_balanceOf[msg.sender] >= amount, "Insufficient balance");
        _balanceOf[msg.sender] -= amount;
        _totalSupply -= amount;
        payable(msg.sender).transfer(amount);
        emit Withdraw(address(this), msg.sender, amount);
        emit Transfer(address(this), msg.sender, amount);
        return true;
    }

    function mint(uint256 amount) external returns (bool) {
        _totalSupply += amount;
        _balanceOf[msg.sender] += amount;
        emit Transfer(address(0), address(this), amount);
        return true;
    }

    function burn(uint256 amount) external returns (bool) {
        _totalSupply -= amount;
        _balanceOf[msg.sender] -= amount;
        emit Transfer(address(this), address(0), amount);
        return true;       
    }
}