import 'package:flutter/material.dart';
import 'package:zakir/constants.dart';

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  bool _status = true;
  final FocusNode myFocusNode = FocusNode();

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
                    onPressed: () {},
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
                    onPressed: () {},
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
                            "Bağış Yap",
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Icon(Icons.chevron_right),
                        ]),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 180,
          ),
          Container(
            margin: EdgeInsets.only(top: 20),
            color: Colors.white,
            height: 60,
            child: FlatButton(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "Bildirim Ayarları",
                      style: TextStyle(fontSize: 16),
                    ),
                    Icon(Icons.chevron_right),
                  ]),
              onPressed: () {},
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 20),
            color: Colors.white,
            height: 60,
            child: FlatButton(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "Çıkış Yap",
                      style: TextStyle(fontSize: 16),
                    ),
                    Icon(Icons.chevron_right),
                  ]),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
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
