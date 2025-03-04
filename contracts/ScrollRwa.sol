// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "./interface/NFTContract.sol";


contract ScrollRwa {
  using Strings for uint256;
  address NFTTokenAddress;



  enum SRwaAssetType {
    RealEstate,
    CollectiblesNFT,
    Invoices
  }

  struct SrwaAsset {
    uint256 assetID;
    address assetOwner;
    SRwaAssetType assetType;
    string metadataURI;
    uint256 marketValue;
    bool isCollaterized;
    bool isVerified;
    uint256 verificationTimestamp;
  }

  mapping(address => SrwaAsset) public registeredAssets;
  mapping(address => mapping (uint256 => SrwaAsset)) ownerAsset;
  uint256 registeredAssetID = 1;


  constructor(address _NFTTokenAddress) {
    NFTTokenAddress = _NFTTokenAddress;
  }

  function registerAsset(
    string memory _metaDataURI, 
    uint256 _marketValue,
    uint8 _assetType) external {

      SrwaAsset memory asset = SrwaAsset({
        assetID: registeredAssetID,
        assetOwner: msg.sender,
        assetType: SRwaAssetType(_assetType),
        metadataURI: _metaDataURI,
        marketValue: _marketValue,
        isCollaterized: true,
        isVerified: false,
        verificationTimestamp: block.timestamp
      });

      registeredAssets[msg.sender] = asset;

      ownerAsset[msg.sender][registeredAssetID] = asset;
  }

  function verifyAsset(uint256 _assetId) external {
    ownerAsset[msg.sender][_assetId].isVerified = true;

    require(ownerAsset[msg.sender][_assetId].isVerified == true, "Asset not verified");

    uint256 tokenID = ownerAsset[msg.sender][_assetId].assetID;
    string memory metadataURI = ownerAsset[msg.sender][_assetId].metadataURI;


    NFTContract(NFTTokenAddress).safeMint(msg.sender, tokenID, metadataURI);
  } 

  function transferAsset(address recieverAddress, uint256 _assetID) external {
    uint256 assetExist = ownerAsset[msg.sender][_assetID].assetID;
    require(assetExist > 0, "Asset not tokenized");

    uint256 tokenBalance = IERC721(NFTTokenAddress).balanceOf(msg.sender);
    require(tokenBalance > 0, "You donot have NFT's at the moment");

    bytes memory emptyData = "";

    IERC721(NFTTokenAddress).safeTransferFrom(msg.sender, recieverAddress, assetExist, emptyData);
  }


}