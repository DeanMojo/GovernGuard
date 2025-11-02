<p align="center">
<img src="https://github.com/DeanMojo/GovernGuard/blob/main/GOVERNGUARD%20logo%20(All%20Black).png" alt="GovernGuard Logo" width="400"/>
</p>

🛡️ GovernGuard Trap


A Drosera-powered trap that monitors on-chain governance voting behavior and detects abnormal voting power spikes.




⚙️ Overview

GovernGuard is a Drosera Trap designed to protect decentralized governance systems from manipulation.
It continuously monitors a target wallet’s voting power in a governance token contract and automatically triggers alerts when suspicious voting spikes occur.

It makes decentralized governance safer, auditable, and more autonomous all without relying on a centralized watchdog.




🧠 Core Use Case

🔒 1.Governance Attack Detection

Problem: DAO governance systems can be exploited through flashloan attacks or last-minute vote concentration, where malicious actors borrow large voting power to hijack decisions.

GovernGuard Solution: It continuously watches for abnormal spikes in voting activity or token transfers to the governance contract. When detected, it triggers an on-chain response, such as:

Emitting an alert for DAO operators.

Triggering a cooldown on proposal execution.

Notifying off-chain monitoring systems via Drosera Network.

🧩 2.Automated Response Triggers

GovernGuard can execute custom logic upon detecting patterns, for instance:

Lock tokens during suspicious voting surges.

Pause governance proposals temporarily.

Notify Drosera agents (via GovernGuardResponse.sol) to audit affected proposals.




🧠 How It Works

Step
Description
🧩 Collect
The trap calls the getVotes(address) function from a governance contract and encodes the wallet’s voting power.
🔍 Compare
It compares the latest voting data with the previous snapshot.
🚨 Detect Spike
If the voting power increases by more than a defined threshold (default 50%), the trap returns true in shouldRespond().
⚡ Respond
Once triggered, Drosera can route this event to a Response Contract or alert node operators for investigation.





🧪 Testing on Hoodi Testnet

1. Deploy the Governance Token

You can start by deploying a mock governance token that supports:

Plain Text


function getVotes(address account) external view returns (uint256);


2. Deploy the Trap

Use Remix IDE and set the environment to Hoodi Testnet
(RPC: https://rpc.hoodi.ethpandaops.io)

Deploy the GovernGuardTrap.sol contract and configure:

Plain Text


address public constant GOVERNANCE_CONTRACT = <your governance token address>;
address public constant MONITORED_WALLET = <target wallet>;
uint256 public constant SPIKE_THRESHOLD_PERCENT = 50;


Once deployed, note the trap address — it’s used by your Drosera node.

3. Register the Trap

Run the following on your operator host:

Bash


drosera-operator register   --eth-rpc-url https://rpc.hoodi.ethpandaops.io   --eth-private-key <PRIVATE_KEY>


This tells the Drosera network your node will monitor this trap.




🧰 Example Configuration (drosera.toml)

Plain Text


[traps.governguard]
address = "0xYourTrapAddress"
network = "hoodi"
source = "./contracts/GovernGuardTrap.sol"





🧪 Local Testing with Mock Tokens

You can simulate spikes by minting new votes or delegating to the monitored wallet:

Plain Text


governanceToken.delegate(MONITORED_WALLET);
governanceToken.mint(MONITORED_WALLET, 1000 ether);


After that, re-run collect() and shouldRespond() to test the spike detection logic.




🧭 Tech Stack

•
🧱 Solidity v0.8.20

•
🌿 Drosera Network

•
🔗 Hoodi Testnet

•
⚙️ Remix IDE

•
🐳 Docker + drosera-operator




🧤 Response Contract (Optional)

You can extend GovernGuard with a Response Contract to automate mitigation —
e.g., pausing governance, alerting Discord, or blacklisting a wallet.




📜 License

MIT




🌐 Connect with Drosera Network

•
🔗 Website

•
🧭 Docs

•
💬 Discord

•
🐦 Twitter / X

