// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./TradeManager.sol";

contract ERC20Whitelist {

  Whitelist internal whitelist;

  constructor(address _whitelist) {
      whitelist = Whitelist(_whitelist);
  }

  function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual {

    if (from != address(0)) { // When minting tokens
      checkWhitelist(from);
    }
    checkWhitelist(to);
  }
  
  //Verify that _address is whitelisted before a token transfer
  function checkWhitelist(address _address) internal view {
    require(whitelist.isWhitelisted(_address), "Address NOT whitelisted");
  }
  
}
