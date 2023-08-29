// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract eventorginztion {
   struct  events{
       address orginizer;
       string name;
       uint date;
       uint price;
       uint ticketcount;
       uint ticketremain;
   }

   mapping(uint =>events) public evented;
   mapping (address => mapping (uint => uint)) public ticket;
   uint public nextId;
   function CreatEvent(string memory name, uint date, uint price, uint ticketcount) external {
       require(date > block.timestamp,"you can orginize event for future");
       require(ticketcount>0,"you can orginize event only if you more then 0 ticket");
       evented[nextId] = events(msg.sender,name,date,price,ticketcount,ticketcount);
       nextId++;
   }

   function buyticket (uint id , uint quantity) external payable {
       require(evented[id].date!=0 ,"Event does not exist");
       require(evented[id].date > block.timestamp,"you can orginize event for future");
       events storage _event = evented[id];
       require(msg.value == (_event.price * quantity),"Ether is not enough" );
       require(_event.ticketremain >=quantity,"not Enough tickets");
       _event.ticketremain -= quantity;
       ticket[msg.sender][id] += quantity;
       
   }

   function transfertickett( uint id ,uint quantity, address to) external {
       require(evented[id].date!=0,"Event Dones not exist");
       require(evented[id].date>block.timestamp,"Event has already occured");
       require(ticket[msg.sender][id] >=quantity,"you do not have enough ticket");
       ticket[msg.sender][id] -= quantity;
       ticket[to][id] +=quantity;
   }
}