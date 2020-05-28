class ConstsAPI {

  static String baseURL = "https://raw.githubusercontent.com/Biuni/PokemonGO-Pokedex/master/pokedex.json";
  static String imageURL(String numero){
    return "https://raw.githubusercontent.com/fanzeyi/pokemon.json/master/images/$numero.png";
  }

  static String pokeapiV2Url = "https://pokeapi.co/api/v2/pokemon/";
  static String pokeapiV2EspeciesUrl = "https://pokeapi.co/api/v2/pokemon-species/";
}