// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract LockedCRPNT is ERC20, Ownable {
    
    address public CRPNT;
    
    mapping(address => uint256) public unlockTime;//Individual unlock time
    //uint256 public unlockTime;//General unlock time

    
    constructor() ERC20("CRP-LOCKED", "CRP-L") {
        CRPNT = 0xd3753D816FedCbde2e4F93FB948C930442Fd8711;
        _mint(msg.sender, 1000000 ether);
    }
    
    /**
     * @dev Only the contract owner can transfer locked tokens.
     * @param account User address
     * @param amount User amount
     * @param _unlockTime User unlock time
     */
    function _beforeTokenTransfer(address from, address to, uint256 ) internal virtual override(ERC20) {
        if (from != owner()) {
            if (from == address(0)) {
            } else {
            require(to == address(0), "Only the contract owner can transfer locked tokens");
            }
        }
    }
    
    function unlock(uint256 amount) public virtual {
        _unlock(msg.sender, amount);
    }
    
    function unlockMultiple(address[] memory accounts, uint256[] memory amounts) public virtual onlyOwner {
        for (uint256 i = 0; i < accounts.length; i++) {
            _unlock(accounts[i], amounts[i]);
        }
    }
    
    function _unlock(address account, uint256 amount) internal virtual {
        require(block.timestamp >= unlockTime[account], "Tokens locked");//Individual unlock time
        //require(block.timestamp >= unlockTime, "Tokens locked");//General unlock time
        _burn(account, amount);
        IERC20(CRPNT).transfer(account, amount);
    }
    
    function setUnlockTime(address account, uint256 _timestamp) public virtual onlyOwner {
        unlockTime[account] = _timestamp;
    }
    
    function _setUnlockTime(address account, uint256 _timestamp) internal virtual {
        unlockTime[account] = _timestamp;
    }
    
    
    /**
     * @dev Set the amount of locked CRPNT for an account and its unlock time. Only owner can call this function.
     * @param account User address
     * @param amount User amount
     * @param _unlockTime User unlock time
     */
    function setLockedAmount(address account, uint256 amount, uint256 _unlockTime) public virtual onlyOwner {
        _mint(account, amount);
        setUnlockTime(account, _unlockTime);
    }
    
    /**
     * @dev Allows owner to call setLockedAmount for an array of addresess. Only owner can call this function.
     * @param accounts Array of user addresess
     * @param amounts Array of user amounts
     * @param _unlockTime Array of user unlock time
     */
    function setLockedAmounts(address[] memory accounts, uint256[] memory amounts, uint256[] memory _unlockTime) public virtual onlyOwner {
        for (uint256 i = 0; i < accounts.length; i++) {
            setLockedAmount(accounts[i], amounts[i], _unlockTime[i]);
        }
    }
}
