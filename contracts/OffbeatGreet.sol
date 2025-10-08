// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import {ERC721Upgradeable} from "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import {Initializable} from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import {ERC721BurnableUpgradeable} from "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721BurnableUpgradeable.sol"; 
import {StringsUpgradeable} from "@openzeppelin/contracts-upgradeable/utils/StringsUpgradeable.sol";


contract OffbeatGreet is Initializable, ERC721Upgradeable, ERC721BurnableUpgradeable, OwnableUpgradeable {
    using StringsUpgradeable for uint256;
    
    mapping(uint256 => uint256) private _nftTypeSerialCounts;
    
    uint256 private constant MAX_NFT_TYPE = 3;
    
    string private _baseTokenURI = "ipfs://bafybeift4r7i2rjs34rl5hnj6sbizzfnf7oecrorvwa4ruznrzhxinqv5y/";

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    function initialize(address initialOwner) public initializer {
        __ERC721_init("OffbeatGreet", "OBG");
        __ERC721Burnable_init();
        __Ownable_init(initialOwner);
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        uint256 nftType = tokenId >> 128;
        string memory typeString = nftType.toString();
        return string(abi.encodePacked(_baseTokenURI, typeString, ".json"));
    }
    
    function safeMint(address to, uint256 nftType) public onlyOwner returns (uint256) {
        require(nftType >= 1 && nftType <= MAX_NFT_TYPE, "Invalid NFT Type.");

        _nftTypeSerialCounts[nftType] = _nftTypeSerialCounts[nftType] + 1;
        uint256 serialNumber = _nftTypeSerialCounts[nftType];

        uint256 tokenId = (nftType << 128) | serialNumber;
        
        _safeMint(to, tokenId);
        
        return tokenId;
    }

    function _baseURI() internal pure override returns (string memory) {
        return "";
    }
}