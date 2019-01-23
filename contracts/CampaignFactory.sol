pragma solidity ^0.4.24;

import 'openzeppelin-solidity/contracts/token/ERC20/PausableToken.sol';
import "openzeppelin-solidity/contracts/math/SafeMath.sol";

import { Campaign } from './Campaign.sol';
import { VestingAccount } from './token-vesting/VestingAccount.sol';

contract CampaignFactory is PausableToken, Ownable {

    using SafeMath for uint256;

    Campaign[] public deployedCampaigns;
    Campaign public lastDeployedCampaign;
    VestingAccount vestingAccount;
    uint256  _start = block.timestamp;
    uint256 _cliff;
    uint256 _duration;

    constructor() public {}

    function deployCampaigns(
        uint minimum,
        string memory name,
        string memory symbol
    ) public {
         _cliff = _cliff.mul(365 * 24 * 3600 ); // cliff is set to 1 year in seconds
        _duration = _duration.mul(4 * 365 * 24 * 3600 ); //duration is set to 4 year in seconds
        vestingAccount = new VestingAccount(token, _start, _cliff, _duration, true);
        Campaign token = new Campaign(vestingAccount, minimum, msg.sender, name, symbol);
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
