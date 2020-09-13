const path = require("path");

module.exports = {
  // See <http://truffleframework.com/docs/advanced/configuration>
  // to customize your Truffle configuration!
  contracts_build_directory: path.join(__dirname, "client/src/contracts"),
  networks: {
    development: {
      host: "127.0.0.1",
      port: 7545,
      network_id: "5777"
    }
  } ,
  // 設定solidity版本，預設是5.0.0
  compilers: {
    solc: {
      version: '^0.4.25',
      settings: {
        optimizer: {
          enabled: true,
          runs: 200
        }
      }
    }
  },
};
