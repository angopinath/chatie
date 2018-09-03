pragma solidity ^0.4.24;
pragma experimental ABIEncoderV2;

contract Chat {

  string private DELIMITER="|";

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
    bytes32 password;
    uint[] friendsIds;
    mapping (uint => friendStatus) friends;
    mapping (uint => messageStatus) friendsMsgs;
  }

  struct messageStatus {
    uint unreadCount;
    uint[] msgIds;
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
  function createAccount(uint accountId,string name,bytes32 password) public {
    uint[] memory friends=new uint[](2000);
    accounts[accountId]=account(accountId,name,password,friends);
  }

  //authenticate
  function authenticate(uint accountId,bytes32 password) public returns (bool) {
    require(accounts[accountId].password==password);
    return true;
  }

  //searchAccount
  function searchAccount(uint accountId) public returns (uint,string) {
    if(bytes(accounts[accountId].name).length <0 ) throw;
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
  function sendMessage(uint senderId, uint receiverId, string msg) public {
    uint msgId = block.timestamp;
    uint timestamp = block.timestamp;
    messages[msgId]=message(msgId,msg,false,timestamp,senderId,receiverId);
    accounts[senderId].friendsMsgs[receiverId].msgIds.push(msgId);
    accounts[receiverId].friendsMsgs[senderId].msgIds.push(msgId);
  }

  //clear messages
  function clearMessages(uint myAccountId,uint friendAccountId) public {
    accounts[myAccountId].friendsMsgs[friendAccountId]=messageStatus(0,new uint[](2000));
  }

  /**
  * sync messages
  * returns array of accountId|username|unreadmsg|status
  */
  function syncMessages(uint myAccountId) public returns (string[20]) {
    string[20] storage result;
    account storage acc = accounts[myAccountId];
    for(uint i=0;i<acc.friendsIds.length && i<20;i++){
      account memory friend = accounts[acc.friendsIds[i]];
      string memory record = strConcat(uint2str(friend.accountId),DELIMITER);
      record = strConcat(record, friend.name);
      record = strConcat(record, DELIMITER);
      record = strConcat(record, uint2str(acc.friendsMsgs[friend.accountId].unreadCount));
      record = strConcat(record, DELIMITER);
      record = strConcat(record, uint2str(uint(acc.friends[friend.accountId])));
      result[i] = record;
    }
  }

  //get messages
  function getMessages(uint accountId,uint friendId) public view returns (string[200]) {
    uint[] memory msgIds = accounts[accountId].friendsMsgs[friendId].msgIds;
    uint startingMsgId = 0;
    if(msgIds.length>200){
      startingMsgId = msgIds.length-200;
    }

    string[200] memory msgs;
    uint msgcount = 0;
    for(startingMsgId; startingMsgId < msgIds.length; startingMsgId++){
        msgs[msgcount] = string(messages[startingMsgId].msg);
        msgcount++;
    }
  }

  //util- string concat
  function strConcat(string s1,string s2) private pure returns(string){
    bytes memory s1bytes=bytes(s1);
    bytes memory s2bytes=bytes(s2);
    bytes memory result=new bytes(s1bytes.length+s2bytes.length);
    uint k=0;

    for(uint i=0;i<s1bytes.length;i++){result[k++]=s1bytes[i];}
    for(i=0;i<s2bytes.length;i++){result[k++]=s2bytes[i];}
    return string(result);
  }
  //util- uint to string
  function uint2str(uint i) internal pure returns (string){
    if (i == 0) return "0";
    uint j = i;
    uint length;
    while (j != 0){
        length++;
        j /= 10;
    }
    bytes memory bstr = new bytes(length);
    uint k = length - 1;
    while (i != 0){
        bstr[k--] = byte(48 + i % 10);
        i /= 10;
    }
    return string(bstr);
  }
}
