// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import {ERC721Upgradeable} from "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import {Initializable} from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import {ERC721BurnableUpgradeable} from "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721BurnableUpgradeable.sol"; 
import {StringsUpgradeable} from "@openzeppelin/contracts-upgradeable/utils/StringsUpgradeable.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface Escrow {
    function deposit(address _sender, string calldata _uniqueId, uint256 _tokens) external;
    function claim(string calldata _uniqueId, address _tokenRecipient) external;
}

contract OffbeatGreet is Initializable, ERC721Upgradeable, ERC721BurnableUpgradeable, OwnableUpgradeable {
    using StringsUpgradeable for uint256;
    
    mapping(uint256 => uint256) private _nftTypeSerialCounts;
    mapping(string => address) public uniqueIdToRecipient;
    mapping(string => bool) public isCardClaimed;

    uint256 private constant MAX_NFT_TYPE = 3;
    
    string private _baseTokenURI = "ipfs://bafybeift4r7i2rjs34rl5hnj6sbizzfnf7oecrorvwa4ruznrzhxinqv5y/";

    address public escrowContract;
    address public tokenContract;

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    function initialize(
        address initialOwner, 
        address _escrowContract, 
        address _tokenContract
    ) public initializer {
        __ERC721_init("OffbeatGreet", "OBG");
        __ERC721Burnable_init();
        __Ownable_init(initialOwner);
        
        escrowContract = _escrowContract;
        tokenContract = _tokenContract;
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        uint256 nftType = tokenId >> 128;
        string memory typeString = nftType.toString();
        return string(abi.encodePacked(_baseTokenURI, typeString, ".json"));
    }
    
    function initiateCardSend(
        address to, 
        uint256 nftType, 
        uint256 tokenAmount, 
        string memory uniqueId
    ) public onlyOwner {
        
        require(nftType >= 1 && nftType <= MAX_NFT_TYPE, "Invalid NFT Type.");
        require(to != address(0), "Invalid recipient address.");
        require(!isCardClaimed[uniqueId], "Card already initiated or claimed.");

        uniqueIdToRecipient[uniqueId] = to;

        if (tokenAmount > 0) {
            IERC20(tokenContract).transferFrom(
                msg.sender,
                escrowContract,
                tokenAmount
            );
            
            Escrow(escrowContract).deposit(
                msg.sender,
                uniqueId, 
                tokenAmount
            );
        }
    }

    function claimCard(string memory uniqueId, uint256 nftType) external {
        address intendedRecipient = uniqueIdToRecipient[uniqueId];

        require(msg.sender == intendedRecipient, "You are not the intended recipient.");
        require(!isCardClaimed[uniqueId], "Card already claimed.");
        
        isCardClaimed[uniqueId] = true;

        _nftTypeSerialCounts[nftType] = _nftTypeSerialCounts[nftType] + 1;
        uint256 serialNumber = _nftTypeSerialCounts[nftType];
        uint256 tokenId = (nftType << 128) | serialNumber;
        _safeMint(msg.sender, tokenId);

        Escrow(escrowContract).claim(uniqueId, msg.sender);
    }

    function _baseURI() internal pure override returns (string memory) {
        return "";
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