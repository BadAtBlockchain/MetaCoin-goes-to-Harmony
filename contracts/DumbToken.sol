// SPDX-License-Identifier: MIT
pragma solidity >=0.4.25 <0.7.0;

interface IToken {
    function totalSupply() external view returns (uint);
    function burnPercentage(uint percentage) external returns (bool);
}

contract DumberToken {
    string public name;
}

contract DumbToken is IToken, DumberToken {
    uint supply;

    constructor() public {
        name = "Dumb Token!";
        supply = 10000;
    }

    function totalSupply() external view returns (uint) {
        return supply;
    }

    function burnPercentage(uint percentage) external returns (bool) {
        // don't let us attempt to burn more than 100%
        require(percentage < 100, "Percentage to burn must be less than 100%");

        uint256 toBurn = supply / percentage;
        uint256 newSupply = supply - toBurn;

        supply = newSupply;
        return true;
    }
}