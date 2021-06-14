// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./ERC20.sol";
import "./Context.sol";

/**
 * @dev Extension of {SecurityToken} that allows minting of tokens with a preset 1.5% management fee.
 */
abstract contract ERC20MintWithFee is Context, ERC20 {


    /**
     * @dev Creates `amount - 1.5%` new tokens for `to` plus 0.5% fee for each admin (3 admins).
     *
     * See {ERC20-_mint}.
     *
     * Requirements:
     *
     * - the caller must have the `MINTER_ROLE`.
     */

    function _mint(address to, uint256 amount) internal virtual override returns (bool) {

        uint256 fee = amount*995/1000;
        uint256 mintAmount = amount-(fee*3);

        _mint(to, mintAmount);
        _mint(admin1, fee);
        _mint(admin2, fee);
        _mint(admin3, fee);

        return true;
    }
}
