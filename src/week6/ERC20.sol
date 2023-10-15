// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

interface IERC20 {
    event Transfer(address indexed from, address to, uint256 amount);
    event Approval(address indexed owner, address spender, uint256 amount); // Approval

    function totalSupply() external view returns (uint256); // ecternal
    function balanceOf(address owner) external view returns (uint256); // uint 鑰256
    function transfer(address to, uint256 amount) external returns (bool); //不用 paybe 沒有 eth

    function approve(address spender, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function transferFrom(address owner, address to, uint256 amount) external returns (bool);
}

contract ERC20 is IERC20 {
    string public _name;
    string public _symbol;
    uint256 public _decimals;

    uint256 public _totalSupply;
    mapping(address => uint256) public _balanceOf; // private 位置
    mapping(address => mapping(address => uint256)) public _allowance;

    // forget contrstuvtor
    constructor(string memory name, string memory symbol, uint256 decimals, uint256 initialSupply) {
        _name = name;
        _symbol = symbol;
        _decimals = decimals;
        _totalSupply = initialSupply;
    }

    function totalSupply() external view returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address owner) external view returns (uint256) {
        return _balanceOf[owner];
    }

    function transfer(address to, uint256 amount) external returns (bool) {
        require(to != address(0), "Invalid address"); // forget
        require(_balanceOf[msg.sender] >= amount, "Insufficient balance!");
        _balanceOf[msg.sender] -= amount;
        _balanceOf[to] += amount;
        emit Transfer(msg.sender, to, amount);
        return true;
    }

    function approve(address spender, uint256 amount) external returns (bool) {
        _allowance[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function allowance(address owner, address spender) external view returns (uint256) {
        return _allowance[owner][spender];
    }

    function transferFrom(address owner, address to, uint256 amount) external returns (bool) {
        require(owner != address(0), "Invalid address!");
        require(to != address(0), "Invalid address!");
        require(_allowance[owner][msg.sender] >= amount, "Insufficient allowance!"); //!!!
        require(_balanceOf[owner] >= amount, "Insufficient balance!");
        _allowance[owner][msg.sender] -= amount; //!!!!
        _balanceOf[owner] -= amount;
        _balanceOf[to] += amount;
        emit Transfer(owner, to, amount);
        return true;
    }

    function mint(uint256 amount) external returns (bool) {
        _totalSupply += amount;
        _balanceOf[msg.sender] += amount;
        emit Transfer(address(0), address(msg.sender), amount);
        return true;
    }

    function burn(uint256 amount) external returns (bool) {
        _totalSupply -= amount;
        _balanceOf[msg.sender] -= amount;
        emit Transfer(address(msg.sender), address(0), amount);
        return true;
    }
}
