// SPDX-License-Identifier: MIT
pragma solidity >=0.4.25 <0.7.0;

import "./ConvertLib.sol";

// This is just a simple example of a coin-like contract.
// It is not standards compatible and cannot be expected to talk to other
// coin/token contracts. If you want to create a standards-compliant
// token, see: https://github.com/ConsenSys/Tokens. Cheers!

contract NewbCoin {
	uint public tax = 10; // percentage of the transaction
	mapping (address => uint) balances;

	event Transfer(address indexed _from, address indexed _to, uint256 _value);
	event TransactionTax(uint _preTax, uint _postTax, uint _tax);
	event TaxBurn(uint _amount);

	constructor() public {
		balances[tx.origin] = 10000;
	}

	function sendCoin(address _receiver, uint _amount) public {
		require(balances[msg.sender] > _amount, "The senders balance must be more than the amount requested to send");

		balances[msg.sender] -= _amount;

		// tax mechanic here for every transaction, removes the percentage specified in 'uint tax'
		//uint _removed = 0;
		//(_amount, _removed) = _taxTransaction(_amount);
		//_burn(_removed); // Currently does nothing
		balances[_receiver] += _amount;
		
		emit Transfer(msg.sender, _receiver, _amount);
	}

	function getBalanceInEth(address _addr) public view returns(uint) {
		return ConvertLib.convert(getBalance(_addr),2);
	}

	function getBalance(address _addr) public view returns(uint) {
		return balances[_addr];
	}

	function _taxTransaction(uint _amount) private returns(uint postTax, uint removed) {
		uint _toRemove = _amount / tax;
		emit TransactionTax(_amount, (_amount - _toRemove), _toRemove);
		return ((_amount - _toRemove), _toRemove);
	}

	function _burn(uint amount) private returns(bool) {
		require(tax == 0, "Tax value should not equal 0");

		// todo: do we just burn this and 0x0 the amount? Or add it elsewhere
		emit TaxBurn(amount);

		return true;
	}
}
