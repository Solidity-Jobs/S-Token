// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/AccessControl.sol";

contract Whitelist is AccessControl {

    mapping (address => bool) private _isWhitelisted;

    event Whitelisted(address indexed account);
    event Blacklisted(address indexed account);

    bytes32 public constant WHITELISTER_ROLE = keccak256("WHITELISTER_ROLE");

    constructor() {
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _setupRole(WHITELISTER_ROLE, msg.sender);
    }


    //CHECK IF ACCOUNT IS WHITELISTED
    function isWhitelisted(address account) public view virtual returns(bool) {
        return _isWhitelisted[account];
    }

    //WHITELIST NEW ACCOUNT
    function whitelistAccount(address account) public onlyRole(WHITELISTER_ROLE) {
        _isWhitelisted[account] = true;
        emit Whitelisted(account);
    }
    
    //REMOVE ACCOUNT FROM WHITELIST
    function blacklistAccount(address account) public onlyRole(WHITELISTER_ROLE) {
        _isWhitelisted[account] = false;
        emit Blacklisted(account);
    }

    //ADD WHITELISTER
    function addWhitelister(address account) public onlyRole(getRoleAdmin(WHITELISTER_ROLE)) {
        grantRole(WHITELISTER_ROLE, account);
    }
    
    // REMOVE WHITELISTER
    function removeWhitelister(address account) public onlyRole(getRoleAdmin(WHITELISTER_ROLE)) {
        revokeRole(WHITELISTER_ROLE, account);
    }
}
