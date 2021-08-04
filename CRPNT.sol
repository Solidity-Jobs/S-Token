// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./token/ERC20/ERC20.sol";
import "./access/AccessControl.sol";
import "./token/ERC20/extensions/ERC20Burnable.sol";
import "./token/ERC20/extensions/draft-ERC20Permit.sol";
import "./TradeManager.sol";
import "./ERC20whitelist.sol";


contract CRPNT is ERC20Burnable, ERC20Permit, ERC20Whitelist, AccessControl {
    
    bool public mintingFinished = false;
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    address public feeReceiver;


    constructor(string memory _name, string memory _symbol, address _whitelist, address _feeReceiver) ERC20(_name, _symbol) ERC20Permit(_name) ERC20Whitelist(_whitelist) {
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
        feeReceiver = _feeReceiver;
    }
    
    function mint(address to, uint256 amount) public onlyRole(MINTER_ROLE){
        require(!mintingFinished);
        uint256 mintAmount = amount*985/1000;
        uint256 fee = amount-(mintAmount);

        _mint(to, mintAmount);
        _mint(feeReceiver, fee);
    }

    //Admin can permanently end the minting of new tokens
    function finishMinting() public onlyRole(getRoleAdmin(MINTER_ROLE)) {
        mintingFinished = true;
    }

    //Add minter
    function addMinter(address account) public onlyRole(getRoleAdmin(MINTER_ROLE)) {
        grantRole(MINTER_ROLE, account);
    }
    
    //Remove minter
    function removeMinter(address account) public onlyRole(getRoleAdmin(MINTER_ROLE)) {
        revokeRole(MINTER_ROLE, account);
    }
    
    //Override the transfer function to check if addresses are whitelisted
    function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override(ERC20Whitelist, ERC20) {
    super._beforeTokenTransfer(from, to, amount);
    }
    
    //Change whitelist database address
    function changeWhitelist(address _whitelist) public onlyRole(DEFAULT_ADMIN_ROLE) {
        whitelist = Whitelist(_whitelist);
    }
    
    //Change feeReceiver address. Only current receiver can update the address
    function changeFeeReceiver(address _feeReceiver) public {
        require(msg.sender == feeReceiver, "Not allowed");
        feeReceiver = _feeReceiver;
    }

}
