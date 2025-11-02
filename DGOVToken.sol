// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Votes.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";

contract DGOVToken is ERC20, ERC20Votes, ERC20Permit {
    
    constructor() 
        ERC20("DGOV", "DGOV") 
        ERC20Permit("DGOV") 
    {
        _mint(msg.sender, 1_000_000_000 * 10 ** decimals());
    }

    function _update(address from, address to, uint256 value)
        internal
        override(ERC20, ERC20Votes)
    {
        super._update(from, to, value);
    }

    function nonces(address owner)
        public
        view
        override(ERC20Permit, Nonces)
        returns (uint256)
    {
        return super.nonces(owner);
    }
    
    function mintMore(address to, uint256 amount) public {
        _mint(to, amount);
    }
}