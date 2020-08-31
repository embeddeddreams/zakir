import 'package:flutter/material.dart';
import 'package:zakir/src/pages/app_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // WidgetsFlutterBinding.ensureInitialized();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Zikirler',
      // theme: ThemeData(
      // primarySwatch: AppColors.green,
      // ),
      home: AppPage(),
    );
  }
}
