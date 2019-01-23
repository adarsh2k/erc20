pragma solidity ^0.4.24;

import 'openzeppelin-solidity/contracts/token/ERC20/PausableToken.sol';
import 'openzeppelin-solidity/contracts/token/ERC20/DetailedERC20.sol';
import 'openzeppelin-solidity/contracts/token/ERC20/ERC20.sol';
import "openzeppelin-solidity/contracts/ownership/Ownable.sol";
import "openzeppelin-solidity/contracts/math/SafeMath.sol";

contract Campaign is DetailedERC20, PausableToken, Ownable {

    using SafeMath for uint;
    constructor(uint minimum, address sender, string memory name, string memory symbol)
    DetailedERC20(name, symbol, 0) public {
        _owner = sender;
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

    struct TransferStat {
        address _contract;
        address _to;
        uint _amount;
        bool _failed;
    }

    mapping(bytes32 => address) private tokens;
    Request[] public requests;
    address public _owner;
    uint public minimumContribution;
    mapping(address => bool) public contributors;
    uint public totalContributions;
    TransferStat[] public transactions;

    event ContributionSuccessful(address indexed _from, address indexed _to, uint256 _amount);

    event ContributionFailed(address indexed _from, address indexed _to, uint256 _amount);

    function contribute(bytes32 _symbol, address _address) public onlyOwner returns (bool) {
        tokens[_symbol] = _address;
        contributors[msg.sender] = true;
        totalContributions++;
        return true;
    }

    function removeToken(bytes32 _symbol) public onlyOwner returns (bool) {
        delete (tokens[_symbol]);
        return true;
    }

    modifier ifContributorExists() {
        require(contributors[msg.sender]);
        _;
    }

    function approveRequest(uint index) public ifContributorExists {
        Request storage request = requests[index];
        require(!request._voters[msg.sender]);
        request._voters[msg.sender] = true;
        request._voteCount++;
    }

    function() external payable {}

    function transferTokens(bytes32 _symbol, address _to, uint256 _amount, uint index) public whenNotPaused {
        Request storage request = requests[index];
        require(!request._complete);
        require(request._voteCount > totalContributions.div(2));
        require(_amount >= request._value);

        address _contract = tokens[_symbol];
        address _from = msg.sender;

        ERC20Interface = ERC20(_contract);

        uint256 transactionId = transactions.push(
            TransferStat({
            _contract : _contract,
            _to : _to,
            _amount : _amount,
            _failed : true
            })
        );

        if (_amount > ERC20Interface.allowance(_from, address(this))) {
            emit ContributionSuccessful(_from, _to, _amount);
            revert();
        }
        ERC20Interface.transferFrom(_from, _to, _amount);

        transactions[transactionId - 1]._failed = false;

        emit ContributionSuccessful(_from, _to, _amount);

        request._complete = true;
    }

    function createRequest(
        string memory description,
        uint value,
        address recipient
    ) public onlyOwner {

        Request memory newRequest = Request({
            _description : description,
            _value : value,
            _recipient : recipient,
            _complete : false,
            _voteCount : 0
            });
        requests.push(newRequest);
    }

    function pause() public onlyOwner {
        if (!paused()) {
            pause();
        }
    }

}
