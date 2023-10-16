// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract PokemonGame {
    struct Pokemon {
        string name;
        uint8 attack;
        uint8 defense;
    }

    struct Player {
        address payable addr;
        mapping(uint256 => Pokemon) pokemons;
        uint256 pokemonCount;
    }

    mapping(address => Player) public players;

    function createPokemon (string memory name, uint8 attack, uint8 defense) external {
        Player storage player = players[msg.sender];
        player.pokemonCount++;
        player.pokemons[player.pokemonCount] = Pokemon(name, attack, defense);
    }

    function enhancePokemon(uint256 pokemonId, uint8 newAttack, uint8 newDefense) external payable {
        Player storage player = players[msg.sender];

        require(msg.value == 0.1 ether, "Need 0.1 ETH");
        require(pokemonId<= player.pokemonCount, "Invalid Pokemon ID");

        Pokemon storage pokemon = player.pokemons[pokemonId];
        pokemon.attack = newAttack;
        pokemon.defense = newDefense;
    }

    function getPlayerPokemonByPokemonId(address player, uint256 pokemonId) public view returns (Pokemon memory) {
        Player storage playerInfo = players[player];
        require(pokemonId <= playerInfo.pokemonCount, "Invalid Pokemon ID");

        return playerInfo.pokemons[pokemonId];
    }


    function getPlayerPokemons(address player) public view returns (Pokemon[] memory) {
        Player storage playerInfo = players[player];
        uint256 pokemonCount = playerInfo.pokemonCount;

        Pokemon[] memory result = new Pokemon[](pokemonCount);

        for (uint256 i = 1; i <= pokemonCount; i++) {
            result[i - 1] = playerInfo.pokemons[i];
        }

        return result;
    }
} 
