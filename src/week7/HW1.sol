// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";

contract NoUseful is ERC721 {
    constructor() ERC721("NoUseful", "NUF") {}

    function mint(address to, uint256 tokenId) public {
        _mint(to, tokenId);
    }
}

contract HW_Token is ERC721 {
    constructor() ERC721("Don't send NFT to me", "NONFT") {}

    function mint(address to, uint256 tokenId) public {
        _mint(to, tokenId);
    }

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        return "https://ipfs.io/ipfs/QmXPXhtK2Vdxr6eYz4avcZXiS5fcHdp3qWpa2trmZKm7Sr/0";
    }
}

contract NFTReceiver is IERC721Receiver {
    HW_Token public hwToken;
    NoUseful public noUseful;

    event Transfer(address from, address to, uint256 tokenId);

    constructor(address _hwToken, address _noUseful) {
        hwToken = HW_Token(_hwToken);
        noUseful = NoUseful(_noUseful);
    }

    function onERC721Received(address operator, address from, uint256 tokenId, bytes memory data)
        external
        override
        returns (bytes4)
    {
        if (operator != address(hwToken)) {
            // Transfer the token back to the original owner
            NoUseful(noUseful).transferFrom(address(this), from, tokenId);
            emit Transfer(address(this), from, tokenId);

            // Mint a new NONFT token to the original owner
            HW_Token(hwToken).mint(from, tokenId);
        }

        return this.onERC721Received.selector;
    }
}
