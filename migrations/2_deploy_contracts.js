var SimpleStorage = artifacts.require("./SimpleStorage.sol");
var Invest = artifacts.require("./Invest.sol");

module.exports = function(deployer) {
  deployer.deploy(SimpleStorage);
  deployer.deploy(Invest);
};

//這個文件是智能合約的部署文件，裡面約定了部署順序，依賴關係。