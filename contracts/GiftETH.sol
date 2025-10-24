// contracts/GiftETH.sol
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.22;

contract GiftETH {
    address public owner;
    mapping(string => uint256) public balances;

    event Deposit(string indexed purchaseId, uint256 value, address from);
    event Release(string indexed purchaseId, uint256 value, address to);

    constructor() {
        owner = msg.sender;
    }

    function deposit(string calldata purchaseId) external payable {
        require(msg.value > 0, "Must deposit some ETH");
        balances[purchaseId] += msg.value;
        emit Deposit(purchaseId, msg.value, msg.sender);
    }

    function release(string calldata purchaseId, address payable to) external {
        require(msg.sender == owner, "Only owner can release");
        uint256 bal = balances[purchaseId];
        require(bal > 0, "No balance to release");
        balances[purchaseId] = 0;
        to.transfer(bal);
        emit Release(purchaseId, bal, to);
    }
}