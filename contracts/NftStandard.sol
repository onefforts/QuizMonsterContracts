// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

import "hardhat/console.sol";

contract NftStandard {
    using Counters for Counters.Counter;
    Counters.Counter private _quizIds;

    constructor(){
        _quizIds.increment();
        console.log("Done initializing");
    }

    event QuizIncremented(address sender, uint256 tokenId);

    mapping(address => uint256[]) public holdingQuiz;
    mapping(uint256 => uint256) public solvedAmount;
    mapping(uint256 => address) public quizHolder;
    mapping(uint256 => address[]) public solver;

    function incrementQuiz() public {
        holdingQuiz[msg.sender].push(_quizIds.current());
        quizHolder[_quizIds.current()] = msg.sender;
        _quizIds.increment();
        console.log("This is msg",msg.sender);
        console.log("This is Id",_quizIds.current()-1);
        emit QuizIncremented(msg.sender, _quizIds.current()-1);
    }

    function incrementSolved(uint256 _quizIndex) public {
        address[] storage player = solver[_quizIndex];
        for(uint i = 0; i < player.length; i++) {
            require(player[i] != msg.sender,"This user has already solved");
        }
        solvedAmount[_quizIndex]++;
        player.push(msg.sender);
    }
}