import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zakir/constants.dart';
import 'package:zakir/src/models/entities/check_version_model.dart';
import 'package:zakir/src/services/storage_service.dart';
import 'package:zakir/src/services/user_service.dart';

import '../../locator.dart';

class CheckVersion {
  UserService _userService = UserService();
  CheckVersionModel versionModel = CheckVersionModel();
  StorageService _storageService = locator<StorageService>();

  ///Kullanıcının telefonundaki versiyon kontrolünü sağlar.
  checkVersion(BuildContext context) async {
    await Future.delayed(Duration(milliseconds: 50));
    await _userService.getVersionInfo(context).then((model) {
      versionModel = model;
    });
    bool isPopupShowed = await _storageService.getUpdatePopupShowed();

    String oldVersion = "";
    String newVersion = "";

    if (versionModel == null) return;

    if (Platform.isIOS) {
      oldVersion = Keys.IOS_VERSION;
      newVersion = versionModel.transporter.ios.version.toString() +
          versionModel.transporter.ios.major.toString() +
          versionModel.transporter.ios.minor.toString();
    } else {
      oldVersion = Keys.ANDROID_VERSION;
      newVersion = versionModel.transporter.android.version.toString() +
          versionModel.transporter.android.major.toString() +
          versionModel.transporter.android.minor.toString();
    }

    //Versiyon numarasının arasındaki noktalar temizleniyor.
    var oldVersions = oldVersion.split(".");
    //var newVersions = newVersiyon.split(".");

    //Major-Minor değişiklikleri kontrol etmek için sayıların ilk iki haneleri ayrı ayrı alınıyor.
    var majorOld = oldVersions[0];
    var minorOld = oldVersions[1];
    var lastCharOld = oldVersions[2];

    var majorNew = newVersion[0];
    var minorNew = newVersion[1];
    var lastCharNew = newVersion[2];

    if (int.parse(majorNew) > int.parse(majorOld)) {
      //Versiyonda değişiklik var ise güncelleştirme indirilmesi için popup açılıyor
      Platform.isIOS
          ? showDialog(
              context: context, child: cupertinoAlertDialog(true, context))
          : showDialog(context: context, child: alertDialog(true, context));
    } else if (int.parse(majorNew) >= int.parse(majorOld) &&
        int.parse(minorNew) > int.parse(minorOld)) {
      if (isPopupShowed == null || !isPopupShowed) {
        //Major değişiklik var ise popup açılıp isteğe bağlı indirmeye yönlendirilebiliyor.
        Platform.isIOS
            ? showDialog(
                context: context, child: cupertinoAlertDialog(false, context))
            : showDialog(context: context, child: alertDialog(false, context));
      }
    } else if (int.parse(majorNew) >= int.parse(majorOld) &&
        int.parse(minorNew) >= int.parse(minorOld) &&
        int.parse(lastCharNew) > int.parse(lastCharOld)) {
      if (isPopupShowed == null || !isPopupShowed) {
        //Minor değişiklik var ise popup açılıp isteğe bağlı indirmeye yönlendirilebiliyor.
        Platform.isIOS
            ? showDialog(
                context: context, child: cupertinoAlertDialog(false, context))
            : showDialog(context: context, child: alertDialog(false, context));
      }
    }

    return versionModel;
  }

  ///Android için alert dialog
  Widget alertDialog(bool isMajor, context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: AlertDialog(
        title: Text("Güncelleme Mevcut!"),
        content: Text("Uygulamanın güncel versiyonunu indirmeniz gerekiyor."),
        actions: <Widget>[
          FlatButton(
            child: Text("İndir"),
            onPressed: () => _launchURL(
                "https://play.google.com/store/apps/details?id=com.sunnahteam.zakir"),
          ),
          !isMajor
              ? FlatButton(
                  child: Text("Sonra"),
                  onPressed: () {
                    Navigator.pop(context);
                    _storageService.setUpdatePopupShowed(true);
                  })
              : Container()
        ],
      ),
    );
  }

  //iOS için alert dialog
  Widget cupertinoAlertDialog(bool isMajor, context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: CupertinoAlertDialog(
        title: Text("Güncelleme Mevcut!"),
        content: Text("Uygulamanın güncel versiyonunu indirmeniz gerekiyor."),
        actions: <Widget>[
          FlatButton(
            child: Text("İndir"),
            onPressed: () => _launchURL(
                "https://apps.apple.com/us/app/gelal-tasimaci/id1499610595?l=tr&ls=1"),
          ),
          !isMajor
              ? FlatButton(
                  child: Text("Sonra"),
                  onPressed: () {
                    Navigator.pop(context);
                    _storageService.setUpdatePopupShowed(true);
                  })
              : Container()
        ],
      ),
    );
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
