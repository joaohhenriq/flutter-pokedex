import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_pokedex/consts/consts_api.dart';
import 'package:flutter_pokedex/consts/consts_app.dart';
import 'package:flutter_pokedex/models/pokeapi.dart';
import 'package:flutter_pokedex/stores/pokeapi_store.dart';
import 'package:provider/provider.dart';
import 'package:sliding_sheet/sliding_sheet.dart';

class PokeDetailPage extends StatelessWidget {
  final int index;
  final String name;

  Color _corPokemon;

  PokeDetailPage({Key key, this.index, this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _pokemonStore = Provider.of<PokeApiStore>(context);
    Pokemon _pokemon = _pokemonStore.pokemonAtual;
    _corPokemon = ConstsApp.getColorType(type: _pokemon.type[0]);

    _onChangePageView(int index){
      _pokemonStore.setPokemonAtual(index: index);
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: Observer(
          builder: (context) {
            _corPokemon = ConstsApp.getColorType(type: _pokemonStore.pokemonAtual.type[0]);
            return AppBar(
              title: Opacity(
                opacity: 0,
                child: Text(
                  _pokemon.name,
                  style: TextStyle(
                      fontFamily: 'Google',
                      fontWeight: FontWeight.bold,
                      fontSize: 21),
                ),
              ),
              elevation: 0,
              backgroundColor: _corPokemon,
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {Navigator.pop(context);},
              ),
              actions: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.favorite_border,
                  ),
                  onPressed: () {},
                )
              ],
            );
          },
        ),
      ),
      body: Stack(
        children: <Widget>[
          Observer(
            builder: (context) {
              _corPokemon = ConstsApp.getColorType(type: _pokemonStore.pokemonAtual.type[0]);
              return Container(color: _corPokemon);
            },
          ),
          Container(
            height: MediaQuery.of(context).size.height / 3,
          ),
          SlidingSheet(
            elevation: 5,
            cornerRadius: 20,
            snapSpec: SnapSpec(
              snap: true,
//              snappings: [0.2, 1, 1],
                snappings: [.7, 1],
              positioning: SnapPositioning.relativeToAvailableSpace
            ),
            builder: (context, state){
              return Container(
                height: MediaQuery.of(context).size.height,
                child: Center(
                  child: Text("Corpo do bagulho"),
                ),
              );
            },
          ),
          Padding(
            padding: EdgeInsets.only(top: 50),
            child: SizedBox(
              height: 150,
              child: PageView.builder(
                onPageChanged: _onChangePageView,
                itemCount: _pokemonStore.pokeAPI.pokemon.length,
                itemBuilder: (context, count){
                  Pokemon _pokem = _pokemonStore.getPokemon(index: count);
                  return CachedNetworkImage(
                    placeholder: (context, url) => Container(
                      color: Colors.transparent,
                    ),
                    imageUrl: ConstsAPI.imageURL(_pokem.num),
                  );
                },
              )
            ),
          )
        ],
      ),
    );
  }
}
