// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ITrap} from "drosera-contracts/interfaces/ITrap.sol";

interface IGovernance {
    function getVotes(address account) external view returns (uint256);
}

contract GovernGuardTrap is ITrap {
    address public constant GOVERNANCE_CONTRACT = 0x5B36BB7687cfcB509B007EC368c6F9F0095f71Ab;
    address public constant MONITORED_WALLET = 0xC5387cEe687109b10494CB9F7b2A3A9D982E7EbE;
    uint256 public constant SPIKE_THRESHOLD_PERCENT = 50;

    event VotingPowerSpike(address indexed wallet, uint256 previousVotes, uint256 currentVotes, uint256 percentIncrease);

    struct CollectData {
        uint256 votingPower;
        address wallet;
    }

    function collect() external view returns (bytes memory) {
        uint256 votes = IGovernance(GOVERNANCE_CONTRACT).getVotes(MONITORED_WALLET);
        return abi.encode(CollectData({
            votingPower: votes,
            wallet: MONITORED_WALLET
        }));
    }

    function shouldRespond(bytes[] calldata data) external pure returns (bool, bytes memory) {
        if (data.length < 2) {
            return (false, bytes(""));
        }

        CollectData memory current = abi.decode(data[0], (CollectData));
        CollectData memory previous = abi.decode(data[1], (CollectData));

        if (previous.votingPower == 0) {
            return (false, bytes(""));
        }

        if (current.votingPower <= previous.votingPower) {
            return (false, bytes(""));
        }

        uint256 increase = current.votingPower - previous.votingPower;
        uint256 percentIncrease = (increase * 100) / previous.votingPower;

        if (percentIncrease >= SPIKE_THRESHOLD_PERCENT) {
            return (true, abi.encode(current.wallet, previous.votingPower, current.votingPower, percentIncrease));
        }

        return (false, bytes(""));
    }
}
