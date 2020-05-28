import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_pokedex/models/specie.dart';
import 'package:flutter_pokedex/stores/pokeapi_store.dart';
import 'package:flutter_pokedex/stores/pokeapi_storeV2.dart';
import 'package:get_it/get_it.dart';
import 'package:md2_tab_indicator/md2_tab_indicator.dart';

class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  PokeApiStore _pokemonStore;
  PageController _pageController;
  PokeApiV2Store _pokeApiV2Store;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _pokemonStore = GetIt.instance<PokeApiStore>();
    _pokeApiV2Store = GetIt.instance<PokeApiV2Store>();
    _pageController = PageController(initialPage: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(0),
            child: Observer(builder: (context) {
              _pokeApiV2Store.getInfoPokemon(_pokemonStore.pokemonAtual.name);
              _pokeApiV2Store
                  .getInfoSpecie(_pokemonStore.pokemonAtual.id.toString());
              return TabBar(
                onTap: (index) {
                  _pageController.animateToPage(
                    index,
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
                controller: _tabController,
                isScrollable: true,
                labelColor: _pokemonStore.corPokemon,
                labelStyle: TextStyle(
                  fontWeight: FontWeight.w700,
                ),
                indicatorSize: TabBarIndicatorSize.label,
                indicator: MD2Indicator(
                    indicatorHeight: 3,
                    indicatorColor: _pokemonStore.corPokemon,
                    indicatorSize: MD2IndicatorSize.normal),
                unselectedLabelColor: Colors.grey[500],
                tabs: <Widget>[
                  Tab(
                    text: "Sobre",
                  ),
                  Tab(
                    text: "Evolução",
                  ),
                  Tab(
                    text: "Status",
                  ),
                ],
              );
            }),
          )),
      body: PageView(
        onPageChanged: (index) {
          _tabController.animateTo(index,
              duration: Duration(milliseconds: 300));
        },
        controller: _pageController,
        children: <Widget>[
          Container(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 30, 20, 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Descrição",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Observer(builder: (context) {
                    Specie specie = _pokeApiV2Store.specie;
                    return specie != null
                        ? Text(
                            specie.flavorTextEntries
                                .where((desc) => desc.language.name == 'en')
                                .first
                                .flavorText,
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          )
                        : Center(
                            child: SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(),
                            ),
                          );
                  }),
                ],
              ),
            ),
          ),
          Container(
          ),
          Container(
          ),
        ],
      ),
    );
  }
}
