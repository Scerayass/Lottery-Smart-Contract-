# Lottery-Smart-Contract-
Input:
enter(): This function should be a payable function which should accept the ethers. The amount of ethers the player needs to pay is mentioned in the above rules. For any other amount of ethers, the transaction must revert. Players can enter the lottery pool using this function. After 5 players enter the pool, a player should be randomly picked as a winner and all the ethers in the pool must get transferred to the winner. After this, the pool gets emptied and the current lottery gets completed. The smartcontract should now be set to start a new round of lottery for next 5 players. If a player has already entered the active lottery pool, then the player cannot re enter, unless the player withdraws and enters the lottery again.

 

withdraw(): Using this function, a player can withdraw from the lottery pool. If the player is not part of the current active pool, then the player can not withdraw due to which the transaction should revert.

 

Output:
viewParticipants() view returns (address[], uint numberOfParticipants): This function must have stateMutatbility as view. It must return :

a. an array of addresses of players who have put their eth in the current pool of the active lottery. The addresses in the array must be in the order of the participation of the players.
b. and, the number of players who have participated in the current active lottery. The function should return 0 if no player has participated yet.
 

viewPreviousWinner() view returns (address): This function should return the winner of previous lottery. If no lottery has been completed till now, then the function must revert.

 

viewEarnings() view returns (uint): This function must return the ethers in wei units which have been earned by Gavin as profit from the contract. Also, this function must only be accessible to Gavin.

 

viewPoolBalance() view returns (uint): This function must return the ethers in wei units which is the amount of ethers present in the pool or the deployed lottery contract.
