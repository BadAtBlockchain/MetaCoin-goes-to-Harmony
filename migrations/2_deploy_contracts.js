const ConvertLib = artifacts.require("ConvertLib");
const NewbCoin = artifacts.require("NewbCoin");
const DumbToken = artifacts.require("DumbToken");

module.exports = function(deployer) {
  deployer.deploy(ConvertLib);
  deployer.link(ConvertLib, NewbCoin);
  deployer.deploy(NewbCoin);
  deployer.deploy(DumbToken);
};
