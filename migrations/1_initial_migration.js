var Migrations = artifacts.require("./Migrations.sol");

module.exports = function(deployer) {
  deployer.deploy(Migrations);
};

//nodejs的寫法，它的作用就是部署了上面的Migrations智能合約
