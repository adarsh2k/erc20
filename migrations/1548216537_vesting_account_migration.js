let vestingAccountToken = artifacts.require("./VestingAccount.sol");

module.exports = function(deployer) {
    deployer.deploy(vestingAccountToken);
};
