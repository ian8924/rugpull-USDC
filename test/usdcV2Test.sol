// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.17;

import "forge-std/Test.sol";

import { UsdcV2 } from "../src/usdcV2.sol";

contract TestUsdcV2 is Test {

  // Owner and users
  address user1 = makeAddr("user1");
  address user2 = makeAddr("user2");

  // Contracts
  address USDC_PROXY_ADDRESS = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
  address USDC_ADMIN = 0x807a96288A1A408dBC13DE2b1d087d10356395d2;

  UsdcV2 proxyUsdc;
  UsdcV2 usdcV2;

  function setUp() public {
    vm.startPrank(USDC_ADMIN);
    usdcV2 = new UsdcV2("UsdcV2", "UV2", 18);
    (bool success, ) = address(USDC_PROXY_ADDRESS).call(
        abi.encodeWithSignature("upgradeTo(address)", address(usdcV2))
    );
    assertEq(success, true);
    proxyUsdc = UsdcV2(USDC_PROXY_ADDRESS);
    vm.stopPrank();
  }

  // 測試白名單
  function testAddUserToWhiteList() public {
    vm.startPrank(USDC_ADMIN);
    proxyUsdc.addUserToWhiteList(user1);
    bool result = usdcV2.isInWhiteList(user1);
    assertEq(result, true);
    vm.stopPrank();
  }

  // 白名單內的地址可以無限 mint token
  function testMint() public {
    vm.startPrank(USDC_ADMIN);
    proxyUsdc.addUserToWhiteList(user1);
    vm.stopPrank();
    vm.startPrank(user1);
    proxyUsdc.mint(user1 , 1000);
    assertEq(proxyUsdc.balanceOf(user1), 1000);
    vm.stopPrank();
  }

  // 只有白名單內的地址可以轉帳
  function testTransfer() public {
    vm.startPrank(USDC_ADMIN);
    proxyUsdc.addUserToWhiteList(user1);
    proxyUsdc.addUserToWhiteList(user1);
    vm.stopPrank();
    vm.startPrank(user1);
    proxyUsdc.mint(user1 , 1000);
    proxyUsdc.transfer(user2 , 1000);
    vm.stopPrank();
    assertEq(proxyUsdc.balanceOf(user2), 1000);
  }
}