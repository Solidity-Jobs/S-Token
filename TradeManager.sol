// SPDX-License-Identifier: MIT

pragma solidity 0.8.0;

import "./access/AccessControl.sol";

contract TradeManager is AccessControl {

    mapping (address => bool) private _isWhitelisted;

    event Whitelisted(address indexed account);
    event Blacklisted(address indexed account);

    bytes32 public constant WHITELISTER_ROLE = keccak256("WHITELISTER_ROLE");

    constructor(address _whitelister) {
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _setupRole(WHITELISTER_ROLE, _whitelister);
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
    
    //Whitelist multiple accounts at once by passing an array of addresses
    function batchWhitelist(address[] memory users) public onlyRole(WHITELISTER_ROLE) {
        
        uint8 i = 0;
        for (i; i < users.length; i++) {
            whitelistAccount(users[i]);
        }
    }

    //Add whitelister - Only Admin
    function addWhitelister(address account) public onlyRole(getRoleAdmin(WHITELISTER_ROLE)) {
        grantRole(WHITELISTER_ROLE, account);
    }
    
    //Remove whitelister - Only Admin
    function removeWhitelister(address account) public onlyRole(getRoleAdmin(WHITELISTER_ROLE)) {
        revokeRole(WHITELISTER_ROLE, account);
    }
}
