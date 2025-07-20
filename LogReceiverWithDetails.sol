// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract LogReceiverWithDetails {
    event FaucetAnomaly(string message, uint256 timestamp, address indexed triggeredBy);

    function log(string calldata message) external {
        emit FaucetAnomaly(message, block.timestamp, msg.sender);
    }
}
