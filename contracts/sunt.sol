//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/presets/ERC20PresetFixedSupply.sol";

contract SuntToken is ERC20PresetFixedSupply, Ownable {

    using SafeMath for uint256;

    string _name = "Sunt Token";
    string _symbol = "sunt";
    uint256 constant maxSupply = 1000000000000000000000000000;
    uint256 public feeNumer = 5;
    uint256 public feeDenom = 100;
    address public feeAddr;
    bool public isVerifyPair;

    constructor() ERC20PresetFixedSupply(_name, _symbol, maxSupply, msg.sender) {
        isVerifyPair = true;
    }

    mapping (address => bool) public fromBanList;
    mapping (address => bool) public toBanList;
    mapping (address => bool) public pairList;
    mapping (address => bool) public whitelist;

    function _beforeTokenTransfer(address _from, address _to, uint256 _amount) internal virtual override {
        require(!fromBanList[_from], 'Transfer fail because of from address');
        require(!toBanList[_to], 'Transfer fail because of to address');
        emit LogTokenTransfer(_from, _to, _amount);


        // Initiate fee deduction and transfer accounts are not whitelisted
        if(isVerifyPair && !whitelist[_from] && _from != address(0) && _to != address(0)){

            // If from is a pair, to is also a pair: no handling charges are deducted
            // When judging that the pair address is to address, sell or withdraw liquidity and require users to transfer 5% more currency, which is directly deducted.
            if(!pairList[_from] && pairList[_to]){
                uint256 balance = _amount.mul(feeNumer).div(feeDenom);
                if (balance > 0){
                    super._burn(_from, balance);
                    super._mint(address(this), balance);
                }
            }
        }

        super._beforeTokenTransfer(_from, _to, _amount);
    }

    function _afterTokenTransfer(address _from, address _to, uint256 _amount) internal virtual override {

        // Initiate fee deduction and transfer accounts are not whitelisted
        if(isVerifyPair && !whitelist[_from] && _from != address(0) && _to != address(0)){
            // If "from" is pair, then 5% of the account will be transferred to this contract by buying currency and withdrawing liquidity.
            if(pairList[_from] && !pairList[_to]){
                uint256 balance = _amount.mul(feeNumer).div(feeDenom);
                if (balance > 0){
                    super._burn(_to, balance);
                    super._mint(address(this), balance);
                }
            }
        }

        super._afterTokenTransfer(_from, _to, _amount);
    }

    function setToBanList(address _to, bool _status) public onlyOwner {
        toBanList[_to] = _status;
        emit LogSetToBanList(_to, _status);
    }

    function setFromBanList(address _from, bool _status) public onlyOwner {
        fromBanList[_from] = _status;
        emit LogSetFromBanList(_from, _status);
    }

    function setPairList(address pair, bool _status) public onlyOwner {
        pairList[pair] = _status;
        emit LogSetPairList(pair, _status);
    }

    function setWhitelist(address account, bool _status) public onlyOwner {
        whitelist[account] = _status;
        emit LogSetWhiteList(account, _status);
    }

    function setFee(uint256 _feeNumer, uint256 _feeDenom) public onlyOwner {
        feeNumer = _feeNumer;
        feeDenom = _feeDenom;
        emit LogSetFee(feeNumer, feeDenom);
    }

    function setFeeAddr(address _feeAddr) public onlyOwner {
        feeAddr = _feeAddr;
        emit LogSetFeeAddr(feeAddr);
    }

    function setIsVerifyPair(bool _isVerifyPair) public onlyOwner {
        isVerifyPair = _isVerifyPair;
        emit LogSetIsVerifyPair(isVerifyPair);
    }

    function getFee() external {
        require(feeAddr != address(0), "feeAddr !!!");
        super._transfer(address(this), feeAddr, balanceOf(address(this)));
    }

    event LogMint(address, uint256);
    event LogSetToBanList(address, bool);
    event LogSetFromBanList(address, bool);
    event LogSetPairList(address, bool);
    event LogSetWhiteList(address, bool);
    event LogSetFee(uint256, uint256);
    event LogSetIsVerifyPair(bool);
    event LogSetFeeAddr(address);
    event LogTokenTransfer(address, address, uint256);
}