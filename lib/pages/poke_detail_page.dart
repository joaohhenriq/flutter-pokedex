import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_pokedex/consts/consts_api.dart';
import 'package:flutter_pokedex/consts/consts_app.dart';
import 'package:flutter_pokedex/models/pokeapi.dart';
import 'package:flutter_pokedex/stores/pokeapi_store.dart';
import 'package:get_it/get_it.dart';
import 'package:simple_animations/simple_animations/controlled_animation.dart';
import 'package:simple_animations/simple_animations/multi_track_tween.dart';
import 'package:sliding_sheet/sliding_sheet.dart';

class PokeDetailPage extends StatefulWidget {
  final int index;
  final String name;

  PokeDetailPage({Key key, this.index, this.name}) : super(key: key);

  @override
  _PokeDetailPageState createState() => _PokeDetailPageState();
}

class _PokeDetailPageState extends State<PokeDetailPage> {
  PageController _pageController;
  Pokemon _pokemon;
  PokeApiStore _pokemonStore;

  MultiTrackTween _animation;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.index);

    _pokemonStore = GetIt.instance<PokeApiStore>();
    _pokemon = _pokemonStore.pokemonAtual;

    _animation = MultiTrackTween([
      Track("rotation").add(Duration(seconds: 8), Tween(begin: 0, end: 6),
          curve: Curves.linear),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    _onChangePageView(int index) {
      _pokemonStore.setPokemonAtual(index: index);
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: Observer(
          builder: (context) {
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
              backgroundColor: _pokemonStore.corPokemon,
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
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
              return Container(
                color: _pokemonStore.corPokemon,
              );
            },
          ),
          Container(
            height: MediaQuery.of(context).size.height / 3,
          ),
          SlidingSheet(
            elevation: 5,
            cornerRadius: 30,
            snapSpec: SnapSpec(
                snap: true,
//              snappings: [0.2, 1, 1],
                snappings: [.7, 1],
                positioning: SnapPositioning.relativeToAvailableSpace),
            builder: (context, state) {
              return Container(
                height: MediaQuery.of(context).size.height,
                child: Center(
                  child: Text("Corpo do bagulho"),
                ),
              );
            },
          ),
          Padding(
            padding: EdgeInsets.only(top: 40),
            child: SizedBox(
                height: 200,
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: _onChangePageView,
                  itemCount: _pokemonStore.pokeAPI.pokemon.length,
                  itemBuilder: (context, count) {
                    Pokemon _pokem = _pokemonStore.getPokemon(index: count);
                    return Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        ControlledAnimation(
                          playback: Playback.LOOP,
                          duration: _animation.duration,
                          tween: _animation,
                          builder: (context, animation) {
                            return Transform.rotate(
                              angle: animation['rotation'] * 1.0,
                              child: Hero(
                                tag: _pokem.name + 'rotation',
                                child: Opacity(
                                  opacity: 0.2,
                                  child: Image.asset(
                                    ConstsApp.whitePokeball,
                                    height: 280,
                                    width: 280,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        Observer(
                          builder: (context) {
                            return AnimatedPadding(
                              padding: EdgeInsets.all(count == _pokemonStore.posicaoAtual ? 0.0 : 60.0),
                              duration: Duration(milliseconds: 700),
                              curve: Curves.decelerate,
                              child: Hero(
                                tag: _pokem.name,
                                child: CachedNetworkImage(
                                  height: 160,
                                  width: 160,
                                  placeholder: (context, url) => Container(
                                    color: Colors.transparent,
                                  ),
                                  color: count == _pokemonStore.posicaoAtual ? null : Colors.black.withOpacity(0.2),
                                  imageUrl: ConstsAPI.imageURL(_pokem.num),
                                ),
                              ),
                            );
                          }
                        ),
                      ],
                    );
                  },
                )),
          )
        ],
      ),
    );
  }
}
