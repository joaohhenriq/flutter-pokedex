import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pokedex/consts/consts_api.dart';
import 'package:flutter_pokedex/consts/consts_app.dart';
import 'package:flutter_pokedex/models/pokeapi.dart';
import 'package:mobx/mobx.dart';
import 'package:http/http.dart' as http;

part 'pokeapi_store.g.dart';

class PokeApiStore = _PokeApiStoreBase with _$PokeApiStore;

abstract class _PokeApiStoreBase with Store {

  @observable
  PokeAPI _pokeAPI;

  @observable
  Pokemon _pokemonAtual;

  @observable
  Color _corPokemon;

  @observable
  int _posicaoAtual;

  //----------------------

  @computed
  PokeAPI get pokeAPI => _pokeAPI;

  @computed
  Pokemon get pokemonAtual => _pokemonAtual;

  @computed
  Color get corPokemon => _corPokemon;

  @computed
  int get posicaoAtual => _posicaoAtual;

  //-------------------------

  @action
  fetchPokemonList(){
    _pokeAPI = null;
    loadPokeAPI().then((pokeList){
      _pokeAPI = pokeList;
    });
  }

  Pokemon getPokemon({int index}){
    return _pokeAPI.pokemon[index];
  }

  @action
  Widget getImage({String numero}){
    return CachedNetworkImage(
      placeholder: (context, url) => Container(color: Colors.transparent,),
      imageUrl: ConstsAPI.imageURL(numero),
    );
  }

  @action
  setPokemonAtual({int index}){
    _pokemonAtual = _pokeAPI.pokemon[index];
    _corPokemon = ConstsApp.getColorType(type: _pokemonAtual.type[0]);
    _posicaoAtual = index;
  }

  Future<PokeAPI> loadPokeAPI() async {
    try{
      final response = await http.get(ConstsAPI.baseURL);
      var decodeJson = jsonDecode(response.body);
      return PokeAPI.fromJson(decodeJson);

    } catch (error){
      print("Erro ao carregar lista");
      return null;
    }
  }


}