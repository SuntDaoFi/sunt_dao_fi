//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface Sunt is IERC20{
    function getFee() external;
}

contract Fee {

    Sunt public sunt;
    using SafeMath for uint256;

    constructor(address _sunt) {
        sunt = Sunt(_sunt);
    }

    function getReward() external{
        sunt.getFee();

        uint256 balance = sunt.balanceOf(address(this));
        // TODO Configuring Related Addresses
        // lp fee
        sunt.transfer(address(0x0000000000000000000000000000000000000000), balance.mul(40).div(100));
        // burn
        sunt.transfer(address(0x000000000000000000000000000000000000dEaD), balance.mul(20).div(100));
        // airdrop
        sunt.transfer(address(0x0000000000000000000000000000000000000000), balance.mul(10).div(100));

        sunt.transfer(address(0x0000000000000000000000000000000000000000), balance.mul(10).div(100));
        sunt.transfer(address(0x0000000000000000000000000000000000000000), balance.mul(10).div(100));
        sunt.transfer(address(0x0000000000000000000000000000000000000000), balance.mul(10).div(100));
    }
}