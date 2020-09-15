import 'dart:io';

import 'package:flutter/material.dart';
import 'package:rate_my_app/rate_my_app.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zakir/constants.dart';

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  bool _status = true;
  final FocusNode myFocusNode = FocusNode();
  RateMyApp _rateMyApp = RateMyApp(
    preferencesPrefix: 'rate_my_app_zakir',
    // minDays: 2,
    // minLaunches: 3,
    // remindDays: 3,
    // remindLaunches: 5,
    googlePlayIdentifier: 'com.sunnahteam.zakir',
  );

  // @override
  // void initState() {
  //   _rateMyApp.conditions..reset();
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      child: ListView(
        padding: EdgeInsets.symmetric(vertical: 20),
        children: <Widget>[
          // Container(
          //   padding: EdgeInsets.all(16),
          //   color: Colors.white,
          //   // height: 150,
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: <Widget>[
          //       Row(
          //         children: <Widget>[
          //           Container(
          //             width: 80,
          //             height: 80,
          //             decoration: BoxDecoration(
          //               shape: BoxShape.circle,
          //               image: DecorationImage(
          //                 image: ExactAssetImage('assets/images/gravite.jpg'),
          //                 fit: BoxFit.fitWidth,
          //               ),
          //             ),
          //           ),
          //           Padding(
          //             padding: const EdgeInsets.only(left: 16),
          //             child: Column(
          //               mainAxisAlignment: MainAxisAlignment.center,
          //               crossAxisAlignment: CrossAxisAlignment.start,
          //               children: <Widget>[
          //                 Text(
          //                   "Mustafa Yıldız",
          //                   style: TextStyle(
          //                     fontSize: 16,
          //                     fontWeight: FontWeight.bold,
          //                   ),
          //                 ),
          //                 Text(
          //                   "onnumaramail@gmail.com",
          //                   style: TextStyle(
          //                     fontSize: 16,
          //                     color: Colors.black45,
          //                   ),
          //                 ),
          //               ],
          //             ),
          //           ),
          //         ],
          //       ),
          //       _getEditIcon(),
          //     ],
          //   ),
          // ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              "Sevaba ortak olmak ister misin?",
              style: TextStyle(
                color: AppColors.green,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 5),
            color: Colors.white,
            child: Column(
              children: <Widget>[
                Container(
                  height: 60,
                  child: FlatButton(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "Paylaş & Davet Et",
                            style: TextStyle(fontSize: 16),
                          ),
                          Icon(Icons.chevron_right),
                        ]),
                    onPressed: () async {
                      final RenderBox box = context.findRenderObject();
                      if (Platform.isAndroid)
                        await Share.share(
                            "Güvenilir hadis kaynaklarından derlenmiş zikirleri bir arada bulabileceğin harika bir uygulama!" +
                                "\nhttps://play.google.com/store/apps/details?id=com.sunnahteam.zakir&hl=tr",
                            subject: "Zakir",
                            sharePositionOrigin:
                                box.localToGlobal(Offset.zero) & box.size);
                      // else
                      //   showDialog(
                      //     context: context,
                      //     child: new AlertDialog(
                      //       content: new FlatButton(
                      //         child: new Text(
                      //             "Çok yakında Apple Store da olacağız"),
                      //         onPressed: () => Navigator.pop(context, true),
                      //       ),
                      //     ),
                      //   );
                    },
                  ),
                ),
                Divider(
                  height: 0,
                  thickness: 1,
                ),
                Container(
                  height: 60,
                  child: FlatButton(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "Google Play'de Değerlendir",
                            style: TextStyle(fontSize: 16),
                          ),
                          Icon(Icons.chevron_right),
                        ]),
                    onPressed: () {
                      _rateMyApp.init().then((_) {
                        print("hop");
                        // if (_rateMyApp.shouldOpenDialog) {
                        _rateMyApp.showStarRateDialog(
                          context,
                          title: "Uygulamamızı değerlendir!",
                          message:
                              "Uygulamamızı Google Play'de puanla ve yorumunu yap! Fikirlerin bizim için önemli!",
                          actionsBuilder: (value, stars) {
                            return [
                              FlatButton(
                                onPressed: () async {
                                  await _rateMyApp.callEvent(
                                      RateMyAppEventType.laterButtonPressed);
                                  Navigator.pop<RateMyAppDialogButton>(
                                      context, RateMyAppDialogButton.later);
                                },
                                child: Text(
                                  "Ertele",
                                  style: TextStyle(color: Colors.black54),
                                ),
                              ),
                              FlatButton(
                                onPressed: () async {
                                  await _rateMyApp.callEvent(
                                      RateMyAppEventType.rateButtonPressed);
                                  Navigator.pop<RateMyAppDialogButton>(
                                      context, RateMyAppDialogButton.rate);
                                  _laucnhUrl(
                                      "https://play.google.com/store/apps/details?id=com.sunnahteam.zakir&hl=tr&showAllReviews=true");
                                },
                                child: Text(
                                  "Değerlendir",
                                  style: TextStyle(color: AppColors.green),
                                ),
                              ),
                              // FlatButton(
                              //   onPressed: () async {
                              //     await _rateMyApp.callEvent(
                              //         RateMyAppEventType.noButtonPressed);
                              //     Navigator.pop<RateMyAppDialogButton>(
                              //         context, RateMyAppDialogButton.rate);
                              //   },
                              //   child: Text("Hayır"),
                              // ),
                            ];
                          },
                          dialogStyle: DialogStyle(
                            titleAlign: TextAlign.center,
                            messageAlign: TextAlign.center,
                            messagePadding: EdgeInsets.only(bottom: 20.0),
                          ),
                          starRatingOptions: StarRatingOptions(
                            starsFillColor: AppColors.green,
                            starsBorderColor: Colors.black45,
                            initialRating: 5,
                          ),
                          onDismissed: () => _rateMyApp
                              .callEvent(RateMyAppEventType.laterButtonPressed),
                        );
                        // }
                      });
                    },
                  ),
                ),
                // Divider(
                //   height: 0,
                //   thickness: 1,
                // ),
                // Container(
                //   height: 60,
                //   child: FlatButton(
                //     child: Row(
                //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //         children: <Widget>[
                //           Text(
                //             "Bağış Yap",
                //             style: TextStyle(
                //               fontSize: 16,
                //               color: AppColors.green,
                //               fontWeight: FontWeight.bold,
                //             ),
                //           ),
                //           Icon(Icons.chevron_right),
                //         ]),
                //     onPressed: () {},
                //   ),
                // ),
              ],
            ),
          ),
          //   Container(
          //     height: 180,
          //   ),
          //   Container(
          //     margin: EdgeInsets.only(top: 20),
          //     color: Colors.white,
          //     height: 60,
          //     child: FlatButton(
          //       child: Row(
          //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //           children: <Widget>[
          //             Text(
          //               "Bildirim Ayarları",
          //               style: TextStyle(fontSize: 16),
          //             ),
          //             Icon(Icons.chevron_right),
          //           ]),
          //       onPressed: () {},
          //     ),
          //   ),
          //   Container(
          //     margin: EdgeInsets.only(top: 20),
          //     color: Colors.white,
          //     height: 60,
          //     child: FlatButton(
          //       child: Row(
          //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //           children: <Widget>[
          //             Text(
          //               "Çıkış Yap",
          //               style: TextStyle(fontSize: 16),
          //             ),
          //             Icon(Icons.chevron_right),
          //           ]),
          //       onPressed: () {},
          //     ),
          //   ),
        ],
      ),
    );
  }

  Future<void> _laucnhUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
      );
    } else {
      throw 'Bu linke ulaşılamadı $url';
    }
  }

  Widget _getEditIcon() {
    return GestureDetector(
      child: CircleAvatar(
        backgroundColor: AppColors.green,
        radius: 20.0,
        child: Icon(
          Icons.edit,
          color: Colors.white,
          size: 20.0,
        ),
      ),
      onTap: () {
        Navigator.of(context).pushNamed("/profile");
      },
    );
  }
}
