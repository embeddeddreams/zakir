import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zakir/src/models/enums.dart';
import 'package:zakir/src/pages/zikir.dart';

import 'constants.dart';

void main() => runApp(MyApp());

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

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Zikirler',
      theme: ThemeData(
          // primarySwatch: AppColors.green,
          ),
      home: MyHomePage(title: 'Sabah Akşam Zikirleri'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _lastIndex = 0;
  int _lastType;

  @override
  void initState() {
    _getLastPosition();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: AppColors.forestGreen,
    ));
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(0, 50),
        child: AppBar(
          title: Image(
            image: AssetImage(
              'assets/images/logo-greenLight.png',
            ),
            height: 30,
            width: 30 * 3.33,
          ),
          centerTitle: true,
          backgroundColor: AppColors.green,
        ),
      ),
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          ListView(
            children: <Widget>[
              // _listItem(
              //   "Uyanınca Yapılan Zikirler",
              //   ZikirType.Awakening.index,
              //   AppIcons.awakening,
              // ),
              _listItem(
                "Sabah Zikirleri",
                ZikirType.Morning.index,
                AppIcons.morning,
                subtitle: "Sabah namazı ile öğle namazı arasında",
              ),
              _listItem(
                "Akşam Zikirleri",
                ZikirType.Evening.index,
                AppIcons.evening,
                subtitle: "İkindi kerahet vakti girmesinden itibaren",
              ),
              // _listItem(
              //   "Uyku Öncesi Zikirler",
              //   ZikirType.BeforeSleep.index,
              //   AppIcons.beforeSleep,
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
                          Navigator.of(context)
                              .push(
                            MaterialPageRoute(
                              builder: (BuildContext context) => ZikirPage(
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
    );
  }

  _listItem(String title, int typeIndex, String iconPath, {String subtitle}) {
    return subtitle == null
        ? FlatButton(
            padding: EdgeInsets.zero,
            onPressed: () {
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
            child: Column(
              children: <Widget>[
                ListTile(
                  leading: Image.asset(
                    iconPath,
                    width: 32,
                    height: 32,
                  ),
                  title: Text(
                    title,
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  trailing: Icon(
                    Icons.keyboard_arrow_right,
                    color: AppColors.green,
                  ),
                ),
                Divider(),
              ],
            ),
          )
        : FlatButton(
            padding: EdgeInsets.zero,
            onPressed: () {
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
            child: Column(
              children: <Widget>[
                ListTile(
                  leading: Image.asset(
                    iconPath,
                    width: 32,
                    height: 32,
                  ),
                  title: Text(
                    title,
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  subtitle: Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      // fontStyle: FontStyle.italic,
                    ),
                  ),
                  trailing: Icon(
                    Icons.keyboard_arrow_right,
                    color: AppColors.green,
                  ),
                ),
                Divider(color: Colors.black26),
              ],
            ),
          );
  }

  _saveLastType(int typeIndex) async {
    SharedPreferences instances = await SharedPreferences.getInstance();
    instances.setInt('lastZikirType', typeIndex);
  }

  _getLastPosition() async {
    SharedPreferences instances = await SharedPreferences.getInstance();
    setState(() {
      this._lastIndex = instances.getInt('lastZikirIndex');
      this._lastType = instances.getInt('lastZikirType');
    });
  }
}
