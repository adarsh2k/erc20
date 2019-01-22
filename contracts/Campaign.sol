pragma solidity ^0.5.0;

import 'openzeppelin-solidity/contracts/token/ERC20/ERC20Pausable.sol';
import 'openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol';
import 'openzeppelin-solidity/contracts/token/ERC20/ERC20.sol';
import "openzeppelin-solidity/contracts/ownership/Ownable.sol";

contract Campaign is ERC20Detailed, ERC20Pausable, Ownable, ERC20 {

    constructor(uint minimum, address sender, string name, string symbol)
    ERC20Detailed(name, symbol, 0) public {
        owner = sender;
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
    address public owner;
    uint public minimumContribution;
    mapping(address => bool) public contributors;
    uint public totalContributions;

    event ContributionSuccessful(address indexed from_, address indexed to_, uint256 amount_);

    event ContributionFailed(address indexed from_, address indexed to_, uint256 amount_);

    function contribute(bytes32 symbol_, address address_) public onlyOwner returns (bool) {
        tokens[symbol_] = address_;
        contributors[msg.sender] = true;
        totalContributions++;
        return true;
    }

    function removeToken(bytes32 symbol_) public onlyOwner returns (bool) {
        require(tokens[symbol_] != 0x0);
        delete (tokens[symbol_]);
        return true;
    }

    modifier ifContributorExists() {
        require(contributors[msg.sender]);
        _;
    }

    function approveRequest(uint index) public ifContributorExists {
        Request storage request = requests[index];
        require(!request.voters[msg.sender]);
        request.voters[msg.sender] = true;
        request.voteCount++;
    }

    function() public payable {}

    function transferTokens(bytes32 symbol_, address to_, uint256 amount_) public whenNotPaused {
        Request storage request = requests[index];
        require(!request.complete);
        require(request.voteCount > (totalContributions / 2));
        require(tokens[symbol_] != 0x0);
        require(amount_ >= request.value);

        address contract_ = tokens[symbol_];
        address from_ = msg.sender;

        ERC20Interface = ERC20(contract_);

        uint256 transactionId = transactions.push(
            Transfer({
            contract_ : contract_,
            to_ : to_,
            amount_ : amount_,
            failed_ : true
            })
        );
        transactionIndexesToSender[from_].push(transactionId - 1);

        if (amount_ > ERC20Interface.allowance(from_, address(this))) {
            emit TransferFailed(from_, to_, amount_);
            revert();
        }
        ERC20Interface.transferFrom(from_, to_, amount_);

        transactions[transactionId - 1].failed_ = false;

        emit TransferSuccessful(from_, to_, amount_);

        request.complete = true;
    }

    function createRequest(
        string description,
        uint value,
        address recipient
    ) public onlyOwner {

        Request memory newRequest = Request({
            description : description,
            value : value,
            recipient : recipient,
            complete : false,
            voteCount : 0
            });
        requests.push(newRequest);
    }

    function pauseContract() public onlyOwner {
        if (!paused()) {
            pause();
        }
    }

}
