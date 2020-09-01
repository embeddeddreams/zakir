import 'package:flutter/material.dart';
import 'package:zakir/constants.dart';

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
  List<Item> _data = [
    Item(
        header: 'Günlük Vird',
        expandedWidget: Center(
          child: Text(
            "Günlük virdinize henüz bir zikir eklemediniz.",
            style: TextStyle(color: Colors.black54),
          ),
        ),
        isExpanded: true),
    Item(
      header: 'Vird Takibi',
      expandedWidget: Center(
        child: Text(
          "Günlük virdinize henüz bir zikir eklemediniz.",
          style: TextStyle(color: Colors.black54),
        ),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: ExpansionPanelList(
          expansionCallback: (int index, bool isExpanded) {
            setState(() {
              _data[index].isExpanded = !isExpanded;
            });
          },
          children: _data.map<ExpansionPanel>((Item item) {
            return ExpansionPanel(
              headerBuilder: (BuildContext context, bool isExpanded) {
                return ListTile(
                  title: Text(item.header),
                );
              },
              body: ListTile(
                title: item.expandedWidget,
                // onTap: () {
                //   setState(() {
                //     _data.removeWhere((currentItem) => item == currentItem);
                //   });
                // },
              ),
              isExpanded: item.isExpanded,
            );
          }).toList(),
        ),
      ),
    );
  }
}
