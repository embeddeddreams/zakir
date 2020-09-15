import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zakir/constants.dart';
import 'package:zakir/src/models/enums.dart';
import 'package:zakir/src/models/view_models/zikir_list_vm.dart';
import 'package:zakir/src/pages/zikir_page.dart';
import 'package:zakir/src/providers/app_state_provider.dart';
import 'package:zakir/src/widgets/zikir_group_item.dart';
import 'package:zakir/src/widgets/zikir_item.dart';

class Zikir {
  // final List<int> type;
  final int count;
  final String path;
  final String matn;
  final String meaning;
  final String reference;
  final String source;

  Zikir(this.count, this.path, this.meaning,
      {this.matn, this.reference, this.source});
}

class ListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ListPageState();
  }
}

class _ListPageState extends State<ListPage> with TickerProviderStateMixin {
  AppStateProvider _provider;
  TabController _tabController;
  int _lastIndex = 0;
  int _lastType;
  List _allRawData = List<ZikirListVM>();
  List toProgressShow = ["morning"];
  List progressRecords = List<int>();

  @override
  void initState() {
    _tabController = new TabController(vsync: this, length: 2);
    _getLastPosition();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _provider = Provider.of<AppStateProvider>(context, listen: false);
    return Container(
      color: Colors.white,
      child: Stack(
        children: <Widget>[
          ListView(
            children: <Widget>[
              ZikirGroupItem(
                "Uyanınca Yapılan Zikirler",
                ZikirType.Awakening.index,
                AppIcons.awakening,
                _allRawData
                    .where((item) =>
                        item.types.contains(ZikirType.Awakening.index))
                    .map((item) => item.id as int)
                    .toList(),
                onTap: () {
                  _goToZikirGroup(
                    ZikirType.Awakening.index,
                    ZikirPageType.Group.index,
                    typeKey: "awakening",
                  );
                },
              ),
              ZikirGroupItem(
                "Sabah Zikirleri",
                ZikirType.Morning.index,
                AppIcons.morning,
                _allRawData
                    .where(
                        (item) => item.types.contains(ZikirType.Morning.index))
                    .map((item) => item.id as int)
                    .toList(),
                subtitle: "Sabah namazı ile öğle namazı arasında",
                onTap: () {
                  _goToZikirGroup(
                    ZikirType.Morning.index,
                    ZikirPageType.Group.index,
                    typeKey: "morning",
                  );
                },
              ),
              ZikirGroupItem(
                "Akşam Zikirleri",
                ZikirType.Evening.index,
                AppIcons.evening,
                _allRawData
                    .where(
                        (item) => item.types.contains(ZikirType.Evening.index))
                    .map((item) => item.id as int)
                    .toList(),
                subtitle: "İkindi kerahet vakti girmesinden itibaren",
                onTap: () {
                  _goToZikirGroup(
                      ZikirType.Evening.index, ZikirPageType.Group.index);
                },
              ),
              ZikirGroupItem(
                "Üzüntü ve Keder Anında Yapılan Dualar",
                ZikirType.Sadness.index,
                AppIcons.sadness,
                _allRawData
                    .where(
                        (item) => item.types.contains(ZikirType.Sadness.index))
                    .map((item) => item.id as int)
                    .toList(),
                onTap: () {
                  _goToZikirGroup(
                      ZikirType.Sadness.index, ZikirPageType.Single.index);
                },
              ),
              ZikirGroupItem(
                "Sıkıntı Anında Yapılan Dualar",
                ZikirType.Trouble.index,
                AppIcons.trouble,
                _allRawData
                    .where(
                        (item) => item.types.contains(ZikirType.Trouble.index))
                    .map((item) => item.id as int)
                    .toList(),
                onTap: () {
                  _goToZikirGroup(
                      ZikirType.Trouble.index, ZikirPageType.Single.index);
                },
              ),
              // FlatButton(
              //   child: Text(
              //     "Bildirim",
              //     style: TextStyle(
              //         color: AppColors.green.withAlpha(200)),
              //   ),
              //   onPressed: showNotification,
              // ),
            ],
          ),
          _lastType != null && _lastIndex > 0
              ? Positioned(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: 50,
                      margin: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(width: 1, color: AppColors.green),
                      ),
                      child: FlatButton(
                        // padding: EdgeInsets.zero,
                        child: Text(
                          "Kaldığın zikirden devam et",
                          style:
                              TextStyle(color: AppColors.green.withAlpha(200)),
                        ),
                        onPressed: () {
                          if (_lastType != null)
                            Navigator.of(context)
                                .push(
                              MaterialPageRoute(
                                builder: (BuildContext context) => ZikirPage(
                                  rawData: _provider.allZikirData
                                      .where(
                                          (e) => e["types"].contains(_lastType))
                                      .toList(),
                                  type: ZikirPageType.Group.index,
                                  lastIndex: _lastIndex,
                                  favoriteIds: _provider.favoriteIds,
                                ),
                              ),
                            )
                                .then((_) {
                              _getLastPosition();
                            });
                        },
                      ),
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  _goToZikirGroup(int groupIndex, int zikirPageType, {String typeKey}) {
    _saveLastType(groupIndex);
    Navigator.of(context)
        .push(
      MaterialPageRoute(
        builder: (BuildContext context) => ZikirPage(
          rawData: _provider.allZikirData
              .where((e) => e["types"].contains(groupIndex))
              .toList(),
          type: zikirPageType,
          typeKey: typeKey,
          favoriteIds: _provider.favoriteIds,
        ),
      ),
    )
        .then((_) {
      _getLastPosition();
    });
  }

  _saveLastType(int typeIndex) async {
    SharedPreferences instances = await SharedPreferences.getInstance();
    instances.setInt('lastZikirType', typeIndex);
  }

  _getLastPosition() async {
    SharedPreferences instances = await SharedPreferences.getInstance();
    setState(() {
      this._lastIndex = instances.getInt('lastZikirIndex') ?? 0;
      this._lastType = instances.getInt('lastZikirType');
    });
  }

  Future<int> _getProgress(String key, int indexInGroup) async {
    SharedPreferences instances = await SharedPreferences.getInstance();
    return instances.getInt(key + "_" + indexInGroup.toString()) ?? 0;
  }

  addAllToVird(List<int> ids) {
    final curr = _provider.currentVirdContent;
    print(curr.toString());
    ids.forEach((newId) {
      print(newId.toString());
      if (!curr.contains(newId)) _provider.addToVird(newId);
    });
  }

  //  Stack(
  //                 children: <Widget>[
  //                   ListView(
  //                     children: <Widget>[
  //                       ZikirItem()
  // ZikirGroupItem(
  //   "Üzüntü ve Keder Anında Yapılan Dualar",
  //   ZikirType.Sadness.index,
  //   AppIcons.sadness,
  //   onTap: () {
  //     _goToZikirGroup(ZikirType.Sadness.index);
  //   },
  // ),
  // ZikirGroupItem(
  //   "Sıkıntı Anında Yapılan Dualar",
  //   ZikirType.Trouble.index,
  //   AppIcons.trouble,
  //   onTap: () {
  //     _goToZikirGroup(ZikirType.Trouble.index);
  //   },
  // ),
  //       ],
  //     ),
  //   ],
  // ),
}
