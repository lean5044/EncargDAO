// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract EliseoNFT is ERC721 {
    address public admin;
    uint256 public totalSupply; // Contador manual de NFTs emitidos

    constructor() ERC721("EliseoNFT", "ELI") {
        admin = msg.sender;
    }

    function mintNFT(address to, uint256 tokenId) external {
        require(msg.sender == admin, "Only admin can mint NFTs");
        _mint(to, tokenId);
        totalSupply++; // Incrementa el contador
    }
}
