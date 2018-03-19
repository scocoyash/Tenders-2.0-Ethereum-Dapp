pragma solidity ^0.4.20;
pragma experimental ABIEncoderV2;

import "./Main.sol";
import "./Tender.sol";
import "./Contract.sol";


contract GovernmentOfficer is Main {
    
    address public walletAddress;
    string public email;
    string public phoneNumber;
    string public name;
    string public employeeId; 
    bool isVerified;

    address[] public tenders;
    address[] public pastTenders;

    address[] public contracts;
    address[] public pastContracts;

    mapping (address=>bool) public contractStatus; //true => past, false => active
    mapping (address=>address) public tenderToContract;

    function GovernmentOfficer(address _walletAddress, string _email, string _name, 
    string _phoneNumber, string _employeeId) {
        walletAddress = _walletAddress;
        email = _email;
        phoneNumber = _phoneNumber;
        name = _name;
        employeeId = _employeeId;
        isVerified = false;
    }

    function createTender(address _governmentOfficerAddress, string _tenderName, string[] _clauses, 
    string[] _constraints, uint _deadline) public returns (address) {
        Tender newTender = new Tender(address(this), _tenderName, _clauses, 
        _constraints, _deadline);
        tenders.push(newTender);
        return newTender;
    }

    function createContract(address tenderAddress,
        address _contractorAddress, 
        //address _specialOfficerAddress, 
        string _contractName, 
        string _contractDocumentUrl, 
        string[] _taskDescription, 
        uint[] _deadlineForEachTask, 
        uint[] _amountForEachTask, 
        uint _reviewtime) public returns (address) {
        //first call this function and then updateTenderToContract() function for contract deployment
        Contract newContract = new Contract(address(this), _contractorAddress, _contractName, 
        _contractDocumentUrl, _taskDescription, _deadlineForEachTask, 
        _amountForEachTask, _reviewtime);
        contracts.push(newContract);
        updateTenderToContract(tenderAddress, newContract);
        return newContract;
    }

    function login(address userAddress, string role) public  returns (string) {
    }

    function getAllContracts(string token) public  returns (address[]) {
        //refer contracts.sol
    }

    function getOngoingContracts(string token) public returns (address[]) {
        //look at contracts.sol
    }

    function getMyContracts(string token) public returns (address[]) {
        return contracts;
    }

    function getPastContracts(string token) public view returns (address[]) {
        return pastContracts;
    }

    function markContractCompleted (string token, address contractAddress) public returns (bool) {
        //remove from contracts and add to pastContracts
        for (uint256 i=0; i < contracts.length; i++) {
            if (contracts[i] == contractAddress) {
                pastContracts.push(contractAddress);
                contractStatus[contractAddress] = true;
                delete contracts[i];
                return true;
            }
        }
        return false;
    }

    function addToMyContracts(string token, address contractAddress) public returns (address) {
        //call when createContract button is clicked => web3
        contracts.push(contractAddress);
    }

    function addToMyTenders(string token, address tenderAddress) public returns (address) {
        //look at web3 for address 
        tenders.push(tenderAddress);
    }

    function getMyTenders(string token) public returns (address[]) {
        return tenders;
    }

    function getPastTenders(string token) public returns (address[]){
        return pastTenders;
    }

    function updateTenderToContract(address tenderAddress, address contractAddress) 
    public returns (bool) {
        //removeFromMyTender and add to past Tenders
        for (uint i=0; i < tenders.length; i++) {
            if (tenders[i] == tenderAddress) {
                pastTenders.push(tenderAddress);
                tenderToContract[tenders[i]] = contractAddress;
                contracts.push(contractAddress);
                contractStatus[contractAddress] = false;
                delete tenders[i];
                return true;
            }
        }
        return false;
    }

    function updateOfficerVerifiedStatus() public {
        isVerified = true;
    }

    function getQuotations(string token) public returns (address[]) {
        //look at Tender.sol
    }

    function logout() public returns (bool) {
    }


}