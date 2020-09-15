import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:zakir/constants.dart';
import 'package:zakir/locator.dart';
import 'package:zakir/src/helpers/check_version.dart';
import 'package:zakir/src/services/storage_service.dart';

class AppStateProvider with ChangeNotifier {
  bool _loading = false;
  Queue<bool> _loadings = Queue<bool>();
  bool _isOnline = true;
  bool _isVersionChecked = false;
  Future<Null> isWorkingVersion;
  List<int> _currentVirdContent = [1, 2, 3, 4, 5, 6];
  List<int> _favoriteIds = [];
  List _allZikirData = [];

  /* ---------------------------------------------Getters-------------------------------------------- */

  bool get isOnline => this._isOnline; //internet durumunu verir
  bool get loading => this._loading;
  List<int> get currentVirdContent => this._currentVirdContent;
  List<int> get favoriteIds => this._favoriteIds;
  List<dynamic> get allZikirData => this._allZikirData;

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

  addToVird(int newId) async {
    if (!_currentVirdContent.contains(newId)) {
      this._currentVirdContent.add(newId);
      locator<StorageService>()
          .setVirdContent(_currentVirdContent.map((e) => e.toString()).toList())
          .then((_) {
        notifyListeners();
      });
    }
  }

  addToFavorites(int newId) async {
    if (!_favoriteIds.contains(newId)) {
      this._favoriteIds.add(newId);
      await locator<StorageService>()
          .setFavorites(_favoriteIds.map((e) => e.toString()).toList());
      notifyListeners();
    }
  }

  deleteFromFavorites(int newId) async {
    _favoriteIds = _favoriteIds.where((element) => element != newId).toList();
    print("hop");
    print(_favoriteIds);
    await locator<StorageService>()
        .setFavorites(_favoriteIds.map((e) => e.toString()).toList());
    print("hop");
    notifyListeners();
  }

  setAllData(incoming) async {
    _allZikirData = json.decode(incoming) as List<dynamic>;

    final tmp1 = await locator<StorageService>().getFavorites() ?? [];
    _favoriteIds = tmp1.map((e) => int.parse(e)).toList();
    print({"favorites", _favoriteIds});

    notifyListeners();
  }
}
