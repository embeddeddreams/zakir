import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zakir/constants.dart';
import 'package:zakir/src/models/enums.dart';
import 'package:zakir/src/models/enums.dart';
import 'package:zakir/src/pages/zikir.dart';
import 'package:zakir/src/widgets/z_list_item.dart';

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

  @override
  void initState() {
    _tabController = new TabController(vsync: this, length: 2);
    _getLastPosition();
    super.initState();
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
                    "Zikirler",
                    style: TextStyle(
                      color: AppColors.green,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Tab(
                  child: Text(
                    "Dualar",
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
                            _goToZikir(ZikirType.Awakening.index);
                          },
                        ),
                        ZListItem(
                          "Sabah Zikirleri",
                          ZikirType.Morning.index,
                          AppIcons.morning,
                          subtitle: "Sabah namazı ile öğle namazı arasında",
                          onTap: () {
                            _goToZikir(ZikirType.Morning.index);
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
                Stack(
                  children: <Widget>[
                    ListView(
                      children: <Widget>[
                        ZListItem(
                          "Üzüntü ve Keder Anında Yapılan Dualar",
                          ZikirType.Sadness.index,
                          AppIcons.sadness,
                          onTap: () {
                            _goToZikir(ZikirType.Sadness.index);
                          },
                        ),
                        // _listItem(
                        //   "Üzüntü ve Keder Anında Yapılan Dualar",
                        //   ZikirType.Sadness.index,
                        //   AppIcons.sadness,
                        // ),
                        ZListItem(
                          "Sıkıntı Anında Yapılan Dualar",
                          ZikirType.Trouble.index,
                          AppIcons.trouble,
                          onTap: () {
                            _goToZikir(ZikirType.Trouble.index);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  _listItem(String title, int typeIndex, String iconPath, {String subtitle}) {
    return ListTile(
      // contentPadding: EdgeInsets.fromLTRB(5, 5, 5, 5),
      leading: Image.asset(
        iconPath,
        width: 32,
        height: 32,
      ),
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: subtitle == null
          ? null
          : Text(
              subtitle,
              style: TextStyle(fontSize: 12),
            ),
      trailing: Icon(
        Icons.more_vert,
        color: AppColors.blackLight,
      ),
      onTap: () {
        _saveLastType(typeIndex);
        Navigator.of(context)
            .push(
          MaterialPageRoute(
            builder: (BuildContext context) => ZikirPage(type: typeIndex),
          ),
        )
            .then((_) {
          _getLastPosition();
        });
      },
    );
  }

  _goToZikir(int typeIndex) {
    _saveLastType(typeIndex);
    Navigator.of(context)
        .push(
      MaterialPageRoute(
        builder: (BuildContext context) => ZikirPage(type: typeIndex),
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
}
