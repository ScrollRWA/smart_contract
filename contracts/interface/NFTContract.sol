// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v5.1.0) (token/ERC721/IERC721.sol)

pragma solidity ^0.8.20;


interface NFTContract {
    function safeMint(address to, uint256 tokenId, string memory uri) external;
}