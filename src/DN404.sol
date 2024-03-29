// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "DN404/src/DN404.sol";
import "DN404/src/DN404Mirror.sol";
import {Ownable} from "DN404/lib/solady/src/auth/Ownable.sol";
import {LibString} from "DN404/lib/solady/src/utils/LibString.sol";
import {SafeTransferLib} from "DN404/lib/solady/src/utils/SafeTransferLib.sol";

/**
 * @title SimpleDN404
 * @notice Sample DN404 contract that demonstrates the owner selling fungible tokens.
 * When a user has at least one base unit (10^18) amount of tokens, they will automatically receive an NFT.
 * NFTs are minted as an address accumulates each base unit amount of tokens.
 */
contract SimpleDN404 is DN404, Ownable {
    string private _name;
    string private _symbol;
    string private _baseURI;
    string constant _initURI = "https://ipfs.io/ipfs/bafkreicmovbocngbid4jnsofvxvqpiq5jag6qbwnkgkvgnpmpmimt7t3em";

    constructor() { 
        _initializeOwner(msg.sender);

        _name =  "QuackLumxDN404";
        _symbol =  "LMXDN404";

        address mirror = address(new DN404Mirror(msg.sender));
        _initializeDN404(10000 * 10 ** 18, msg.sender, mirror);
    }

    function name() public view override returns (string memory) {
        return _name;
    }

    function symbol() public view override returns (string memory) {
        return _symbol;
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory result) {
        if (bytes(_baseURI).length != 0) {
            result = string(abi.encodePacked(_baseURI, LibString.toString(tokenId)));
            } else {
        result = _initURI;
      }
    }

    // This allows the owner of the contract to mint more tokens.
    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    function setBaseURI(string calldata baseURI_) public onlyOwner {
        _baseURI = baseURI_;
    }

    function withdraw() public onlyOwner {
        SafeTransferLib.safeTransferAllETH(msg.sender);
    }
}