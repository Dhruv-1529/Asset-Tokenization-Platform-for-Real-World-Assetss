// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title AssetTokenization
 * @dev Tokenizes real-world assets as ERC721 NFTs with metadata
 */
contract AssetTokenization is ERC721URIStorage, Ownable {
    uint256 public nextTokenId;

    struct AssetInfo {
        string assetName;
        string metadataURI;
        uint256 tokenId;
        address originalOwner;
    }

    mapping(uint256 => AssetInfo) public tokenizedAssets;

    event AssetTokenized(address indexed owner, uint256 indexed tokenId, string assetName, string metadataURI);

    constructor() ERC721("RealWorldAsset", "RWA") Ownable(msg.sender) {}

    /**
     * @dev Mints a new NFT representing a tokenized real-world asset
     * @param _assetName Name of the real-world asset
     * @param _tokenURI Metadata URI (off-chain proof/details of asset)
     */
    function tokenizeAsset(string memory _assetName, string memory _tokenURI) external {
        uint256 tokenId = nextTokenId;
        _mint(msg.sender, tokenId);
        _setTokenURI(tokenId, _tokenURI);

        tokenizedAssets[tokenId] = AssetInfo({
            assetName: _assetName,
            metadataURI: _tokenURI,
            tokenId: tokenId,
            originalOwner: msg.sender
        });

        emit AssetTokenized(msg.sender, tokenId, _assetName, _tokenURI);
        nextTokenId++;
    }

    /**
     * @dev Returns details of a tokenized asset
     */
    function getAssetDetails(uint256 tokenId) external view returns (
        string memory assetName,
        string memory metadataURI,
        address originalOwner
    ) {
        AssetInfo storage asset = tokenizedAssets[tokenId];
        return (
            asset.assetName,
            asset.metadataURI,
            asset.originalOwner
        );
    }
}
