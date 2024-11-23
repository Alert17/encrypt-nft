// SPDX-License-Identifier: BSD-3-Clause-Clear

pragma solidity ^0.8.24;

import "./fhevm/lib/TFHE.sol";

contract EncryptedNFT {
    
    uint256 public totalSupply;
    string private _name;
    string private _symbol;

    mapping(eaddress owner => uint256) internal balances;

    mapping(uint256 tokenId => eaddress) public ownerOf;

    mapping(eaddress owner => uint256) public tokenIdOf;

    mapping(uint256 => bytes32) public aiAgent;

    /// @dev tokenId => spender => allowance
    mapping(uint256 => mapping (eaddress spender => ebool)) public allowance;

    constructor() {
        _name = "EncryptedNFT";
        _symbol = "eNFT";
    }

    // Returns the name of the token.
    function name() public view virtual returns (string memory) {
        return _name;
    }

    // Returns the symbol of the token, usually a shorter version of the name.
    function symbol() public view virtual returns (string memory) {
        return _symbol;
    }

    // Sets the balance of the owner to the given encrypted balance.
    function mint(einput _owner, bytes calldata inputProof, bytes32 _aiAgent) public {
        eaddress owner = TFHE.asEaddress(_owner, inputProof);
        balances[owner] += 1;
        uint256 tokenId = totalSupply;
        ownerOf[tokenId] = owner;
        tokenIdOf[owner] = tokenId;
        aiAgent[tokenId] = _aiAgent;
        totalSupply++;
    }

    function approve(einput _owner, eaddress spender, ebool _allowance, bytes calldata inputProof) public {
        eaddress owner = TFHE.asEaddress(_owner, inputProof);
        uint256 tokenId = tokenIdOf[owner];
        allowance[tokenId][spender] = _allowance;
    }

    function transfer(uint256 tokenId, einput to, bytes calldata toInputProof) public returns (bool) {
        eaddress _to = TFHE.asEaddress(to, toInputProof);
       //eaddress owner = ownerOf[tokenId];
        
        ownerOf[tokenId] = _to;
        return true;
    }

}