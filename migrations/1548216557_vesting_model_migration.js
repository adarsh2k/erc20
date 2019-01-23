let vestingModelToken = artifacts.require("./VestingModel.sol");

module.exports = function(deployer) {
    deployer.deploy(vestingModelToken);
};
