# S-TokenII

SToken SToken is a permissioned ERC-20 smart contract that can represent ownership of secu- rities. It is compatible with all existing wallets and exchanges that support the ERC-20 token standard, but it overrides the existing ERC-20 transfer method to check with an on-chain Regulator Service for trade approval.

An Smart Contract clusterin to multimanage digital assets. This protocol aims to create a working environment between Regulatory entities or any other kind of Corporate Finance structure, and, the producers of the goods/services willing to be tokenized.

This protocol should be improved in terms to leverage UNISWAP technology with thes best resilente and gast-costing. To create a Javascript-level contract between both entities in the scope of DeFi interactions.

Key elements // Trade Manager: Compilance checker and liquidity manager. // SToken: Full controled by the company. Deployed as agreed between both Parts // Proxi contract: Routes the R-Token to the correct version of the Regulator Service

Roles: Any of the specific restriction that applies to any executor Functions: All those to be execute in the chosen DLT environment.

Trade Manager Admin - (for frontend interactions) +Function Add.Admin (onlyowner) +Function Remove.Admin (onlyowner)

Function Add.Whitelister Function Add.to.whitelist (only whitelister) Function Whitelisted? (bool)

Function ReplaceTradeManager

Function Transfer.From

Pausable (admin) Paused (bool)

///////////Meterias una funcion para gestionar la liquidez de Uniswap desde este smart contract?

S-Tokens Constr [] Function Transfer (check whitelist) Function Set.Minter (only owner) Function Mint

Function Increase.Allowance Funtion zero.allowance Allowance? (sats)