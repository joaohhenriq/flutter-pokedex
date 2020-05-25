import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pokedex/consts/consts_api.dart';
import 'package:flutter_pokedex/models/pokeapi.dart';
import 'package:mobx/mobx.dart';
import 'package:http/http.dart' as http;

part 'pokeapi_store.g.dart';

class PokeApiStore = _PokeApiStoreBase with _$PokeApiStore;

abstract class _PokeApiStoreBase with Store {

  @observable
  PokeAPI _pokeAPI;

  @computed
  PokeAPI get pokeAPI => _pokeAPI;

  @action
  fetchPokemonList(){
    _pokeAPI = null;
    loadPokeAPI().then((pokeList){
      _pokeAPI = pokeList;
    });
  }

  @action
  Widget getImage({String numero}){
    return CachedNetworkImage(
      placeholder: (context, url) => Container(color: Colors.transparent,),
      imageUrl: ConstsAPI.imageURL(numero),
    );
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