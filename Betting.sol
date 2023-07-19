// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

contract FootballBet {
    address payable public alice;
    address payable public bob;
    uint public betAmount;
    uint public winner;
    bool public isFinished;
    
    constructor(address payable _alice, address payable _bob, uint _betAmount) {
        alice = _alice;
        bob = _bob;
        betAmount = _betAmount;
    }
    
    function placeBet(uint _winner) public payable {
        require(msg.sender == alice || msg.sender == bob, "You are not a participant of the bet.");
        require(msg.value == betAmount, "You need to bet the exact amount.");
        require(!isFinished, "The bet has already been resolved.");
        winner = _winner;
    }
    
    function resolveBet(uint _winner) public {
        require(msg.sender == alice || msg.sender == bob, "You are not a participant of the bet.");
        require(_winner == 1 || _winner == 2 || _winner == 3, "Invalid winner value.");
        require(!isFinished, "The bet has already been resolved.");
        isFinished = true;
        
        if (winner == _winner) {
            alice.transfer(address(this).balance);
        } else {
            bob.transfer(address(this).balance);
        }
    }
}