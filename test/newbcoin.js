const { assert } = require("chai");

const NewbCoin = artifacts.require("NewbCoin");

contract('NewbCoin', (accounts) => {
  it('should put 10000 NewbCoin in the first account', async () => {
    const newbCoinInstance = await NewbCoin.deployed();
    const balance = await newbCoinInstance.getBalance.call(accounts[0]);

    assert.equal(balance.valueOf(), 10000, "10000 wasn't in the first account");
  });
  
  it('should call a function that depends on a linked library', async () => {
    const newbCoinInstance = await NewbCoin.deployed();
    const newbCoinBalance = (await newbCoinInstance.getBalance.call(accounts[0])).toNumber();
    const newbCoinEthBalance = (await newbCoinInstance.getBalanceInEth.call(accounts[0])).toNumber();

    assert.equal(newbCoinEthBalance, 2 * newbCoinBalance, 'Library function returned unexpected function, linkage may be broken');
  });

  it('tax should exist', async() => {
    const newbCoinInstance = await NewbCoin.deployed();

    const tax = await newbCoinInstance.tax();
    assert.notEqual(tax, 0, "Tax value returned 0");
    assert.equal(tax, 10, "Tax did not equal 10%");
  });

  it('should send coin correctly', async () => {
    const newbCoinInstance = await NewbCoin.deployed();

    // Setup 2 accounts.
    const accountOne = accounts[0];
    const accountTwo = accounts[1];

    // Get initial balances of first and second account.
    const accountOneStartingBalance = (await newbCoinInstance.getBalance.call(accountOne)).toNumber();
    const accountTwoStartingBalance = (await newbCoinInstance.getBalance.call(accountTwo)).toNumber();

    // Make transaction from first account to second.
    const amount = 100;
    await newbCoinInstance.sendCoin(accountTwo, amount, { from: accountOne });

    // Get balances of first and second account after the transactions.
    const accountOneEndingBalance = (await newbCoinInstance.getBalance.call(accountOne)).toNumber();
    const accountTwoEndingBalance = (await newbCoinInstance.getBalance.call(accountTwo)).toNumber();

    // check our tax here
    const tax = await newbCoinInstance.tax();
    const afterTax = amount - (amount / tax);
    assert.notEqual(tax, 0, "Tax value returned 0");

    assert.equal(accountOneEndingBalance, accountOneStartingBalance - amount, "Amount wasn't correctly taken from the sender");
    //assert.equal(accountTwoEndingBalance, accountTwoStartingBalance + afterTax, "Amount wasn't correctly sent to the receiver");
    assert.equal(accountTwoEndingBalance, accountTwoStartingBalance + amount, "Amount wasn't correctly sent to the receiver");
  
  });
});