// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract ScrollRwa {
  using Strings for uint256;



  enum SRwaAssetType {
    RealEstate,
    CollectiblesNFT,
    Invoices
  }

  struct SrwaAsset {
    address issuerAddr;
    SRwaAssetType assetType;
    string metadataURI;
    uint256 marketValue;
    bool isCollaterized;
    uint256 verificationTimestamp;
  }

  mapping(bytes32 => SrwaAsset) public availableAssets;

  function registerAsset(SRwaAssetType assetType, string memory metadataURI, uint256 marketValue) public {
    bytes32 _assetHash = keccak256(bytes(metadataURI));
    require(availableAssets[_assetHash].metadataURI.length == 0, "Asset Already Registered");
  }




}