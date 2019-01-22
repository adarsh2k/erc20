pragma solidity ^0.5.0;

import 'openzeppelin-solidity/contracts/token/ERC20/ERC20Pausable.sol';
import 'openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol';
import 'openzeppelin-solidity/contracts/token/ERC20/ERC20.sol';

contract Campaign is ERC20Detailed, ERC20Pausable, ERC20 {

    constructor(uint minimum, address sender, string name, string symbol)
    ERC20Detailed(name, symbol, 0) public {
        manager = sender;
        minimumContribution = minimum;
    }

    ERC20 public ERC20Interface;

    struct Request {
        string _description;
        uint _value;
        address _recipient;
        bool _complete;
        uint _voteCount;
        mapping(address => bool) _voters;
    }

    Request[] public requests;
    address public manager;
    uint public minimumContribution;
    mapping(address => bool) public contributors;
    uint public totalContributions;

    event ContributionSuccessful(address indexed from_, address indexed to_, uint256 amount_);

    event ContributionFailed(address indexed from_, address indexed to_, uint256 amount_);

}
