//
//  JSONData.swift
//  Pokemon
//
//  Created by Nitin George on 10/03/2025.
//

struct JSONData {
    static let pokemonValidJSON = """
{
    "count": 1302,
    "next": "https://pokeapi.co/api/v2/pokemon?offset=3&limit=3",
    "previous": null,
    "results": [
        {
            "name": "bulbasaur",
            "url": "https://pokeapi.co/api/v2/pokemon/1/"
        },
        {
            "name": "ivysaur",
            "url": "https://pokeapi.co/api/v2/pokemon/2/"
        },
        {
            "name": "venusaur",
            "url": "https://pokeapi.co/api/v2/pokemon/3/"
        }
    ]
}
"""
    
    static let pokemonEmptyJSON = """
{
    "count": 1302,
    "next": "https://pokeapi.co/api/v2/pokemon?offset=3&limit=3",
    "previous": null,
    "results": [
    ]
}
"""
    
    static let pokemonInvalidJSON = """
{
    "count": 1302,
    "next": "https://pokeapi.co/api/v2/pokemon?offset=3&limit=3",
    "previous": null,
    "result": [
        {
            "name": "bulbasaur",
            "url": "https://pokeapi.co/api/v2/pokemon/1/"
        }
    ]
}
"""
}
