# S-Token

SToken SToken is a permissioned ERC-20 smart contract that can represent ownership of securities. It is compatible with all existing wallets and exchanges that support the ERC-20 token standard, but it overrides the existing ERC-20 transfer method to check with an on-chain Whitelist Regulator Service for trade approval.

A Smart Contract cluster to multimanage digital assets. This protocol aims to create a working environment between Regulatory entities or any other kind of Corporate Finance structure and the producers of the goods/services willing to be tokenized.

Key elements // Trade Manager: Compliance verifier and liquidity manager. // SToken: Full controled by the company. Deployed as agreed between both Parts // Proxi contract: Routes the R-Token to the correct version of the Regulator Service

Roles: Any of the specific restriction that applies to any executor Functions: All those to be execute in the chosen DLT environment.

Trade Manager Admin - (for frontend interactions) +Function Add.Admin (onlyowner) +Function Remove.Admin (onlyowner)

Function Add.Whitelister Function Add.to.whitelist (only whitelister) Function Whitelisted? (bool)

Function ReplaceTradeManager

Function Transfer.From

Pausable (admin) Paused (bool)

S-Tokens Constr [] Function Transfer (check whitelist) Function Set.Minter (only owner) Function Mint

Function Increase.Allowance Funtion zero.allowance Allowance? (sats)
