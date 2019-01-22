pragma solidity ^0.5.0;

import 'openzeppelin-solidity/contracts/token/ERC20/ERC20Pausable.sol';
import './Campaign.sol';

contract CampaignFactory is ERC20Pausable {

    address[] public deployedCampaigns;
    address public lastDeployedCampaign;

    constructor() public {}

    function deployCampaigns(uint minimum, string name, string symbol) public {
        address token = new Campaign(minimum, msg.sender, name, symbol);
        deployedCampaigns.push(newCampaign);
        lastDeployedCampaign = token;
    }

    function getDeployedCampaigns() public view returns (address[]) {
        return deployedCampaigns;
    }

}
