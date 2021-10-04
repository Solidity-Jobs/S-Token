// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract LockedCRPNT is ERC20, Ownable {
    
    address public CRPNT;
    
    uint256 public unlockTime;//General unlock time

    
    constructor(uint256 _unlockTime, address _CRPNT) ERC20("CRPNT-LOCKED", "CRPNT-L") {
        CRPNT = _CRPNT;
        unlockTime = _unlockTime;
    }
    
    /**
     * @dev If caller is not the owner, only _mint() and _burn() are allowed.
     * @param from Origin address
     * @param to Destination address
     */
    function _beforeTokenTransfer(address from, address to, uint256 ) internal virtual override(ERC20) {
        if (from != owner()) {
            if (from == address(0)) {
            } else {
            require(to == address(0), "Only the contract owner can transfer locked tokens");
            }
        }
    }
    
    //_unlock() CRPNT for msg.sender.
    function unlock() public virtual {
        _unlock(msg.sender);
    }
    
    //Contract owner can _unlock() for an array of addresess
    function unlockMultiple(address[] calldata accounts) public virtual onlyOwner {
        for (uint256 i = 0; i < accounts.length; i++) {
            _unlock(accounts[i]);
        }
    }
    
    //Burn LockedCRPNT from account and transfer an equal amount of CRPNT to account
    function _unlock(address account) internal virtual {
        //require(block.timestamp >= unlockTime[account], "Tokens locked");//Individual unlock time
        require(block.timestamp >= unlockTime, "Tokens locked");//General unlock time
        uint256 amount = balanceOf(account);
        _burn(account, amount);
        IERC20(CRPNT).transfer(account, amount);
    }
    
    //Set the unlock time in UNIX Timestamp
    function setUnlockTime(uint256 _timestamp) public virtual onlyOwner {
        unlockTime = _timestamp;
    }
    
    
    /**
     * @dev Set the amount of locked CRPNT for an account. LockedCRPNT representing the locked CRPNT amount will be minted.
     * Only owner can call this function.
     * @param account User address that tokens will be minted to.
     * @param amount Token amount to be minted
     */
    function setLockedAmount(address account, uint256 amount) public virtual onlyOwner {
        _mint(account, amount);
    }
    
    /**
     * @dev Allows owner to call setLockedAmount() for an array of addresess. Only owner can call this function.
     * @param accounts Array of user addresess
     * @param amounts Array of user amounts
     */
    function setLockedAmounts(address[] calldata accounts, uint256[] calldata amounts) public virtual onlyOwner {
        for (uint256 i = 0; i < accounts.length; i++) {
            setLockedAmount(accounts[i], amounts[i]);
        }
    }
}
