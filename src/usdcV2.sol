// 製作一個白名單
// 只有白名單內的地址可以轉帳
// 白名單內的地址可以無限 mint token
// 如果有其他想做的也可以隨時加入
// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.17;

import "solmate/tokens/ERC20.sol";
import "./Ownable.sol";


contract UsdcV2 is ERC20, Ownable {
    // 白名單設置
    mapping (address => bool) public whiteList;
    //  initialize owner
    constructor( string memory _name, string memory _symbol, uint8 _decimals) ERC20 (_name, _symbol, _decimals) {
        initializeOwnable(msg.sender);
    }

    modifier onlyWhiteList(address account) {
        require(whiteList[account], "not in whitelist");
        _;
    }

    function addUserToWhiteList (address user) public onlyOwner {
        whiteList[user] = true;
    }

    function removeUserToWhiteList (address user) public onlyOwner {
        whiteList[user] = false;
    }

    function isInWhiteList(address user) public view returns(bool) {
        return whiteList[user];
    }

    // 只有白名單內的地址可以轉帳
    function transfer(
        address to,
        uint256 amount
    ) public view override onlyWhiteList(msg.sender) onlyWhiteList(to) returns (bool) {
        return true;
    }

    // 白名單內的地址可以無限 mint token
    function mint (address to, uint256 amount) public onlyWhiteList(msg.sender) {
        super._mint(to , amount);
    }

}