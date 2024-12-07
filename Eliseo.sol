// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract EliseoNFT is ERC721 {
    address public admin;

    constructor() ERC721("Eliseo", "ELI") {
        admin = msg.sender;
    }

    function mintNFT(address to, uint256 tokenId) external {
        require(msg.sender == admin, "Solo el administrador del edificio puede emitir EliseoNFT");
        _mint(to, tokenId);
    }
}
