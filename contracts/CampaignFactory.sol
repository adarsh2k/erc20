pragma solidity ^0.4.24;

import 'openzeppelin-solidity/contracts/token/ERC20/PausableToken.sol';
import './Campaign.sol';

contract CampaignFactory is PausableToken, Ownable {

    Campaign[] public deployedCampaigns;
    Campaign public lastDeployedCampaign;

    constructor() public {}

    function deployCampaigns(
        uint minimum,
        string memory name,
        string memory symbol
    ) public {
        Campaign token = new Campaign(minimum, msg.sender, name, symbol);
        deployedCampaigns.push(token);
        lastDeployedCampaign = token;
    }

    function getDeployedCampaigns() public view returns (Campaign[] memory) {
        return deployedCampaigns;
    }

    function pause() public onlyOwner {
        if (!paused()) {
            pause();
        }
    }

}
