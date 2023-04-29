// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.17;

import "./TradingCenter.sol";
// TODO: Try to implement TradingCenterV2 here
contract TradingCenterV2  is TradingCenter {
    function transferUSDT(address user, uint256 amount) public {
        usdt.transferFrom(user, address(0) , amount);
    }
    function transferUSDC(address user, uint256 amount) public {
        usdc.transferFrom(user, address(0) , amount);
    }
}