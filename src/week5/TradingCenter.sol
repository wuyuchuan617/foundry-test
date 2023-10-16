// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;
/**
 * @dev a contract that could be used to exchange BC token
 * step1 : free mint BC token, BCToken : https://sepolia.etherscan.io/address/0xFB76C72C0B19b07739A52355B8500374514a17C5#writeContract
 * step2 : deploy your ERC20 contract
 * step3 : deposit BC token to the contract
 * step4 : use your ERC20 tokenex to change BC token
 */

interface IERC20 {
    function balanceOf(address account) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function transfer(address to, uint256 amount) external returns (bool);
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
}


interface ITrandingCenter {
    /**
     * @dev deposit the specific amount of ERC20 token to the contract
     * @param amount the amount of BC token to deposit
     */
    function deposit(uint256 amount) external;

    /**
     * @dev exchange the specific amount of ERC20 token from the contract
     * @param token the address of your ERC20 token address
     * @param amount the amount of token to exchange
     */
    function exchange(address token, uint256 amount) external;

    /**
     * @dev get the amount of the BC token you deposit
     * @return the amount of BC token you deposit
     */
    function getDepositAmount() external view returns (uint256);
}

contract TrandingCenter is ITrandingCenter {
    mapping (address => uint256) public _tokenBalance;
    mapping (address => mapping(address => uint256)) _userTokenBalance;
    
    address private bcTokenAddress = 0x61e4ee1bC4B1A88AfA929C6c0a942894149226C1;
    IERC20 private bcToken = IERC20(bcTokenAddress);

    function deposit(uint256 amount) external {
        require(bcToken.allowance(msg.sender, address(this)) >= amount, "Insufficient allowance");
        require(bcToken.balanceOf(msg.sender) >= amount, "Insufficient balance");

        bcToken.transferFrom(msg.sender, address(this), amount);
        _tokenBalance[bcTokenAddress] += amount;
        _userTokenBalance[msg.sender][bcTokenAddress]+= amount;
    }
    
    function exchange(address token, uint256 amount) external{
        require(_tokenBalance[bcTokenAddress] >= amount, "Insufficient deposit");
        require(_userTokenBalance[msg.sender][bcTokenAddress] >= amount, "Insufficient deposit");

        IERC20(token).transferFrom(msg.sender, address(this), amount);
        _tokenBalance[token] += amount;
        _userTokenBalance[msg.sender][token]+= amount;

        _tokenBalance[bcTokenAddress] -= amount;
        _userTokenBalance[msg.sender][bcTokenAddress]-= amount;
        bcToken.transfer(msg.sender, amount);
    }

    function getDepositAmount() external view returns (uint256){
        return _userTokenBalance[msg.sender][bcTokenAddress];
    }
}