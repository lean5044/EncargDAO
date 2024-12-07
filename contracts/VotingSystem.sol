// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/AccessControl.sol";

contract VotingSystem is AccessControl {
    bytes32 public constant DirectorateRole = keccak256("DIRECTORATE_ROLE");
    bytes32 public constant AdminRole = keccak256("ADMINISTRATOR_ROLE");
    bytes32 public constant UnitOwnerRole = keccak256("UNIT_OWNER_ROLE");

    struct Proposal {
        string description;
        uint256 endTime;
        uint256 yesVotes;
        uint256 noVotes;
        mapping(address => bool) hasVoted;
        bool exists;
    }

    mapping(uint256 => Proposal) public proposals;
    uint256 public proposalCount;

    event ProposalCreated(
        uint256 proposalId,
        string description,
        uint256 endTime
    );

    event Voted(uint256 proposalId, address voter, bool vote);

    constructor(address directorate, address admin) {
        // _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _setRoleAdmin(AdminRole, DirectorateRole);
        _setRoleAdmin(UnitOwnerRole, DirectorateRole);
        _grantRole(DirectorateRole, directorate);
        _grantRole(AdminRole, admin);
    }

    modifier proposalExists(uint256 proposalId) {
        require(proposals[proposalId].exists, "Proposal does not exist");
        _;
    }

    modifier votingOpen(uint256 proposalId) {
        require(
            block.timestamp < proposals[proposalId].endTime,
            "Voting has ended"
        );
        _;
    }

    function addAdmin(address account) public {
        grantRole(AdminRole, account);
    }

    function removeAdmin(address account) public {
        revokeRole(AdminRole, account);
    }

    function grantUnitOwnerRole(address account) public {
        grantRole(UnitOwnerRole, account);
    }

    function revokeUnitOwnerRole(address account) public {
        revokeRole(UnitOwnerRole, account);
    }

    function createProposal(
        string memory description,
        uint256 duration
    ) external onlyRole(AdminRole) {
        proposalCount++;
        Proposal storage newProposal = proposals[proposalCount];
        newProposal.description = description;
        newProposal.endTime = block.timestamp + duration;
        newProposal.exists = true;

        emit ProposalCreated(proposalCount, description, newProposal.endTime);
    }

    function vote(
        uint256 proposalId,
        bool support
    )
        external
        onlyRole(UnitOwnerRole)
        proposalExists(proposalId)
        votingOpen(proposalId)
    {
        Proposal storage proposal = proposals[proposalId];

        require(!proposal.hasVoted[msg.sender], "Already voted");

        proposal.hasVoted[msg.sender] = true;
        if (support) {
            proposal.yesVotes++;
        } else {
            proposal.noVotes++;
        }

        emit Voted(proposalId, msg.sender, support);
    }

    function getResults(
        uint256 proposalId
    )
        external
        view
        proposalExists(proposalId)
        returns (uint256 yes, uint256 no)
    {
        Proposal storage proposal = proposals[proposalId];
        return (proposal.yesVotes, proposal.noVotes);
    }
}
