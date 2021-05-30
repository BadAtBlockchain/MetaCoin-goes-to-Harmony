const { assert } = require("chai");

const NewbFarm = artifacts.require("NewbFarm");

contract('NewbFarm', (accounts) => {
  let newbfarm

  before(async () => {
    newbfarm = await NewbFarm.deployed()
  })

  it('should allow users to start and stop staking', async () => {
    // attempting to start stake
    result = await newbfarm.stake()
        
    const thrownEvent = result.logs[0].args
    
    var isStaking = await newbfarm.isAddressStaking()
    assert.equal(isStaking, true, "Sender is staking")

    // attempting to stop stake
    result = await newbfarm.withdraw()
        
    const thrownEvent2 = result.logs[0].args
    
    isStaking = await newbfarm.isAddressStaking()
    console.log("Time staked (minutes): " + thrownEvent2._yieldTime)
    assert.equal(isStaking, false, "Sender stopped staking")
  });

  it('should only start staking if the user IS NOT currently staking', async () => {
    // attempting to start stake
    result = await newbfarm.stake()
    assert.notEqual(result.logs.length, 0, "Stake event thrown. Function finished")
    
    var isStaking = await newbfarm.isAddressStaking()
    assert.equal(isStaking, true, "Sender is staking")

    result = await newbfarm.stake()
    
    assert.equal(result.logs.length, 0, "No Stake event thrown. Function must have exited on start")
  });

  
  it('should only stop staking if the user IS currently staking', async () => {
    // check that we are staking, we should be from the above test?
    isStaking = await newbfarm.isAddressStaking()
    assert.equal(isStaking, true, "Sender is staking")

    // attempting to stop stake
    result = await newbfarm.withdraw()
    assert.notEqual(result.logs.length, 0, "Withdraw event thrown. Function finished")
  
    // we shouldn't be staking anymore:
    isStaking = await newbfarm.isAddressStaking()
    assert.equal(isStaking, false, "Sender stopped staking")

    // attempt to withdraw our stake once more
    result = await newbfarm.withdraw()

    assert.equal(result.logs.length, 0, "No Withdraw event thrown. Function must have exited on start")
  });
});