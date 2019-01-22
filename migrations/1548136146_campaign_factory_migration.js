let campaignFactoryToken = artifacts.require("./CampaignFactory.sol");

module.exports = function(deployer) {
    deployer.deploy(campaignFactoryToken);
};
