import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:zakir/src/models/entities/zikir.dart';
import 'package:zakir/src/widgets/player_trigger.dart';
import 'package:zakir/src/widgets/ripple_effect.dart';
import 'package:zakir/src/widgets/source_dialog_box.dart';

import '../../constants.dart';

class ZikirPage extends StatefulWidget {
  final int type;
  final String typeKey;
  final int lastIndex;

  ZikirPage({@required this.type, this.typeKey, this.lastIndex});

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

  final pageKey = RipplePage.createGlobalKey();
  final effectKey = RippleEffect.createGlobalKey();

  static const _vowelGroup1 = [
    1575,
    1576,
    1578,
    1579,
    1580,
    1583,
    1584,
    1585,
    1586,
    1587,
    1588,
    1601,
    1603,
    1604,
    1605,
    1606,
    1608,
    1607,
    1610,
  ];
  static const _vowelGroup2 = [
    1581,
    1582,
    1585,
    1589,
    1590,
    1591,
    1592,
    1593,
    1594,
    1602,
  ];

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
    String toStore = "";
    String incoming = await DefaultAssetBundle.of(context)
        .loadString("assets/data/data.json");
    setState(() {
      var rawData = (json.decode(incoming) as List)
          .where((e) => e["types"].contains(widget.type))
          .toList();
      data = rawData.map((e) {
        var item = Zikir.fromJson(e);
        item.text = item.text ?? _formatSurah(item.textArray);
        toStore += _generateTransliteration(item.text);
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

    writeFile(toStore); // writeFile(_generateTransliteration(item.text))
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
    return RipplePage(
      pageKey: pageKey,
      child: Scaffold(
        key: _scaffoldKey,
        body: SafeArea(
          // bottom: false,
          child: SlidingUpPanel(
            controller: _pc,
            maxHeight: 100,
            minHeight: 0,
            defaultPanelState: PanelState.CLOSED,
            panel: PlayerTrigger(_pc, _calculateStartPoint()),
            body: data.length > 0
                ? Stack(
                    children: <Widget>[
                      RippleEffect(
                        pageKey: pageKey,
                        effectKey: effectKey,
                        animationDuration: const Duration(milliseconds: 300),
                        delay: const Duration(milliseconds: 0),
                        inflateMultiplier: 1.0,
                        color: AppColors.green.withAlpha(35),
                        child: GestureDetector(
                          onHorizontalDragEnd: (details) {
                            if (details.velocity.pixelsPerSecond.dx < 0)
                              _next();
                            if (details.velocity.pixelsPerSecond.dx > 0)
                              _previous();
                          },
                          onTap: _increment,
                          onLongPress: _decrement,
                          // borderRadius:BorderRadius.all(Radius.circular(50)),
                          // radius: 500,
                          // splashFactory: InkRipple
                          //     .splashFactory, //  CustomSplashFactory(),
                          // splashColor: _counter < data[_index].count
                          //     ? AppColors.greenLight.withOpacity(0.3)
                          //     : Colors.transparent,
                          // highlightColor: Colors.transparent,
                          // enableFeedback: false,
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
                                            fontFamily: "Amiri-Quran",
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
                                          style: GoogleFonts.montserrat(
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
                      ),
                      Positioned(
                        bottom: 30,
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
    if (_counter < data[_index].count) {
      if (widget.typeKey == null) {
        setState(() {
          _counter++;
          if (_counter == data[_index].count) _showCompleteMessage();
        });
        RippleEffect.start(effectKey, () {});
      } else
        _saveProgress(widget.typeKey, _index, _counter).then((_) {
          setState(() {
            _counter++;
            if (_counter == data[_index].count) _showCompleteMessage();
          });
          RippleEffect.start(effectKey, () {});
        });
    }
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

  _saveLast({bool completedAll = false}) async {
    SharedPreferences instances = await SharedPreferences.getInstance();
    if (completedAll)
      instances.setInt('lastZikirIndex', 0);
    else
      instances.setInt('lastZikirIndex', _index);
  }

  _saveProgress(String key, int indexInGroup, int value) async {
    SharedPreferences instances = await SharedPreferences.getInstance();
    instances.setInt(key + "_" + indexInGroup.toString(), value);
  }

  void _decrement() {
    setState(() {
      if (_counter > 0) {
        if (widget.typeKey == null) {
          setState(() {
            _counter--;
            if (_counter == 0) _previous();
          });
          // RippleEffect.start(effectKey, () {});
        } else
          _saveProgress(widget.typeKey, _index, _counter).then((_) {
            setState(() {
              _counter++;
              if (_counter == 0) _previous();
            });
            // RippleEffect.start(effectKey, () {});
          });
      }
    });
  }

  void _next({completed = false}) {
    if (_index < data.length - 1) {
      setState(() {
        _elapsedCharLength += _charLengths[_index];
        _index++;
        _counter = 0;
        _saveLast();
      });
    } else {
      _saveLast(completedAll: true);
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

  writeFile(String textData) async {
    final Directory directory = await getExternalStorageDirectory();
    final File file = File('${directory.path}/transcript.txt');
    // file.readAsString().then((String contents) {
    //   contents = contents + "\n\n" + textData;
    //   print(contents);

    // });
    file.writeAsString(textData, mode: FileMode.append).then((File file) {
      print("stored");
    });
  }

  String _generateTransliteration(String text) {
    // print("للّٰهُ".codeUnits);
    var charCodes = text.codeUnits;
    var temp = "";
    charCodes.asMap().forEach((i, codeUnit) {
      // if(codeUnit==1604 && charCodes[i + 1]==1604 && charCodes[i + 2]==1617 && charCodes[i + 3]==1648 && charCodes[i + 4]==1607 )
      if (!((codeUnit > 1610 && codeUnit < 1619) ||
          codeUnit == 1622 ||
          codeUnit == 1648)) {
        if (i < charCodes.length - 1 &&
            _checkMadd(codeUnit, charCodes[i + 1]) &&
            i > 0)
          _setMadd(charCodes[i - 1], codeUnit, temp);
        else
          temp += _getTurkishEquivalent(codeUnit);
      } else if (codeUnit == 1617 && i > 0) // şedde
        temp += _getTurkishEquivalent(charCodes[i - 1]);
      else if (codeUnit == 1618 &&
          i > 0 &&
          (charCodes[i - 1] == 1575 || charCodes[i - 1] == 1593)) // sukuun/cezm
        temp += "'"; // _getSoqoon(charCodes[i - 1]);
      else if (i > 0) temp += _getVowel(charCodes[i - 1], codeUnit);
    });
    temp += "\n\n";
    return temp;
    // print(temp);
    // print({
    //   utf8.decode([217, 132]),
    //   utf8.decode([217, 142]),
    //   utf8.decode([216, 167]),
    //   utf8.decode([32]),
    //   utf8.decode([216, 165])
    // });

    // print(utf8.decode([217,132]));
  }

  // _checkLafzatullah(){
  //   1604, 1604, 1617, 1648, 1607
  // }

  _checkMadd(int charCode, int nextCharCode) {
    return (charCode == 1575 || charCode == 1610 || charCode == 1608) &&
        !(nextCharCode == 1614 || nextCharCode == 1616 || nextCharCode == 1615);
  }

  _setMadd(int previousCharCode, int currentCharCode, String tmp) {
    tmp.substring(0, tmp.length - 1);
    if (currentCharCode == 1575) tmp += "â";
    if (currentCharCode == 1610) tmp += "î";
    if (currentCharCode == 1608) tmp += "û";
  }

  _getSoqoon(int charCode) {
    return charCode == 1575 || charCode == 1593 ? "'" : "";
  }

  _getShadda(int charCode, int vowelCode) {
    return charCode == 1575 || charCode == 1593 ? "'" : "";
  }

  _getVowel(int charCode, int vowelCode) {
    switch (vowelCode) {
      case 1614:
        return _vowelGroup2.contains(charCode) ? "a" : "e";
      case 1616:
        return _vowelGroup1.contains(charCode) ? "i" : "ı";
      case 1615:
        return "u";
      case 1611:
        return _vowelGroup2.contains(charCode) ? "an" : "en";
      case 1613:
        return _vowelGroup1.contains(charCode) ? "in" : "ın";
      case 1612:
        return "un";
      case 1648:
        return "â"; //_vowelGroup2.contains(charCode) ? "â" : "â";
      case 1622:
        return "î"; //_vowelGroup1.contains(charCode) ? "î" : "î";
      default:
        return "";
    }
  }

  _getTurkishEquivalent(int charCode) {
    switch (charCode) {
      case 1575:
        return "a";
      case 1576:
        return "b";
      case 1577:
      case 1578:
        return "t";
      case 1579:
        return "s̱";
      case 1580:
        return "c";
      case 1581:
        return "ḥ";
      case 1582:
        return "ḫ";
      case 1583:
        return "d";
      case 1584:
        return "ẕ";
      case 1585:
        return "r";
      case 1586:
        return "z";
      case 1587:
        return "s";
      case 1588:
        return "ş";
      case 1589:
        return "ṣ";
      case 1590:
        return "ḍ";
      case 1591:
        return "t";
      case 1592:
        return "ẓ";
      case 1593:
        return "a";
      case 1594:
        return "ğ";
      case 1601:
        return "f";
      case 1602:
        return "ḳ";
      case 1603:
        return "k";
      case 1604:
        return "l";
      case 1605:
        return "m";
      case 1606:
        return "n";
      case 1608:
        return "v";
      case 1607:
        return "h";
      case 1609:
      case 1610:
        return "y";
      default:
        return " ";
    }
  }
}
