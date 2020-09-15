import 'package:flutter/widgets.dart';

class Keys {
  static const USER_TOKEN = "UserToken";
  static const USER_FIREBASE_TOKEN = "UserFirebaseToken";
  static const IOS_VERSION = "5.0.3";
  static const ANDROID_VERSION = "5.0.3";
  static const SHOW_VERSION_UPDATE = "ShowVersionUpdate";
  static const CURRENT_VIRD = "currentVird";
  static const FAVORITES = "favorites";
  static const int TIMEOUT_INTERVAL = 15; //servis istekleri icin verilen sure
}

class ApiServiceUrl {
  static final _baseUrl = 'https://gelal.com/api/';
  static final checkVersion = _baseUrl + 'membership/1.0/userdevice/version';
}

class AppColors {
  static final forestGreen = const Color(0xff1A4314);
  static final green = const Color(0xff2C5E1A);
  static final greenLight = const Color(0xffB2D2A4);
  static final background = const Color(0xfff0f3f9);
  static final indigoDark = const Color(0xff152238);
  static final black = const Color(0xff272727);
  static final blackLight = const Color(0xff818181);
  static final greyDark = const Color(0xffb8b8b8);
  static final grey = const Color(0xffd6d6d6);
  static final greyLight = const Color(0xfff3f3f3);
}

class AppIcons {
  static final morning = 'assets/icons/sunrise.png';
  static final evening = 'assets/icons/dusk.png';
  static final beforeSleep = 'assets/icons/bedtime.png';
  static final awakening = 'assets/icons/insomnia.png';
  static final sadness = 'assets/icons/sadness.png';
  static final trouble = 'assets/icons/trouble.png';
}
