// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/draft-ERC20Permit.sol";
import "./TradeManager.sol";
import "./ERC20whitelist.sol";


contract SecurityToken is ERC20Burnable, ERC20Permit, ERC20Whitelist, Ownable {
    
    bool public mintingFinished = false;


    constructor(string memory _name, string memory _symbol, address _whitelist) ERC20(_name, _symbol) ERC20Permit(_name) ERC20Whitelist(_whitelist) {
    }
    
    function mint(address account, uint256 amount) onlyOwner public {
        require(!mintingFinished);
        _mint(account, amount);
    }

    function finishMinting() onlyOwner public {
        mintingFinished = true;
    }
    
    
    function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override(ERC20Whitelist, ERC20) {
    super._beforeTokenTransfer(from, to, amount);
    }

}