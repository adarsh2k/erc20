pragma solidity ^0.4.24;

import "openzeppelin-solidity/contracts/token/ERC20/TokenVesting.sol";
import { VestingModel } from "./VestingModel.sol";

contract VestingAccount is TokenVesting
{
    VestingModel public vestingModel;

    constructor(address _beneficiary, uint256 _start, uint256 _cliff, uint256 _duration, bool _revocable)
    TokenVesting(_beneficiary, _start, _cliff, _duration, _revocable) public
    {
        require(_beneficiary != address(0));
        vestingModel = VestingModel(_start, _cliff, _duration);
    }

    function vestedAmount(ERC20Basic token) public view returns (uint256) {
        uint256 currentBalance = token.balanceOf(this);
        uint256 totalBalance = currentBalance.add(released[token]);

        if (block.timestamp < (vestingModel.start().add(vestingModel.cliff()))) {
            return 0;
        }
        else if (block.timestamp >= vestingModel.start().add(vestingModel.duration()) || revoked[token]) {
            return totalBalance;
        }
        else {
            return totalBalance.mul(block.timestamp.sub(vestingModel.start())).div(vestingModel.duration());
        }
    }
}
