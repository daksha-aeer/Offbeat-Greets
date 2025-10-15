// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Escrow {

    struct TokenCount {
        address sender;
        uint256 amount;
        bool isClaimed;
    }
    mapping(string=>TokenCount) public counts;

    address public immutable authorizedContract;
    address public immutable tokenAddress;

    event TokensDeposited(string uniqueId, address indexed sender, uint256 amount);
    event TokensClaimed(string uniqueId, address indexed receiver, uint256 amount);

    constructor (address _authorizedContract, address _tokenAddress){
        require(_authorizedContract != address(0), "Invalid address");
        require(_tokenAddress != address(0), "Invalid token address");
        authorizedContract = _authorizedContract;
        tokenAddress = _tokenAddress;
    }

    modifier onlyAuthorizedContract() {
        require(msg.sender == authorizedContract, "Not authorized");
        _;
    }

    function deposit(address _sender, string _uniqueId, uint256 _tokens) external onlyAuthorizedContract {
        counts[uniqueId] = TokenCount(_sender, _tokens, false)
    }
}