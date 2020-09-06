import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zakir/constants.dart';
import 'package:zakir/src/models/enums.dart';
import 'package:zakir/src/models/view_models/zikir_list_vm.dart';
import 'package:zakir/src/pages/zikir.dart';
import 'package:zakir/src/widgets/z_list_item.dart';
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
    _loadData();
    super.initState();
  }

  _loadData() async {
    String incoming = await DefaultAssetBundle.of(context)
        .loadString("assets/data/data.json");
    setState(() {
      _allRawData = (json.decode(incoming) as List).map((e) {
        var item = ZikirListVM.fromJson(e);
        item.text = item.text ?? _formatSurah(item.textArray);
        return item;
      }).toList();
      // _getProgress();
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
    return Column(
      children: <Widget>[
        new Container(
          decoration: new BoxDecoration(color: AppColors.greyLight),
          child: new TabBar(
              controller: _tabController,
              indicatorColor: AppColors.green,
              indicatorSize: TabBarIndicatorSize.tab,
              tabs: [
                Tab(
                  child: Text(
                    "Tasnif Edilmiş",
                    style: TextStyle(
                      color: AppColors.green,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Tab(
                  child: Text(
                    "Hepsi",
                    style: TextStyle(
                      color: AppColors.green,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ]),
        ),
        Expanded(
          child: Container(
            color: Colors.white,
            child: TabBarView(
              controller: _tabController,
              children: [
                Stack(
                  children: <Widget>[
                    ListView(
                      children: <Widget>[
                        ZListItem(
                          "Uyanınca Yapılan Zikirler",
                          ZikirType.Awakening.index,
                          AppIcons.awakening,
                          onTap: () {
                            _goToZikir(
                              ZikirType.Awakening.index,
                              typeKey: "awakening",
                            );
                          },
                        ),
                        ZListItem(
                          "Sabah Zikirleri",
                          ZikirType.Morning.index,
                          AppIcons.morning,
                          subtitle: "Sabah namazı ile öğle namazı arasında",
                          onTap: () {
                            _goToZikir(
                              ZikirType.Morning.index,
                              typeKey: "morning",
                            );
                          },
                        ),
                        ZListItem(
                          "Akşam Zikirleri",
                          ZikirType.Evening.index,
                          AppIcons.evening,
                          subtitle: "İkindi kerahet vakti girmesinden itibaren",
                          onTap: () {
                            _goToZikir(ZikirType.Evening.index);
                          },
                        ),
                        ZListItem(
                          "Üzüntü ve Keder Anında Yapılan Dualar",
                          ZikirType.Sadness.index,
                          AppIcons.sadness,
                          onTap: () {
                            _goToZikir(ZikirType.Sadness.index);
                          },
                        ),
                        ZListItem(
                          "Sıkıntı Anında Yapılan Dualar",
                          ZikirType.Trouble.index,
                          AppIcons.trouble,
                          onTap: () {
                            _goToZikir(ZikirType.Trouble.index);
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
                                  border: Border.all(
                                      width: 1, color: AppColors.green),
                                ),
                                child: FlatButton(
                                  // padding: EdgeInsets.zero,
                                  child: Text(
                                    "Kaldığın zikirden devam et",
                                    style: TextStyle(
                                        color: AppColors.green.withAlpha(200)),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context)
                                        .push(
                                      MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            ZikirPage(
                                          type: _lastType,
                                          lastIndex: _lastIndex,
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
                ListView.builder(
                  itemCount: _allRawData.length,
                  itemBuilder: (BuildContext ctxt, int index) =>
                      ZikirItem(_allRawData[index]),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  _goToZikir(int typeIndex, {String typeKey}) {
    _saveLastType(typeIndex);
    Navigator.of(context)
        .push(
      MaterialPageRoute(
        builder: (BuildContext context) =>
            ZikirPage(type: typeIndex, typeKey: typeKey),
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

  //  Stack(
  //                 children: <Widget>[
  //                   ListView(
  //                     children: <Widget>[
  //                       ZikirItem()
  // ZListItem(
  //   "Üzüntü ve Keder Anında Yapılan Dualar",
  //   ZikirType.Sadness.index,
  //   AppIcons.sadness,
  //   onTap: () {
  //     _goToZikir(ZikirType.Sadness.index);
  //   },
  // ),
  // ZListItem(
  //   "Sıkıntı Anında Yapılan Dualar",
  //   ZikirType.Trouble.index,
  //   AppIcons.trouble,
  //   onTap: () {
  //     _goToZikir(ZikirType.Trouble.index);
  //   },
  // ),
  //       ],
  //     ),
  //   ],
  // ),
}
