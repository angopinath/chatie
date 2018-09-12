pragma solidity ^0.4.24;
//pragma experimental ABIEncoderV2;

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
    string password;
    uint[] friendsIds;
    mapping (uint => uint) friends;
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
  function createAccount(uint accountId,string name,string password) public {
    uint[] memory friendsIds=new uint[](0);
    account memory a = account(accountId,name,password,friendsIds);
    accounts[accountId] = a;
  }

  //authenticate
  function authenticate(uint accountId,string password) public constant returns (bool) {
    string storage pass=string(accounts[accountId].password);
    if(keccak256(pass) == keccak256(password)){
        return true;
    }else{
        return false;
    }
  }

  //searchAccount
  function searchAccount(uint accountId) public view returns (uint,string) {
    var acc = accounts[accountId];
    require(acc.accountId != 0,"no account found");
    //return (accountId,"gopi");
    return (acc.accountId,acc.name);
  }

  function changeFriendStatus(uint myid,uint frdid,uint stat) internal{
    accounts[myid].friends[frdid]=stat;
  }
  //send new friend request
  function sendFriendRequest(uint myAccountId,uint friendAccountId) public  {
    changeFriendStatus(myAccountId,friendAccountId,3);
    changeFriendStatus(friendAccountId,myAccountId,4);
  }

  //accept friend request
  function acceptFriendRequest(uint myAccountId,uint friendAccountId) public {

    changeFriendStatus(myAccountId,friendAccountId,0);
    changeFriendStatus(friendAccountId,myAccountId,0);

    accounts[myAccountId].friendsIds.push(friendAccountId);
    accounts[friendAccountId].friendsIds.push(myAccountId);

    accounts[myAccountId].friendsMsgs[friendAccountId].unreadCount=0;
    accounts[friendAccountId].friendsMsgs[myAccountId].unreadCount=0;
  }

  //send new messages
  function sendMessage(uint senderId, uint receiverId, string msg1) public {
    uint msgId = block.number;
    uint timestamp = block.timestamp;
    messages[msgId]=message(msgId,msg1,false,timestamp,senderId,receiverId);
    accounts[senderId].friendsMsgs[receiverId].msgIds.push(msgId);
    accounts[receiverId].friendsMsgs[senderId].msgIds.push(msgId);
    accounts[receiverId].friendsMsgs[senderId].unreadCount=accounts[receiverId].friendsMsgs[senderId].unreadCount+1;
  }

  //clear messages
  function clearMessages(uint myAccountId,uint friendAccountId) public {
    accounts[myAccountId].friendsMsgs[friendAccountId]=messageStatus(0,new uint[](0));
  }

  /**
  * sync messages
  * returns array of accountId|username|unreadmsg|status
  */
  function syncMessages(uint myAccountId) public view returns (uint[],bytes32[],uint[],uint[]) {

    account memory acc = accounts[myAccountId];
    uint[] memory ids= new uint[](acc.friendsIds.length);
    bytes32[] memory names= new bytes32[](acc.friendsIds.length);
    uint[] memory unreadmsgcount= new uint[](acc.friendsIds.length);
    uint[] memory statues= new uint[](acc.friendsIds.length);
    for(uint i=0; i<acc.friendsIds.length;i++){
        uint frndid = acc.friendsIds[i];

          account memory friend = accounts[frndid];
          ids[i]=friend.accountId;
          names[i] = strToBytes32(friend.name);
          unreadmsgcount[i] = accounts[myAccountId].friendsMsgs[friend.accountId].unreadCount;
          statues[i] = uint(accounts[myAccountId].friends[friend.accountId]);

        /*
        ids[i]=i;
        names[i]=strToBytes32("gopi");
        unreadmsgcount[i]=4;
        statues[i]=1;
        */
    }
    return (ids,names,unreadmsgcount,statues);
  }

  //get messages
  function getMessages(uint accountId,uint friendId) public view returns (bytes32[]) {
    uint[] memory msgIds = accounts[accountId].friendsMsgs[friendId].msgIds;
    uint startingMsgId = 0;
    if(msgIds.length>200){
      startingMsgId = msgIds.length-200;
    }

    bytes32[] memory msgs= new bytes32[](msgIds.length);
    uint msgcount = 0;
    for(startingMsgId; startingMsgId < msgIds.length; startingMsgId++){
        msgs[msgcount] = strToBytes32(messages[startingMsgId].msg);
        msgcount++;
    }
    return msgs;
  }


  // util - string to bytes32
  function strToBytes32(string memory str) internal pure returns(bytes32 r){
      assembly {
        r := mload(add(str, 32))
        }
  }
  //util- string concat
  function strConcat(string s1,string s2) internal pure returns(string){
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

  //testings

  function checkReqestStatus(uint senderid,uint friendid) public view returns (uint) {
    return uint(accounts[senderid].friends[friendid]);
  }

  function getMessageById(uint id) public view returns(string){
      return messages[id].msg;
  }

  function getFriendsIds(uint myid) public view returns(uint){
      return accounts[myid].friendsIds[0];
  }
  function getFriendMsgs(uint myid, uint frndid) public view returns(uint, uint[]){
      return (accounts[myid].friendsMsgs[frndid].unreadCount, accounts[myid].friendsMsgs[frndid].msgIds);
  }
}
