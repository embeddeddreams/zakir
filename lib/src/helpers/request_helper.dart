import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zakir/constants.dart';
import 'package:zakir/locator.dart';
import 'package:zakir/src/models/enums.dart';
import 'package:zakir/src/providers/app_state_provider.dart';
import 'package:zakir/src/services/storage_service.dart';

class RequestHelper {
  static Future<String> requestAsync(
      BuildContext context, RequestType requestType, String url,
      [dynamic body, int timeout = Keys.TIMEOUT_INTERVAL]) async {
    print('request started: ' + url);
    AppStateProvider _appStateProvider =
        Provider.of<AppStateProvider>(context, listen: false);

    StorageService storageService = locator<StorageService>();
    String token = await storageService.getTokenAsync();
    print({"token", token});
    HttpClient client = new HttpClient()
      ..badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);

    // displayConnectionWarning(_appStateProvider, context);

    HttpClientResponse response;
    try {
      _appStateProvider.setLoading(true);
      switch (requestType) {
        case RequestType.Post:
          var request = await client.postUrl(Uri.parse(url));
          request.headers.set('content-type', 'application/json-patch+json');
          request.headers.set('accept', 'application/json');
          if (token != null && token.isNotEmpty)
            request.headers.set('authorization', "Bearer $token");
          var jsonBody = json.encode(body);
          request.add(utf8.encode(jsonBody));
          response =
              await request.close().timeout(new Duration(seconds: timeout));
          _appStateProvider.setLoading(false);
          break;
        case RequestType.Put:
          var request = await client.putUrl(Uri.parse(url));
          request.headers.set('content-type', 'application/json-patch+json');
          request.headers.set('accept', 'application/json');
          if (token != null && token.isNotEmpty)
            request.headers.set('authorization', "Bearer $token");
          var jsonBody = json.encode(body);
          request.add(utf8.encode(jsonBody));
          response =
              await request.close().timeout(new Duration(seconds: timeout));
          _appStateProvider.setLoading(false);
          break;
        case RequestType.Get:
          var request = await client.getUrl(Uri.parse(url));
          request.headers.set('content-type', 'application/json-patch+json');
          request.headers.set('accept', 'application/json');
          if (token != null && token.isNotEmpty)
            request.headers.set('authorization', "Bearer $token");
          response =
              await request.close().timeout(new Duration(seconds: timeout));
          _appStateProvider.setLoading(false);
          break;
        case RequestType.Delete:
          var request = await client.deleteUrl(Uri.parse(url));
          request.headers.set('content-type', 'application/json-patch+json');
          request.headers.set('accept', 'application/json');
          if (token != null && token.isNotEmpty)
            request.headers.set('authorization', "Bearer $token");
          response =
              await request.close().timeout(new Duration(seconds: timeout));
          _appStateProvider.setLoading(false);
          break;
      }

      String result = await response.transform(utf8.decoder).join();
      print({"result here: ", result});
      switch (response.statusCode) {
        case 200:
        case 201:
        case 202:
        case 204:
          return result;
        case 401:
          StorageService().clearStorageAsync();
          Navigator.of(context).pushNamedAndRemoveUntil(
              '/login-page', (Route<dynamic> route) => false);
          // print("vaka 1");
          // showDialog(
          //     context: context,
          //     child: AlertWidget(
          //       alertType: AlertType.NoAuthentication,
          //       errorMessage: "Yetkilendirme problemi",
          //     ));
          return '';
        // case 400:
        //   checkResponseMessage(result, context);
        //   break;

        default:
          return '';
      }
    } on SocketException catch (e) {
      print(e);
      // Flushbar(
      //             title:  "Hata",
      //             message:  "Bir Hata Oluştu",
      //             duration:  Duration(seconds: 15),
      //           )..show(context);

      _appStateProvider.setLoading(false);
      return '';
    } on TimeoutException catch (e) {
      print('TimeoutException $e');

      _appStateProvider.setLoading(false);
      return '';
    } catch (e) {
      print('requestAsync methodunda hata oluştu: $e');

      _appStateProvider.setLoading(false);
      return '';
    }
    return null;
  }
}

// void displayConnectionWarning(
//     AppStateProvider _appStateProvider, BuildContext context) {

//   _appStateProvider.checkConnection();
//       _appStateProvider.setLoading(false);

//   if (_appStateProvider.isOnline == false &&
//       !_appStateProvider.isOnlineDisplayed) {
//     print("bağlantı display");
//     Flushbar(
//       title: "Bağlantı Hatası",
//       message: "İnternet Bağlantını Kontrol et",
//       mainButton: FlatButton(
//           onPressed: () async {
//             await AppSettings.openWIFISettings();
//           },
//           child: RText(
//             "WİFİ",
//             color: RTextColor.white,
//           )),
//       duration: Duration(seconds: 10),
//     )..show(context);

//     _appStateProvider.isOnlineDisplayed = true;

//     new Timer(new Duration(milliseconds: 10000), () {
//       _appStateProvider.isOnlineDisplayed = false;
//     });
//   }
// }

logout(BuildContext context) {
  StorageService storageService = locator<StorageService>();
  storageService.clearStorageAsync();
  Navigator.of(context)
      .pushNamedAndRemoveUntil('/login-page', (Route<dynamic> route) => false);
}
