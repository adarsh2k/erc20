let campaignToken = artifacts.require("./Campaign.sol");

module.exports = function(deployer) {
    deployer.deploy(campaignToken);
};
