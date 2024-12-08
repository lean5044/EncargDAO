# EncargDAO

Proyecto de Gobernanza para la hackaton de ETHKipu.

## Integrantes

- Mirta Longhitano
- Leandro
- Gabriel Rodriguez

## Objetivo

Crear una DAO (Organización Autónoma Descentralizada) para un edificio donde cada integrante de un departamento tenga un token NFT que les permita votar y hacer propuestas de mejoras.

- Cada departamento tiene un NFT único que representa el derecho a votar.
- Una persona por NFT tiene derecho a realizar propuestas y votar.
- Las propuestas se aprueban si alcanzan un cierto porcentaje de votos positivos (en este caso, el 50%+1).

Queda a futuro decidir cómo se manejarán las votaciones (tiempo para votar, quorum, etc.).
También definir qué pasará si alguien pierde su NFT.

### EliseoNFT

Para resolver el objetivo nuestro contrato NFT lo pensamos de forma tal que sea compatible con el estándar ERC-721.
Este contrato también se usará para emitir tokens únicos a cada departamento.

Por ejemplo, el primer piso departamento 1 tendrá el token "101". El primer piso departamento 2 tendrá el token "102".

El edificio tiene 3 pisos por lo que se emitirán los tokens 101, 102, 201, 202, 301 y 302.

### EncargDAO

El contrato de la DAO manejará:

- La creación de propuestas.
- La votación basada en la posesión de los NFTs.
- La ejecución de decisiones.

## Explicación del código

1. `createProposal`:

- Solo los usuarios que poseen al menos un NFT (onlyNFT) pueden crear propuestas.
- La propuesta se agrega al array proposals.

2. `vote:`

- Verifica que el usuario sea poseedor de un NFT.
- Se asegura de que el usuario no haya votado previamente (hasVoted[proposalId][msg.sender]).
- Incrementa el conteo de votos de la propuesta y marca al usuario como "votó" para esa propuesta.

3. `executeProposal:`

- Asegura que la propuesta no haya sido ejecutada antes.
- Comprueba si la propuesta tiene suficientes votos (más del 50% de los NFTs emitidos).
- Marca la propuesta como ejecutada.

4. `getProposalCount:`

- Devuelve el número total de propuestas creadas.

## Front

Se crea una interfaz de usuario que permita a los usuarios:

- Conectarse con su wallet.
- Ver las propuestas actuales.
- Crear propuestas nuevas.
- Votar en propuestas.
