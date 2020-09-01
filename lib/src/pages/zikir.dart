import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:zakir/src/models/zikir.dart';
import 'package:zakir/src/widgets/player_trigger.dart';
import 'package:zakir/src/widgets/source_dialog_box.dart';

import '../../constants.dart';

class ZikirPage extends StatefulWidget {
  final int type;
  final int lastIndex;

  ZikirPage({@required this.type, this.lastIndex});

  @override
  _ZikirPageState createState() => _ZikirPageState();
}

class _ZikirPageState extends State<ZikirPage> {
  List<Zikir> data = List();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  ScrollController _scrollController = new ScrollController();
  PanelController _pc = new PanelController();
  int _index = 0;
  int _counter = 0;
  List<int> _charLengths = List();
  int _totalCharLength;
  int _elapsedCharLength = 0;

  @override
  void initState() {
    this._index = widget.lastIndex ?? 0;
    _loadData();
    // if (Platform.isIOS) {
    //   if (_audioCache.fixedPlayer != null) {
    //     _audioCache.fixedPlayer.startHeadlessService();
    //   }
    //   _advancedPlayer.startHeadlessService();
    // }
    super.initState();
  }

  _loadData() async {
    String incoming = await DefaultAssetBundle.of(context)
        .loadString("assets/data/data.json");
    setState(() {
      var rawData = (json.decode(incoming) as List)
          .where((e) => e["types"].contains(widget.type))
          .toList();
      data = rawData.map((e) {
        var item = Zikir.fromJson(e);
        item.text = item.text ?? _formatSurah(item.textArray);
        return item;
      }).toList();
      _charLengths = rawData
          .map((x) => x["textArray"] == null
              ? (x["text"].length as int) * (x["count"] as int)
              : (x["textArray"]
                      .map((x) => x.length as int)
                      .toList()
                      .fold(0, (p, c) => p + c) as int) *
                  (x["count"] as int))
          .toList();
      _totalCharLength = _charLengths.fold(0, (p, c) => p + c);
      if (_index > 0)
        _elapsedCharLength =
            _charLengths.sublist(0, _index).fold(0, (p, c) => p + c);
    });
  }

  int _calculateStartPoint() {
    if (data == null || data.length == 0 || _index >= data.length - 1) return 0;

    var timeRange = data[_index].timeRange;
    if (timeRange == null || timeRange.length < 2) return 0;

    var tmp = timeRange[0].split(':');
    return int.parse(tmp[0]) * 60 + int.parse(tmp[1]);
  }

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.light,
    ));
    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: SlidingUpPanel(
          controller: _pc,
          maxHeight: 100,
          minHeight: 0,
          defaultPanelState: PanelState.CLOSED,
          panel: PlayerTrigger(_pc, _calculateStartPoint()),
          body: data.length > 0
              ? Stack(
                  children: <Widget>[
                    InkResponse(
                      // onHorizontalDragEnd: (details) {
                      //   if (details.velocity.pixelsPerSecond.dx < 0) _next();
                      //   if (details.velocity.pixelsPerSecond.dx > 0) _previous();
                      // },
                      onTap: _increment,
                      onLongPress: _decrement,
                      // borderRadius:BorderRadius.all(Radius.circular(50)),
                      // radius: 500,
                      splashFactory:
                          InkRipple.splashFactory, //  CustomSplashFactory(),
                      splashColor: _counter < data[_index].count
                          ? AppColors.greenLight.withOpacity(0.3)
                          : Colors.transparent,
                      highlightColor: Colors.transparent,
                      enableFeedback: false,
                      child: Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.fromLTRB(30, 40, 30, 75),
                        // color: AppColors.greyLight,
                        child: ListView(
                          controller: _scrollController,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(bottom: 20),
                              child: Row(
                                children: <Widget>[
                                  Flexible(
                                    fit: FlexFit.loose,
                                    child: Text(
                                      data[_index].text,
                                      textDirection: TextDirection.rtl,
                                      textAlign: TextAlign.justify,
                                      style: TextStyle(
                                        fontSize: 27,
                                        color: AppColors.indigoDark,
                                        // fontWeight: FontWeight.w500,
                                        fontFamily: "Amiri",
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              child: Row(
                                children: <Widget>[
                                  Flexible(
                                    fit: FlexFit.loose,
                                    child: Text(
                                      data[_index].translation,
                                      textAlign: TextAlign.justify,
                                      style: GoogleFonts.libreBaskerville(
                                        textStyle: TextStyle(
                                          color: Colors.black87,
                                          fontSize: 16,
                                          height: 1.3,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 25,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.fromLTRB(20, 0, 20, 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          // crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                // data[_index].timeRange == null
                                //     ? Container()
                                //     : Container(
                                //         margin: const EdgeInsets.only(right: 20),
                                //         width: 32,
                                //         height: 32,
                                //         child: IconButton(
                                //           padding: EdgeInsets.zero,
                                //           onPressed: () {
                                //             _pc.open();
                                //           },
                                //           icon: Icon(
                                //             Icons.keyboard_arrow_up,
                                //             color: Colors.black54,
                                //             size: 32,
                                //           ),
                                //         ),
                                //       ),

                                Container(
                                  margin: const EdgeInsets.only(right: 10),
                                  width: 32,
                                  height: 32,
                                  child: IconButton(
                                    padding: EdgeInsets.zero,
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        child: SourceDialogBox(
                                          narration: data[_index].narration,
                                          authenticity:
                                              data[_index].authenticity,
                                          reference: data[_index].reference,
                                          height: _setHeight(data[_index]),
                                        ),
                                      );
                                    },
                                    icon: Icon(
                                      Icons.info_outline,
                                      color: AppColors.green,
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 200,
                                  child: Text(
                                    data[_index].reference ?? "",
                                    style: GoogleFonts.libreBaskerville(
                                      textStyle: TextStyle(
                                        color: AppColors.greyDark,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 12,
                                      ),
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  Text(
                                    "$_counter",
                                    style: TextStyle(
                                      color: _counter > 0
                                          ? AppColors.green
                                          : Colors.black26,
                                      fontSize: _counter > 0 ? 32 : 24,
                                      fontWeight: _counter > 0
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 4),
                                    child: Text(
                                      " / ${data[_index].count}",
                                      style: TextStyle(
                                        color: Colors.black26,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: 10,
                      child: SliderTheme(
                        data: SliderThemeData(
                            trackHeight: 12,
                            activeTrackColor: AppColors.green,
                            inactiveTrackColor: AppColors.green.withAlpha(40),
                            thumbColor: Colors.transparent,
                            thumbShape:
                                RoundSliderThumbShape(enabledThumbRadius: 0)),
                        child: Container(
                          height: 12,
                          width: MediaQuery.of(context).size.width,
                          child: Slider(
                            min: 0,
                            max: _totalCharLength.toDouble(),
                            value: _elapsedCharLength.toDouble(),
                            onChanged: (val) {},
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }

  double _setHeight(Zikir e) {
    if (e.narration == null || e.narration.isEmpty) {
      if (e.authenticity == null || e.authenticity.isEmpty)
        return 100;
      else
        return 200;
    } else {
      if (e.authenticity == null || e.authenticity.isEmpty)
        return 200;
      else
        return 300;
    }
  }

  String _formatSurah(List<String> array) {
    if (array.length > 2)
      return array.join(' ۞ \n\n');
    else
      return array.join('۞');
  }

  void _increment() {
    if (_counter < data[_index].count)
      setState(() {
        _counter++;
        if (_counter == data[_index].count) _showCompleteMessage();
      });
  }

  _showCompleteMessage() {
    _scaffoldKey.currentState
        .showSnackBar(
          SnackBar(
            // behavior: SnackBarBehavior.floating,
            backgroundColor: AppColors.green,
            content: Text(
              'Bu zikir tamamlandı',
              style: GoogleFonts.montserrat(
                textStyle: TextStyle(fontSize: 16),
              ),
              textAlign: TextAlign.center,
            ),
            duration: Duration(seconds: 1),
          ),
        )
        .closed
        .whenComplete(() {
      _next();
    });
  }

  _saveLast({bool completed = false}) async {
    SharedPreferences instances = await SharedPreferences.getInstance();
    if (completed)
      instances.setInt('lastZikirIndex', 0);
    else
      instances.setInt('lastZikirIndex', _index);
  }

  void _decrement() {
    setState(() {
      if (_counter > 0) _counter--;
    });
  }

  void _next() {
    if (_index < data.length - 1) {
      setState(() {
        _elapsedCharLength += _charLengths[_index];
        print({_elapsedCharLength,_charLengths[_index]});
        _index++;
        _counter = 0;
        _saveLast();
      });
    } else {
      _saveLast(completed: true);
      Navigator.of(context).pop();
    }
    _scrollController.jumpTo(0);
  }

  void _previous() {
    setState(() {
      if (_index > 0) {
        _index--;
        _counter = 0;
        _elapsedCharLength -= _charLengths[_index];
      } else {
        Navigator.of(context).pop();
      }
    });
    _scrollController.jumpTo(0);
  }
}
