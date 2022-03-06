// SPDX-License-Identifier: MIT
// Creator: OZ

pragma solidity ^0.8.4;

contract TokenStorage {

    address Whitelist = 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2;

    enum MintStatus {
        NONE,
        PRESALE,
        SALE
    }

    // Compiler will pack this into a single 256bit word.
    struct TokenOwnership {
        // The address of the owner.
        address addr;
        // Keeps track of the start time of ownership with minimal overhead for tokenomics.
        uint64 startTimestamp;
        // Whether the token has been burned.
        bool burned;
        // Custom token URL6 if specified
        string url;
    }

    // Compiler will pack this into a single 256bit word.
    struct AddressData {
        // Realistically, 2**64-1 is more than enough.
        uint64 balance;
        // Keeps track of mint count with minimal overhead for tokenomics.
        uint64 numberMinted;
        // Keeps track of burn count with minimal overhead for tokenomics.
        uint64 numberBurned;
        // whitelisted
        bool whitelisted;
    }

    struct ContractData {
        // Token name
        string name;
        // Token description
        string description;
        // Token symbol
        string symbol;
        // Base URL for tokens metadata
        string baseURL;
        // Contract-level metadata URL
        string contractURL;
        // Is it set or asset?
        bool isEnvelope;
        // Revealed?
        bool isRevealed;
        // Status
        MintStatus mintStatus;
    }

    struct EnvelopeTypes {
        address envelope;
        address[] types;
    }

    struct MintSettings {
        uint8 maxMintPerUser;
        uint8 minMintPerUser;
        uint64 maxTokenSupply;
        uint256 priceOnPresale;
        uint256 priceOnSale;
        uint256 envelopeConcatPrice;
        uint256 envelopeSplitPrice;
    }

    // Contract root address
    address internal _root;

    // The tokenId of the next token to be minted.
    uint256 internal _currentIndex;

    // The number of tokens burned.
    uint256 internal _burnCounter;

    // Contract data
    ContractData internal _contractData;

    // Envelope data
    EnvelopeTypes internal _envelopeTypes;

    // Mint settings
    MintSettings internal _mintSettings;

    // Mapping from token ID to ownership details
    // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
    mapping(uint256 => TokenOwnership) internal _ownerships;

    // Mapping from token ID to approved address
    mapping(uint256 => address) internal _tokenApprovals;

    // Mapping owner address to address data
    mapping(address => AddressData) internal _addressData;

    // Mapping from owner to operator approvals
    mapping(address => mapping(address => bool)) internal _operatorApprovals;

    // Envelope container
    mapping(uint256 => mapping(address => uint256)) internal _assetsEnvelope;
    mapping(address => mapping(uint256 => bool)) internal _assetsEnveloped;

}