//SPDX-License-Identifier:MIT

pragma solidity ^0.8.9;

contract paypal {
 //define the owner of smart contract
 
  address public owner;

  constructor(){
    owner = msg.sender;
  }
 
 
 
  //create struct and manpping for request , transfer and name
  struct request {
    address requestor;
    uint256 amount;
    string message;
    string name;
  }
  struct sentReceive {
    string action;
    uint256 amount;
    string message;
    address otherPartyAddress;
    string otherPartyName;
  }

  struct userName{
       string name;
       bool hasName;
    
  }


  mapping(address => userName) names;
  mapping(address => request[]) requests;
  mapping(address => sentReceive[])history;
 //add a name to wallet address

function addName(string memory _name) public{
    userName storage newUserName = names[msg.sender];
    newUserName.name = _name;
    newUserName.hasName = true;
}


 //create a request
 function createRequest(address user,uint256 _amount , string memory _message) public {
   request memory newRequest;
   newRequest.requestor = msg.sender;
   newRequest.amount = _amount;
   newRequest.message = _message;
   if(names[msg.sender].hasName){
    newRequest.name = names[msg.sender].name;
   }
   requests[user].push(newRequest);


 }
 //pay a request
  function payRequest(uint256 _request) public payable{
     require(_request < requests[msg.sender].length,"No such request");
     request[] storage myRequests = requests[msg.sender];
     request storage payableRequest = myRequests[_request];
     uint256 toPay = payableRequest.amount * 1000000000000000000;
     require(msg.value == (toPay),"Pay Correct amount");
     payable(payableRequest.requestor).transfer(msg.value);
     addHistory(msg.sender,payableRequest.requestor, payableRequest.amount ,payableRequest.message);
     myRequests[_request] = myRequests[myRequests.length-1];
     myRequests.pop();
     


  }

  function addHistory(address sender, address receiver , uint256 _amount ,string memory _message) private{
      sentReceive memory newSend;
      newSend.action = "_";
      newSend.amount = _amount;
      newSend.message = _message;
      newSend.otherPartyAddress = receiver;
      if(names[receiver].hasName){
        newSend.otherPartyName = names[receiver].name;
      }
      history[sender].push(newSend);

     sentReceive memory sentReceives;
      sentReceives.action = "+";
      sentReceives.amount = _amount;
      sentReceives.message = _message;
      sentReceives.otherPartyAddress = receiver;
      if(names[receiver].hasName){
        sentReceives.otherPartyName = names[receiver].name;
      }
      history[receiver].push(sentReceives);
  }
 //get all requests sent to user
 
  function getMyrequests(address _user) public view returns(
    address[] memory,
    uint256[] memory,
    string[]  memory,
    string[]memory){
        address[] memory addrs = new address[](requests[_user].length);
        uint256[] memory amnt = new uint256[](requests[_user].length);
        string[] memory msge = new string[](requests[_user].length);
        string[] memory nme = new string [](requests[_user].length);
          
        for (uint i = 0 ; i < requests[_user].length; i++){
            request storage myRequests = requests[_user][i];
            addrs[i] = myRequests.requestor;
            amnt[i] = myRequests.amount;
            msge[i] = myRequests.message;
            nme[i] = myRequests.name;
        }
        return(addrs,amnt,msge,nme);
    
    }
  


 //get all hitoric transaction user has bee apart of  


 function getMYHistory(address _user) public view returns(sentReceive[] memory){
    return history[_user];
 } 

  function getMYName(address _user) public view returns(userName memory){
    return names[_user];
 } 
}