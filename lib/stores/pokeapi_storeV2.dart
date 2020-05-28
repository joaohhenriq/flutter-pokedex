import 'dart:convert';

import 'package:flutter_pokedex/consts/consts_api.dart';
import 'package:flutter_pokedex/models/pokeapiv2.dart';
import 'package:flutter_pokedex/models/specie.dart';
import 'package:mobx/mobx.dart';
import 'package:http/http.dart' as http;

part 'pokeapi_storeV2.g.dart';

class PokeApiV2Store = _PokeApiV2StoreBase with _$PokeApiV2Store;

abstract class _PokeApiV2StoreBase with Store{

  @observable
  Specie _specie;

  @observable
  PokeApiV2 _pokeApiV2;

  @computed
  Specie get specie => _specie;

  @computed
  PokeApiV2 get pokeApiV2 => _pokeApiV2;

  @action
  Future<void> getInfoPokemon(String nome) async {
    try{
      final response = await http.get(ConstsAPI.baseURL);
      var decodeJson = jsonDecode(response.body);
      _pokeApiV2 = PokeApiV2.fromJson(decodeJson);

    } catch (error){
      print("Erro ao carregar lista");
      return null;
    }
  }

  @action
  Future<void> getInfoSpecie(String nome) async {
    try{
      final response = await http.get(ConstsAPI.baseURL);
      var decodeJson = jsonDecode(response.body);
      _specie = Specie.fromJson(decodeJson);

    } catch (error){
      print("Erro ao carregar lista");
      return null;
    }
  }
}