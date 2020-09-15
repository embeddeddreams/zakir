import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zakir/constants.dart';
import 'package:zakir/src/models/view_models/zikir_list_vm.dart';
import 'package:zakir/src/providers/app_state_provider.dart';
import 'package:zakir/src/widgets/zikir_item.dart';

import 'list_page.dart';

class Item {
  Item({
    this.expandedWidget,
    this.header,
    this.isExpanded = false,
  });

  Widget expandedWidget;
  String header;
  bool isExpanded;
}

class TrackPage extends StatefulWidget {
  @override
  _TrackPageState createState() => _TrackPageState();
}

class _TrackPageState extends State<TrackPage> {
  AppStateProvider _provider;
  List _allVirdData = [];
  // List<Item> _data = [
  //   Item(
  //       header: 'Günlük Vird',
  //       expandedWidget:

  //   Item(
  //     header: 'Vird Takibi',
  //     expandedWidget: Center(
  //       child: Text(
  //         "Günlük virdinize henüz bir zikir eklemediniz.",
  //         style: TextStyle(color: Colors.black54),
  //       ),
  //     ),
  //   ),
  // ];

  @override
  void initState() {
    var prvdr = Provider.of<AppStateProvider>(context, listen: false);
    print({
      prvdr.currentVirdContent.length.toString(),
      prvdr.currentVirdContent.toString()
    });
    setState(() {
      _allVirdData = prvdr.allZikirData
          .map((e) {
            var item = ZikirListVM.fromJson(e);
            item.text = item.text ?? _formatSurah(item.textArray);
            return item;
          })
          .toList()
          .where((e) => prvdr.currentVirdContent.contains(e.id))
          .toList();
    });
    super.initState();
  }

  String _formatSurah(List<String> array) {
    if (array.length > 2)
      return array.join(' ۞ \n\n');
    else
      return array.join('۞');
  }

  @override
  Widget build(BuildContext context) {
    // _provider = Provider.of<AppStateProvider>(context, listen: false);
    return
        // Column(
        //   children: <Widget>[
        // new Container(
        //   decoration: new BoxDecoration(color: AppColors.greyLight),
        //   child: new TabBar(
        //       controller: _tabController,
        //       indicatorColor: AppColors.green,
        //       indicatorSize: TabBarIndicatorSize.tab,
        //       tabs: [
        //         Tab(
        //           child: Text(
        //             "Konulu Zikirler",
        //             style: TextStyle(
        //               color: AppColors.green,
        //               fontSize: 16,
        //               fontWeight: FontWeight.w500,
        //             ),
        //           ),
        //         ),
        //         Tab(
        //           child: Text(
        //             "Tüm Zikirler",
        //             style: TextStyle(
        //               color: AppColors.green,
        //               fontSize: 16,
        //               fontWeight: FontWeight.w500,
        //             ),
        //           ),
        //         ),
        //       ]),
        // ),
        // Expanded(
        //   child: Container(
        //     color: Colors.white,
        //     child: TabBarView(
        //       controller: _tabController,
        //       children: [

        // ],
        // ),
        // ),
        // ),
        //   ],
        // );
        Container(
      child: SingleChildScrollView(
        child: Column(
          children: List()
            ..add(
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    "Günlük Virdim",
                    style: TextStyle(
                      color: AppColors.green,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            )
            ..add(
              Divider(thickness: 2, height: 0),
            )
            ..addAll(
              _allVirdData.map((item) => ZikirItem(item)).toList(),
            ),
        ),
      ),
      // ListView.builder(
      //   itemCount: _allVirdData.length,
      //   itemBuilder: (BuildContext ctxt, int index) =>
      //       ZikirItem(_allVirdData[index]),
      // ),
    );
  }
}
