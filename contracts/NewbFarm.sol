// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract NewbFarm {
    struct StakeInfo {
        bool _isStaking;
        uint256 _timeStarted;
    }

    // mapping(address => bool) public isStaking;
    // mapping(address => uint256) public startTimes;
    mapping(address => StakeInfo) public stakers;

    event Stake(address indexed _addr, uint256 _startTime);
    event Withdraw(address indexed _addr, uint256 _stopTime, uint _yieldTime);

    constructor() {
    }

    function stake(/*uint256 _amount*/) public {
        require(!stakers[msg.sender]._isStaking, "Sender is already staking!");
        //require(_amount > 0, 'You must stake more than 0 tokens');

        uint256 _startTime = block.timestamp;

        // set the state variables to acknowlege the senders stake start time and set their staking state to TRUE
        // NOTE: research and see if we need to create the object or is the mapping already does this for us.
        StakeInfo memory _stakeInfo;
        _stakeInfo._isStaking = true;
        _stakeInfo._timeStarted = _startTime;
        // isStaking[msg.sender] = true;
        // startTimes[msg.sender] = _startTime;
        stakers[msg.sender] = _stakeInfo;

        emit Stake(msg.sender, _startTime);
    }

    function withdraw() public {
        StakeInfo memory _stakeInfo = stakers[msg.sender];
        require(_stakeInfo._isStaking, "Sender is not staking at this time");
        // require(isStaking[msg.sender], "Sender is not staking at this time");
        uint256 _stopTime = block.timestamp;
        
        uint _yieldMinutes = calculateYieldTime(_stakeInfo, _stopTime);

        //isStaking[msg.sender] = false;
        _stakeInfo._isStaking = false;
        stakers[msg.sender] = _stakeInfo;

        emit Withdraw(msg.sender, _stopTime, _yieldMinutes);
    }

    function isAddressStaking() public view returns (bool) {
        return stakers[msg.sender]._isStaking;
    }

    function calculateYieldTime(StakeInfo memory _stakeInfo, uint256 _stopTime) public pure returns(uint){
        uint _totalTime = _stopTime - _stakeInfo._timeStarted;
        uint _totalTimeinMinutes = _totalTime / 60;
        return _totalTimeinMinutes;
    }
}