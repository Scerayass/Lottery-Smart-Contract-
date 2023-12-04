// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract LotteryPool {
    address payable  owner;
    
    uint ownerEarnedFee;
    uint poolSize = 5;

    bool lotteryLocked;
    address prevWinner;
    uint poolBalance;

    // currently active players
    address[] enteredAddresses;

    // for withdraw function copying all players excluding msg sender and replace it with enteredAddresses
    address[] withdrawAdresses;
    
    mapping(address => uint) winningCount;
    mapping(address => bool) currentPlayer;
    mapping(address => uint) currentBalance;



    constructor(){
        owner = payable (msg.sender);
        prevWinner = address(0);
    }


    modifier isPlaying(){
        require(currentPlayer[msg.sender] == true,"You are not in this lottery");
        _;
    }


    
    // For participants to enter the pool
    function enter() public payable {
        require(msg.value == 0.1 ether + winningCount[msg.sender]* 0.01 ether , "You entered wrong ether");
        require(currentPlayer[msg.sender] == false , "You have already joined this event");
        require(msg.sender != owner , "Owner cant join this event");
        
        enteredAddresses.push(msg.sender);
        currentPlayer[msg.sender] = true;

        uint fee = msg.value / 10;
        owner.transfer(fee);
        ownerEarnedFee += fee;

        poolBalance += msg.value * 9/10;

        currentBalance[msg.sender] = msg.value * 9/10;

        if (enteredAddresses.length == poolSize){
            uint randomNumber = random(poolSize);
            
            address winner = enteredAddresses[randomNumber];
            payable(winner).transfer(poolBalance);
            winningCount[winner] += 1;
            prevWinner = winner;

            for(uint i = 0; i < poolSize;i++){
                address current = enteredAddresses[i];
                currentBalance[current] = 0;
                currentPlayer[current] = false;
            }
            enteredAddresses = new address[](0);
            poolBalance = 0;

        }

    }

    // For participants to withdraw from the pool
    function withdraw() public isPlaying{

        uint playerBalance = currentBalance[msg.sender];
        poolBalance -= playerBalance;
        payable(msg.sender).transfer(playerBalance);
        currentPlayer[msg.sender] = false;
        currentBalance[msg.sender] = 0;
        
        
        for(uint i = 0 ; i < enteredAddresses.length;i++){
            address player = enteredAddresses[i];
            if(player != msg.sender){
                withdrawAdresses.push(player);
            }
        }
        enteredAddresses = withdrawAdresses;
        withdrawAdresses = new address[](0);

    }

    // To view participants in current pool
    function viewParticipants() public view returns (address[] memory, uint) {
        return (enteredAddresses,enteredAddresses.length);
    }

    // To view winner of last lottery
    function viewPreviousWinner() public view returns (address) {
        require(prevWinner!=address(0) ,"Lottery has not started yet.");
        return prevWinner;
    }

    // To view the amount earned by Gavin
    function viewEarnings() public view returns (uint256) {
        require(msg.sender == owner,"Only Owner can see this");
        return ownerEarnedFee;
    }

    // To view the amount in the pool
    function viewPoolBalance() public view returns (uint256) {
        return poolBalance;
    }

    function random(uint number) public view returns(uint){
        return uint(keccak256(abi.encodePacked(block.timestamp,  
        msg.sender))) % number;
    }
}
