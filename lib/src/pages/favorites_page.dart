import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zakir/constants.dart';
import 'package:zakir/src/models/view_models/zikir_list_vm.dart';
import 'package:zakir/src/providers/app_state_provider.dart';
import 'package:zakir/src/widgets/zikir_item.dart';

class FavoritesPage extends StatefulWidget {
  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  AppStateProvider _provider;
  List _favoriteList = [];

  @override
  void initState() {
    // setFavoriteList(Provider.of<AppStateProvider>(context, listen: false));
    super.initState();
  }

  setFavoriteList(AppStateProvider provider) {
    setState(() {
      _favoriteList = provider.allZikirData
          .where((e) => provider.favoriteIds.contains(e["id"]))
          .toList()
          .map((e) {
        var item = ZikirListVM.fromJson(e);
        item.text = item.text ?? _formatSurah(item.textArray);
        return item;
      }).toList();
    });
  }

  String _formatSurah(List<String> array) {
    if (array.length > 2)
      return array.join(' ۞ \n\n');
    else
      return array.join('۞');
  }

  @override
  Widget build(BuildContext context) {
    _provider = Provider.of<AppStateProvider>(context);
    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: _provider.allZikirData
              .where((e) => _provider.favoriteIds.contains(e["id"]))
              .toList()
              .map((e) {
                var item = ZikirListVM.fromJson(e);
                item.text = item.text ?? _formatSurah(item.textArray);
                return item;
              })
              .toList()
              .map((item) => ZikirItem(item, delete: () {
                    deleteFromFavorites(item.id);
                  }))
              .toList(),
        ),
      ),
    );
  }

  deleteFromFavorites(int id) {
    print(id.toString());
    _provider.deleteFromFavorites(id);
  }
}
