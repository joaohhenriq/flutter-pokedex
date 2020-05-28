import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_pokedex/stores/pokeapi_store.dart';
import 'package:get_it/get_it.dart';
import 'package:md2_tab_indicator/md2_tab_indicator.dart';

class AboutPage extends StatefulWidget {

  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> with SingleTickerProviderStateMixin{
  TabController tabController;
  PokeApiStore _pokemonStore;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
    _pokemonStore = GetIt.instance<PokeApiStore>();
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
          child: Observer(
            builder: (context) {
              return TabBar(
                controller: tabController,
                isScrollable: true,
                labelColor: _pokemonStore.corPokemon,
                labelStyle: TextStyle(
                  fontWeight: FontWeight.w700,
                ),
                indicatorSize: TabBarIndicatorSize.label,
                indicator: MD2Indicator(
                  indicatorHeight: 3,
                  indicatorColor: _pokemonStore.corPokemon,
                  indicatorSize: MD2IndicatorSize.normal
                ),
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
            }
          ),
        )
      ),
    );
  }
}
