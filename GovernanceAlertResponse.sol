// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract GovernanceAlertResponse {
    
    event GovernanceSpikeAlert(
        address indexed wallet,
        uint256 previousVotes,
        uint256 currentVotes,
        uint256 percentIncrease,
        uint256 timestamp
    );

    struct Alert {
        address wallet;
        uint256 previousVotes;
        uint256 currentVotes;
        uint256 percentIncrease;
        uint256 timestamp;
    }

    mapping(address => uint256) public alertCount;
    mapping(address => Alert[]) public alertHistory;
    
    address public trapContract;
    bool public paused;
    
    modifier onlyTrap() {
        require(msg.sender == trapContract, "Only trap can call");
        _;
    }
    
    constructor() {
        paused = false;
    }
    
    function setTrapContract(address _trap) external {
        require(trapContract == address(0), "Trap already set");
        trapContract = _trap;
    }
    
    function logAlert(
        address wallet,
        uint256 previousVotes,
        uint256 currentVotes,
        uint256 percentIncrease
    ) external onlyTrap {
        require(!paused, "Response contract is paused");
        
        alertCount[wallet]++;
        
        alertHistory[wallet].push(Alert({
            wallet: wallet,
            previousVotes: previousVotes,
            currentVotes: currentVotes,
            percentIncrease: percentIncrease,
            timestamp: block.timestamp
        }));
        
        emit GovernanceSpikeAlert(
            wallet,
            previousVotes,
            currentVotes,
            percentIncrease,
            block.timestamp
        );
    }
    
    function getAlertCount(address wallet) external view returns (uint256) {
        return alertCount[wallet];
    }
    
    function getAlertHistory(address wallet) external view returns (Alert[] memory) {
        return alertHistory[wallet];
    }
    
    function getLatestAlert(address wallet) external view returns (Alert memory) {
        require(alertHistory[wallet].length > 0, "No alerts for this wallet");
        return alertHistory[wallet][alertHistory[wallet].length - 1];
    }
    
    function pause() external {
        paused = true;
    }
    
    function unpause() external {
        paused = false;
    }
}