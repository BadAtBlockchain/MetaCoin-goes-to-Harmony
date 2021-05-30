// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract NewbFarm {
    mapping(address => bool) public isStaking;
    mapping(address => uint256) public startTimes;

    event Stake(address indexed _addr, uint256 _startTime);
    event Withdraw(address indexed _addr, uint256 _stopTime, uint _yieldTime);

    constructor() {
    }

    function stake(/*uint256 _amount*/) public {
        require(!isStaking[msg.sender], "Sender is already staking!");
        //require(_amount > 0, 'You must stake more than 0 tokens');

        uint256 _startTime = block.timestamp;

        // set the state variables to acknowlege the senders stake start time and set their staking state to TRUE
        isStaking[msg.sender] = true;
        startTimes[msg.sender] = _startTime;

        emit Stake(msg.sender, _startTime);
    }

    function withdraw() public {
        require(isStaking[msg.sender], "Sender is not staking at this time");
        uint256 _stopTime = block.timestamp;
        
        uint _yieldMinutes = calculateYieldTime(msg.sender, _stopTime);

        isStaking[msg.sender] = false;

        emit Withdraw(msg.sender, _stopTime, _yieldMinutes);
    }

    function isAddressStaking() public view returns (bool) {
        return isStaking[msg.sender];
    }

    function calculateYieldTime(address _addr, uint256 _stopTime) public view returns(uint){
        uint _totalTime = _stopTime - startTimes[_addr];
        uint _totalTimeinMinutes = _totalTime / 60;
        return _totalTimeinMinutes;
    }
}