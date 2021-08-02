// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./ERC20.sol";
import "./Context.sol";

/**
 * @dev Extension of {SecurityToken} that allows minting of tokens with a preset 1.5% management fee.
 */
abstract contract ERC20MintWithFee is Context, ERC20 {


    /**
     * @dev Creates `amount - 1.5%` new tokens for `to` plus 1.5% fee for the fee receiver.
     *
     * See {ERC20-_mint}.
     *
     * Requirements:
     *
     * - the caller must have the `MINTER_ROLE`.
     */

    function _mint(address to, uint256 amount) internal virtual override returns (bool) {

        uint256 fee = amount*985/1000;
        uint256 mintAmount = amount-(fee);

        _mint(to, mintAmount);
        _mint(receiver, fee);


        return true;
    }
}
