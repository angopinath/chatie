pragma solidity ^0.4.24;

contract Chat {
  enum friendStatus {
    ACCEPTED,
    REJECTED,
    BLOCKED,
    REQUEST_SENT,
    REQUEST_RECEIVED
  }

  struct account {
    uint accountId;
    string name;
    byte32 password;
    mapping (uint => status) friends;
    mapping (uint => uint[]) messages;
  }

  struct message {
    uint msgId;
    string msg;
    bool isRed;
    uint timestamp;
    uint sender;
    uint receiver;
  }

  mapping (uint => account) accounts;
  mapping (uint => message) messages;

  //create new account
  function createAccount(uint accountId,string name,byte32 password) public {
    accounts[accountId]=account(accountId,name,password);
  }

  //authenticate
  function authenticate(uint accountId,string name) public returns (bool) {
    require(accounts[accountId].password==password);
    return true;
  }

  //searchAccount
  function searchAccount(uint accountId) public returns (uint,string) {
    if(accounts[accountId].name) throw;
    return (accounts[accountId].accountId,accounts[accountId].name);
  }

  //send new friend request
  function sendFriendRequest(uint myAccountId,uint friendAccountId) public returns (bool) {
    accounts[myAccountId].friends[friendAccountId]=friendStatus.REQUEST_SENT;
    accounts[friendAccountId].friends[myAccountId]=friendStatus.REQUEST_RECEIVED;
    return true;
  }

  //accept friend request
  function acceptFriendRequest(uint myAccountId,uint friendAccountId) public returns(bool){
    accounts[myAccountId].friends[friendAccountId]=friendStatus.ACCEPTED;
    accounts[friendAccountId].friends[myAccountId]=friendStatus.ACCEPTED;
    return true;
  }

  //send new messages
  function sendMessage(uint senderId,uint receiverId,string msg) {
    uint msgId = block.blockhash();
    uint timestamp = block.timestamp;
    messages[msgId]=message(msgId,msg,false,timestamp,senderId,receiverId);
    accounts[senderId].messages[receiverId].push(msgId);
    accounts[receiverId].messages[senderId].push(msgId);
  }

  //clear messages
  function clearMessages(uint myAccountId,uint friendAccountId) {
    delete accounts[myAccountId].messages[friendAccountId];
  }

}
