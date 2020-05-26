import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_pokedex/consts/consts_app.dart';
import 'package:flutter_pokedex/models/pokeapi.dart';
import 'package:flutter_pokedex/pages/poke_detail_page.dart';
import 'package:flutter_pokedex/stores/pokeapi_store.dart';
import 'package:flutter_pokedex/widgets/app_bar_home.dart';
import 'package:flutter_pokedex/widgets/poke_item.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PokeApiStore pokeApiStore;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double statusHeight = MediaQuery.of(context).padding.top;

    pokeApiStore = Provider.of<PokeApiStore>(context);

    if(pokeApiStore.pokeAPI == null) {
      pokeApiStore.fetchPokemonList();
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        overflow: Overflow.visible,
        alignment: Alignment.topCenter,
        children: <Widget>[
          Positioned(
            top: -240 / 4.7,
            left: screenWidth - (240 / 1.6),
            child: Opacity(
              child: Image.asset(
                ConstsApp.blackPokeball,
                height: 240,
                width: 240,
              ),
              opacity: 0.1,
            ),
          ),
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Container(
                  height: statusHeight,
                ),
                AppBarHome(),
                Expanded(
                  child: Container(
                    child: Observer(
                      name: 'ListaHomePage',
                      builder: (context) {
                        PokeAPI _pokeAPI = pokeApiStore.pokeAPI;
                        return (_pokeAPI != null)
//                            ? ListView.builder(
//                                itemCount: _pokeAPI.pokemon.length,
//                                itemBuilder: (BuildContext context, int index) {
//                                  return ListTile(
//                                    title: Text(_pokeAPI.pokemon[index].name),
//                                  );
//                                },
//                              )
                            ? AnimationLimiter(
                                child: GridView.builder(
                                  physics: BouncingScrollPhysics(),
                                  padding: EdgeInsets.all(12),
                                  addAutomaticKeepAlives: true,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2),
                                  itemCount: _pokeAPI.pokemon.length,
                                  itemBuilder: (context, index) {
                                    return AnimationConfiguration.staggeredGrid(
                                      position: index,
                                      duration:
                                          const Duration(milliseconds: 375),
                                      columnCount: 2,
                                      child: ScaleAnimation(
                                        child: GestureDetector(
                                          child: PokeItem(
                                            index: index,
                                            name: _pokeAPI.pokemon[index].name,
                                            num: _pokeAPI.pokemon[index].num,
                                            types: _pokeAPI.pokemon[index].type,

                                          ),
                                          onTap: (){
                                            _onTapPokemon(_pokeAPI.pokemon[index].name, index);
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              )
                            : Center(
                                child: CircularProgressIndicator(),
                              );
                      },
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  _onTapPokemon(String nome, int index) {
    pokeApiStore.setPokemonAtual(index: index);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => PokeDetailPage(
      name: nome, index: index,
    ), fullscreenDialog: true));
  }
}
