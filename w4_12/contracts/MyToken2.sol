
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
contract MyToken2 is ERC20  {
     constructor() ERC20("token B Coin", "TBC") {
        _mint(msg.sender, 1000000 * 10 ** 18);
    }
}
