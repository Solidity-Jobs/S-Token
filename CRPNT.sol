// SPDX-License-Identifier: MIT
pragma solidity 0.8.0;

import "./token/ERC20/ERC20.sol";
import "./access/AccessControl.sol";
import "./token/ERC20/extensions/ERC20Burnable.sol";
import "./token/ERC20/extensions/draft-ERC20Permit.sol";
import "./TradeManager.sol";
import "./ERC20whitelist.sol";


contract CRPNT is ERC20Burnable, ERC20Pausable, ERC20Permit, ERC20Whitelist, AccessControl {
    
    bool public mintingFinished = false;
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
    address public feeReceiver;
    address public proposedFeeReceiver;


    constructor(string memory _name, string memory _symbol, address _whitelist, address _feeReceiver, address _admin, address _minter, address _pauser) ERC20(_name, _symbol) ERC20Permit(_name) ERC20Whitelist(_whitelist) {
        _setupRole(DEFAULT_ADMIN_ROLE, _admin);
        _setupRole(MINTER_ROLE, _minter);
        _setupRole(PAUSER_ROLE, _pauser);
        feeReceiver = _feeReceiver;
    }
    
    function mint(address to, uint256 amount) public onlyRole(MINTER_ROLE){
        require(!mintingFinished, "Minting has been deactivated");
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
    
    //Add pauser
    function addPauser(address account) public onlyRole(getRoleAdmin(PAUSER_ROLE)) {
        grantRole(PAUSER_ROLE, account);
    }
    
    //Remove pauser
    function removePauser(address account) public onlyRole(getRoleAdmin(PAUSER_ROLE)) {
        revokeRole(PAUSER_ROLE, account);
    }
    
    //Override the transfer function to check if addresses are whitelisted
    function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override(ERC20Whitelist, ERC20Pausable, ERC20) {
    super._beforeTokenTransfer(from, to, amount);
    }
    
    //Change whitelist database address
    function changeWhitelist(address _whitelist) public onlyRole(DEFAULT_ADMIN_ROLE) {
        whitelist = TradeManager(_whitelist);
    }
    
    //The current feeReceiver can propose a new feeReceiver. The new account must claimFeeReceiver().
    //This method improves security by checking that the new feeReceiver can indeed operate.
    function proposeFeeReceiver(address _proposedReceiver) public {
        require(msg.sender == feeReceiver, "Only current feeReceiver can propose a new feeReceiver");
        proposedFeeReceiver = _proposedReceiver;
    }
    
    //The proposedFeeReceiver account can claim feeReceiver status to collect minting fees.
    //The new feeReceiver must be first proposed through proposeFeeReceiver().
    function claimFeeReceiver() public {
        require(msg.sender == proposedFeeReceiver, "Caller is not the proposedFeeReceiver");
        feeReceiver = proposedFeeReceiver;
        proposedFeeReceiver = address(0);
    }
    
      /**
     * @dev Triggers stopped state.
     *
     * Requirements:
     *
     * - The contract must not be paused.
     */
    function pause() public virtual whenNotPaused onlyRole(PAUSER_ROLE) {
        _pause();
    }

    /**
     * @dev Returns to normal state.
     *
     * Requirements:
     *
     * - The contract must be paused.
     */
    function unpause() public virtual whenPaused onlyRole(PAUSER_ROLE) {
        _unpause();
    }

}
