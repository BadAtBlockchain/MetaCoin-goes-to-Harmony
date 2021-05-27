const ConvertLib = artifacts.require("ConvertLib");
const NewbCoin = artifacts.require("NewbCoin");

module.exports = function(deployer) {
  deployer.deploy(ConvertLib);
  deployer.link(ConvertLib, NewbCoin);
  deployer.deploy(NewbCoin);
};
