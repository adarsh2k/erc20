require('babel-register');
require('babel-polyfill');

module.exports = {
  contracts_build_directory: "./build",
  compilers: {
    solc: {
      version: '0.5.0'
    }
  },
  networks: {
    development: {
      host: "127.0.0.1",
      port: 7545,
      network_id: "*"
    }
  }
};
