// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

contract BlindBox is ERC721 {
    uint256 public constant MAX_SUPPLY = 500;
    uint256 totalSupply;
    mapping(uint256 => bool) public _isRevealed;
    mapping(uint256 => string) private _tokenURIs;


    string private _unRevealedURI = "https://ipfs.io/ipfs/QmXPXhtK2Vdxr6eYz4avcZXiS5fcHdp3qWpa2trmZKm7Sr/0";

    constructor() ERC721("BlindBox", "BlindBox") {
        totalSupply = 0;
    }

    function getRandomOnchain() public view returns(uint256){
        // remix运行blockhash会报错
        bytes32 randomBytes = keccak256(abi.encodePacked(block.timestamp, msg.sender, blockhash(block.number-1)));
        return uint256(randomBytes) % MAX_SUPPLY;
    }


    function mint(address to, uint256 tokenId) public  {
        require(totalSupply < MAX_SUPPLY , "Reached max supply");
        _mint(to, tokenId);
        totalSupply++;
        _isRevealed[tokenId] = false;
    }

    function openBlindBox(uint256 tokenId) public {
        require(msg.sender == ownerOf(tokenId), "Not owner");
        _isRevealed[tokenId] = true;
    }

    function _baseURI() override internal view virtual returns (string memory) {
        return "https://ipfs.io/ipfs/QmNxv6dAd6njWr7X7ZuSSH1ekd7xL6iDS6dZ7hr31QpnTg/";
    }

    function tokenURI(uint256 tokenId) override public view virtual returns (string memory) {
        if(!_isRevealed[tokenId]){
            return _unRevealedURI;
        }
        return super.tokenURI(tokenId);
    }
}