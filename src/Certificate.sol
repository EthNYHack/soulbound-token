// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "solmate/tokens/ERC721.sol";

// import "openzeppelin-contracts/contracts/utils/Strings.sol";

contract Certificate is ERC721 {
    uint256 public tokenId;
    mapping(uint256 => string) public tokenToUri;
    mapping(uint256 => address) public emitterToId;
    mapping(uint256 => bool) public enabled;

    constructor(string memory _name, string memory _symbol)
        ERC721(_name, _symbol)
    {}

    function mintTo(address _receiver, string memory _tokenUri)
        public
        payable
        returns (uint256)
    {
        tokenId++;
        _safeMint(_receiver, tokenId);
        tokenToUri[tokenId] = _tokenUri;
        emitterToId[tokenId] = msg.sender;
        enabled[tokenId] = true;
        return tokenId;
    }

    function transferFrom(
        address,
        address,
        uint256
    ) public pure override {
        revert("Cannot transfer certificate");
    }

    function revoke(uint256 _id) public {
        require(msg.sender == emitterToId[_id], "Not Certificate Emitter");
        enabled[_id] = false;
    }

    function burn(uint256 _id) public {
        require(msg.sender == ownerOf(_id), "Not Certificate Owner");
        _burn(_id);
    }

    function tokenURI(uint256 _id)
        public
        view
        virtual
        override
        returns (string memory)
    {
        return tokenToUri[_id];
    }
}
