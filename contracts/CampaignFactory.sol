pragma solidity ^0.5.0;

import 'openzeppelin-solidity/contracts/token/ERC20/ERC20Pausable.sol';
import './Campaign.sol';

contract CampaignFactory is ERC20Pausable, Ownable {

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

    function pauseContract() public onlyOwner {
        if (!paused()) {
            pause();
        }
    }

}
