pragma solidity >=0.4.21 <0.7.0;

contract Migrations {
  address public owner;
  uint public last_completed_migration;

  modifier restricted() {
    if (msg.sender == owner) _;
  }

//構造函數，初始化將發送方賦值給owner保存
//msg.sender (address): 信息的發送方 (當前調用)
  constructor() public {  
    owner = msg.sender;
  }

//賦值給last_completed_migration，其中該方法被聲明為restricted
  function setCompleted(uint completed) public restricted {
    last_completed_migration = completed;
  }
}
