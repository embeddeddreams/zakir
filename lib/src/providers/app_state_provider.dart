import 'dart:async';
import 'dart:collection';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:zakir/locator.dart';
import 'package:zakir/src/helpers/check_version.dart';
import 'package:zakir/src/services/storage_service.dart';

class AppStateProvider with ChangeNotifier {
  bool _loading = false;
  Queue<bool> _loadings = Queue<bool>();
  bool _isOnline = true;
  bool _isVersionChecked = false;
  Future<Null> isWorkingVersion;

  /* ---------------------------------------------Getters-------------------------------------------- */

  bool get isOnline => this._isOnline; //internet durumunu verir
  bool get loading => this._loading;

/* ---------------------------------------------Setters-------------------------------------------- */

  void setLoading(
    bool loading,
  ) {
    try {
      if (loading) {
        _loadings.add(true);
      } else
        _loadings.removeFirst();
    } catch (e) {}
    this._loading = this._loadings.length > 0;

    // debugPrint("loading durumu ===>" +
    //     this._loadings.length.toString() +
    //     " , " +
    //     _loading.toString());
    notifyListeners();
  }

/* internet bağlantısı için connection oluşturuyor */
  void checkConnection() async {
    Connectivity connectivity = Connectivity();
    ConnectivityResult result = await connectivity.checkConnectivity();
    _checkStatus(result);
    connectivity.onConnectivityChanged.listen((result) {
      _checkStatus(result);
    });
  }

/* internet kontrollu yapan method */
  void _checkStatus(ConnectivityResult result) async {
    try {
      final result = await InternetAddress.lookup('gelal.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        this._isOnline = true;
        notifyListeners();
      } else
        this._isOnline = false;
      notifyListeners();
    } on SocketException catch (_) {
      this._isOnline = false;
      notifyListeners();
    }
  }

/* version kontrol */
  Future checkVersion(BuildContext context) async {
    if (isWorkingVersion != null) {
      await isWorkingVersion; // wait for future complete
      return checkVersion(context);
    }

    // lock
    var completer = new Completer<Null>();
    isWorkingVersion = completer.future;

    if (!this._isVersionChecked) {
      bool result = await locator<StorageService>().userTokenDoesExist();
      if (result) {
        CheckVersion().checkVersion(context);
        this._isVersionChecked = true;
        if (!completer.isCompleted) completer.complete();
        isWorkingVersion = null;
      }
    }

    if (!completer.isCompleted) completer.complete();
    isWorkingVersion = null;
  }
}
