// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

import "hardhat/console.sol";
import "./libraries/Base64.sol";

contract SolanoyuGame is ERC721{
    //you need to add imageURI
    // uintの最適化
    struct QuizAttributes {
        uint quizIndex;
        string name;
        string imageURI;
        uint giveUp;
        uint good;
        uint commentAmount;
    }

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    QuizAttributes[] defaultQuiz;

    mapping(uint256 => QuizAttributes) public nftHolderAttributes;
    mapping(address => uint256) public nftHolders;

    event QuizNFTMinted(address sender, uint256 tokenId);

    constructor()ERC721("QuizQuest", "hogehoge"){
        console.log("THIS IS MY GAME CONTRACT.");
        _tokenIds.increment();
    }
    
    //you need to get imageURI and mint it
    function mintQuizNFT(uint _quizIndex, string memory _title, string memory _imageURI, uint _giveUp, uint _good, uint _commentAmount) external {
        uint256 newItemId = _tokenIds.current();

        _safeMint(msg.sender, newItemId);
        nftHolderAttributes[newItemId] = QuizAttributes({
            quizIndex: _quizIndex,
            name: _title,
            imageURI: _imageURI,
            giveUp: _giveUp,
            good: _good,
            commentAmount: _commentAmount
        });
        console.log("Minted NFT w/ tokenID %s", newItemId);
        nftHolders[msg.sender] = newItemId;
        _tokenIds.increment();
        emit QuizNFTMinted(msg.sender, newItemId);
}

function tokenURI(uint256 _tokenId) public view override returns (string memory) {
    QuizAttributes memory quizAttributes = nftHolderAttributes[_tokenId];
    string memory strGiveUp = Strings.toString(quizAttributes.giveUp);
    string memory strGood = Strings.toString(quizAttributes.good);
    string memory strCommentAmount = Strings.toString(quizAttributes.commentAmount);

    string memory json = Base64.encode(
        abi.encodePacked(
        '{"name": "',
        quizAttributes.name,
        ' -- NFT #: ',
        Strings.toString(_tokenId),
        '", "description": "This is an QuizeQuest NFT", "image": "',
        quizAttributes.imageURI,
        '", "attributes": [ { "trait_type": "GiveUpAmount", "value": ',strGiveUp,'}, { "trait_type": "GoodAmount", "value": ',
        strGood,'}, { "trait_type": "CommentAmount", "value": ',strCommentAmount,'} ]}'
        )
    );

    string memory output = string(
        abi.encodePacked("data:application/json;base64,", json)
    );
    return output;
}
    function getNftData() public view returns (QuizAttributes memory) {
        return nftHolderAttributes[nftHolders[msg.sender]];
    }
}