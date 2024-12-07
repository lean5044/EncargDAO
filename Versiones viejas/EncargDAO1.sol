// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

contract EncargDAO {
    IERC721 public buildingNFT; // Contrato NFT vinculado
    address public admin; // Dirección del administrador

    struct Proposal {
        string description; // Descripción de la propuesta
        uint256 voteCount;  // Conteo de votos
        bool executed;      // Si la propuesta ya fue ejecutada
    }

    Proposal[] public proposals; // Array dinámico de propuestas
    mapping(uint256 => mapping(address => bool)) public hasVoted; // Mapping para rastrear votos

    constructor(address _buildingNFT) {
        buildingNFT = IERC721(_buildingNFT); // Vincula el contrato NFT
        admin = msg.sender; // Asigna el administrador
    }

    modifier onlyNFT() {
        require(buildingNFT.balanceOf(msg.sender) > 0, "Not an NFT holder");
        _;
    }

    // Crear una nueva propuesta
    function createProposal(string memory description) external onlyNFT {
        proposals.push(Proposal({
            description: description,
            voteCount: 0,
            executed: false
        }));
    }

    // Votar por una propuesta
    function vote(uint256 proposalId) external onlyNFT {
        require(proposalId < proposals.length, "Proposal does not exist");
        require(!hasVoted[proposalId][msg.sender], "Already voted");

        Proposal storage proposal = proposals[proposalId];
        proposal.voteCount++;
        hasVoted[proposalId][msg.sender] = true; // Marca que el usuario ya votó
    }

    // Ejecutar una propuesta si los votos son suficientes
    function executeProposal(uint256 proposalId) external {
        require(proposalId < proposals.length, "Proposal does not exist");

        Proposal storage proposal = proposals[proposalId];
        require(!proposal.executed, "Proposal already executed");
        require(proposal.voteCount > buildingNFT.totalSupply() / 2, "Not enough votes"); // Regla: más del 50% de los tokens deben votar a favor

        proposal.executed = true;
        // Aquí podrías agregar lógica adicional para ejecutar decisiones
    }

    // Obtener el número total de propuestas
    function getProposalCount() external view returns (uint256) {
        return proposals.length;
    }
}


