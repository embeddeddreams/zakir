import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zakir/src/pages/app_page.dart';
import 'package:provider/provider.dart';
import 'package:zakir/src/providers/app_state_provider.dart';

import 'locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  setupLocator();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // WidgetsFlutterBinding.ensureInitialized();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppStateProvider>(
          create: (context) => locator<AppStateProvider>(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Zikirler',
        // theme: ThemeData(
        // primarySwatch: AppColors.green,
        // ),
        home: AppPage(),
      ),
    );
  }
}
