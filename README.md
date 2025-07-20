# FaucetBalanceTrap
FaucetBalanceTrap to role
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface ITrap {
    function collect() external view returns (bytes memory);
    function shouldRespond(bytes[] calldata data) external pure returns (bool, bytes memory);
}

contract FaucetBalanceTrap is ITrap {
    address public constant faucet = 0x6Cc9397c3B38739daCbfaA68EaD5F5D77Ba5F455;
    uint256 public constant alertAmount = 32 ether;

    function collect() external view override returns (bytes memory) {
        return abi.encode(faucet.balance);
    }

    function shouldRespond(bytes[] calldata data) external pure override returns (bool, bytes memory) {
        if (data.length < 2) return (false, abi.encodePacked("Insufficient data"));

        // Щоб точно було pure, ми явно копіюємо дані у пам'ять перед decode
        bytes memory currentBytes = data[0];
        bytes memory previousBytes = data[1];

        uint256 current = abi.decode(currentBytes, (uint256));
        uint256 previous = abi.decode(previousBytes, (uint256));

        if (previous > current && previous - current >= alertAmount) {
            return (true, abi.encodePacked("Faucet sent >= 32 ETH"));
        }

        return (false, "");
    }
}
