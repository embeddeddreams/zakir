import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:zakir/constants.dart';
import 'package:zakir/src/pages/favorites_page.dart';
import 'package:zakir/src/providers/app_state_provider.dart';

import 'account_page.dart';
import 'list_page.dart';
import 'track_page.dart';
import 'zikir_page.dart';
// import 'package:kakule/src/widgets/drawer.dart';

class AppPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AppPageState();
  }
}

class _AppPageState extends State<AppPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _index = 0;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    var initializationSettingsAndroid =
        AndroidInitializationSettings('logotransparent');
    var initializationSettingsIOs = IOSInitializationSettings();
    var initSetttings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOs);

    flutterLocalNotificationsPlugin
        .initialize(initSetttings, onSelectNotification: onSelectNotification)
        .then((value) {
      // if (value) scheduleNotification();
    });

    loadData();
    super.initState();
  }

  PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  loadData() async {
    String incoming = await DefaultAssetBundle.of(context)
        .loadString("assets/data/data.json");
    Provider.of<AppStateProvider>(context, listen: false).setAllData(incoming);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: AppColors.forestGreen,
    ));
    return Scaffold(
      key: _scaffoldKey,
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
      backgroundColor: AppColors.background,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (int index) {
          bottomTapped(index);
        },
        // backgroundColor: AppColors.background,
        elevation: 16,
        selectedItemColor: AppColors.green,
        unselectedItemColor: Colors.black26,
        iconSize: 30,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        items: buildBottomNavBarItems(),
      ),
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        onPageChanged: (index) {
          pageChanged(index);
        },
        children: <Widget>[
          ListPage(),
          FavoritesPage(),
          AccountPage(),
        ],
      ),
    );
  }

  List<BottomNavigationBarItem> buildBottomNavBarItems() {
    return [
      BottomNavigationBarItem(
        icon: Icon(Icons.home),
        title: Text('Anasayfa'),
      ),
      // BottomNavigationBarItem(
      //   icon: Icon(Icons.person),
      //   title: Text('Program'),
      // ),
      BottomNavigationBarItem(
        icon: Icon(Icons.favorite),
        title: Text('Favoriler'),
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.settings),
        title: Text('Ayarlar'),
      ),
    ];
  }

  void pageChanged(int index) {
    setState(() {
      this._index = index;
    });
  }

  void bottomTapped(int index) {
    setState(() {
      this._index = index;
      pageController.animateToPage(index,
          duration: Duration(milliseconds: 100), curve: Curves.ease);
    });
  }

  Future onSelectNotification(String payload) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) {
        return ZikirPage(type: int.parse(payload));
      }),
    );
  }

  Future<void> scheduleNotification() async {
    var scheduledNotificationDateTime =
        DateTime.now().add(Duration(seconds: 5));
    var androidSpecs = AndroidNotificationDetails(
      'id', 'name', 'description',
      priority: Priority.High, importance: Importance.Max,
      // icon: 'flutter_devs',
      // largeIcon: DrawableResourceAndroidBitmap('flutter_devs'),
    );
    var iOSSpecs = IOSNotificationDetails();
    var platformSpecs = NotificationDetails(androidSpecs, iOSSpecs);
    await flutterLocalNotificationsPlugin.schedule(
      0,
      'scheduled title',
      'scheduled body',
      scheduledNotificationDateTime,
      platformSpecs,
      payload: '1',
      androidAllowWhileIdle: true,
    );
  }

  Future<void> cancelNotification() async {
    await flutterLocalNotificationsPlugin.cancel(0);
  }

  showNotification() async {
    var android = new AndroidNotificationDetails(
        'id', 'channel ', 'description',
        priority: Priority.High, importance: Importance.Max);
    var iOS = new IOSNotificationDetails();
    var platform = new NotificationDetails(android, iOS);
    await flutterLocalNotificationsPlugin.show(
        0, 'Flutter devs', 'Flutter Local Notification Demo', platform,
        payload: '1');
  }
}
