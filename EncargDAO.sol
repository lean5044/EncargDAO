// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

contract EncargDAO {
    IERC721 public buildingNFT; // Contrato NFT vinculado
    address public admin;       // Dirección del administrador

    struct Proposal {
        string description; // Descripción de la propuesta
        uint256 voteCount;  // Conteo de votos
        bool executed;      // Si la propuesta ya fue ejecutada
    }

    Proposal[] public proposals; // Array dinámico de propuestas
    mapping(uint256 => mapping(address => bool)) public hasVoted; // Mapping para rastrear votos

    // Dirección del contrato NFT y administrador
    constructor(address _buildingNFT) {
        buildingNFT = IERC721(_buildingNFT); // Vincula el contrato NFT
        admin = msg.sender; // Asigna el administrador
    }

    modifier onlyNFT() {
        require(buildingNFT.balanceOf(msg.sender) > 0, "Esta billetera no tiene ELI");
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
        require(proposalId < proposals.length, "La propuesta no existe");
        require(!hasVoted[proposalId][msg.sender], "Ya votaste");

        Proposal storage proposal = proposals[proposalId];
        proposal.voteCount++;
        hasVoted[proposalId][msg.sender] = true; // Marca que el usuario ya votó
    }

    // Ejecutar una propuesta si los votos son suficientes
    function executeProposal(uint256 proposalId, uint256 totalSupply) external {
        require(proposalId < proposals.length, "La propuesta no existe");

        Proposal storage proposal = proposals[proposalId];
        require(!proposal.executed, "Esta propuesta ya se ejecuto");
        require(proposal.voteCount > totalSupply / 2, "No hay suficientes votos"); // Más del 50% de los tokens deben votar a favor

        proposal.executed = true;
        // Acá tenemos que agregar la ejecución de las propuestas, por ejemplo:
        // Transferir fondos a quien haya realizado el servicio
        // Elegir a un nuevo presidente de consorcio
    }

    // Obtener el número total de propuestas
    function getProposalCount() external view returns (uint256) {
        return proposals.length;
    }
}
