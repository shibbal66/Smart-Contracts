// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract chai{

struct Memo{
    string Name;
    string message;
        uint256 timestamp;

    address from;
}
Memo[] memos;
address payable owner;
constructor() {
  owner = payable(msg.sender);
}
function BuyChai(string calldata name,string calldata message) external payable{
       require(msg.value>0,"Please pay more than zero");
       owner.transfer(msg.value); 
       memos.push(Memo(name,message,block.timestamp,msg.sender));
}
function getMemos() public view returns(Memo[] memory)
{
     return memos;
}
}