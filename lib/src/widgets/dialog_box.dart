import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import '../../constants.dart';

/// Defines variants of entry animations
enum EntryAnimation {
  /// Appears in Center, standard Material dialog entrance animation, i.e. slow fade-in in the center of the screen.
  DEFAULT,

  /// Enters screen horizontally from the left
  LEFT,

  /// Enters screen horizontally from the right
  RIGHT,

  /// Enters screen horizontally from the top
  TOP,

  /// Enters screen horizontally from the bottom
  BOTTOM,

  /// Enters screen from the top left corner
  TOP_LEFT,

  /// Enters screen from the top right corner
  TOP_RIGHT,

  /// Enters screen from the bottom left corner
  BOTTOM_LEFT,

  /// Enters screen from the bottom right corner
  BOTTOM_RIGHT,
}

class DialogBox extends StatefulWidget {
  DialogBox({
    Key key,
    this.imageWidget,
    @required this.title,
    this.titleColor = Colors.black87,
    this.onOkButtonPressed,
    this.description,
    this.onlyOkButton = true,
    this.buttonOkText,
    this.buttonCancelText,
    this.buttonOkColor,
    this.buttonCancelColor,
    this.cornerRadius,
    this.buttonRadius,
    this.entryAnimation,
    this.onCancelButtonPressed,
  }) : super(key: key);

  final Widget imageWidget;
  final String title;
  final Color titleColor;
  final String description;
  final bool onlyOkButton;
  final String buttonOkText;
  final String buttonCancelText;
  final Color buttonOkColor;
  final Color buttonCancelColor;
  final double buttonRadius;
  final double cornerRadius;
  final VoidCallback onOkButtonPressed;
  final VoidCallback onCancelButtonPressed;
  final EntryAnimation entryAnimation;

  @override
  _DialogBoxState createState() => _DialogBoxState();
}

class _DialogBoxState extends State<DialogBox> with TickerProviderStateMixin {
  AnimationController _animationController;
  Animation<Offset> _entryAnimation;

  get _start {
    switch (widget.entryAnimation) {
      case EntryAnimation.DEFAULT:
        break;
      case EntryAnimation.TOP:
        return Offset(0.0, -1.0);
      case EntryAnimation.TOP_LEFT:
        return Offset(-1.0, -1.0);
      case EntryAnimation.TOP_RIGHT:
        return Offset(1.0, -1.0);
      case EntryAnimation.LEFT:
        return Offset(-1.0, 0.0);
      case EntryAnimation.RIGHT:
        return Offset(1.0, 0.0);
      case EntryAnimation.BOTTOM:
        return Offset(0.0, 1.0);
      case EntryAnimation.BOTTOM_LEFT:
        return Offset(-1.0, 1.0);
      case EntryAnimation.BOTTOM_RIGHT:
        return Offset(1.0, 1.0);
    }
  }

  get _isDefaultEntryAnimation =>
      widget.entryAnimation == EntryAnimation.DEFAULT;

  @override
  void initState() {
    super.initState();
    if (!_isDefaultEntryAnimation) {
      _animationController = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 300),
      );
      _entryAnimation =
          Tween<Offset>(begin: _start, end: Offset(0.0, 0.0)).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Curves.easeIn,
        ),
      )..addListener(() => setState(() {}));
      _animationController.forward();
    }
  }

  // @override
  // void dispose() {
  //   _animationController?.dispose();
  //   super.dispose();
  // }

  Widget _buildPortraitWidget(BuildContext context, Widget imageWidget) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(widget.cornerRadius ?? 8),
                topLeft: Radius.circular(widget.cornerRadius ?? 8)),
            child: imageWidget,
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              widget.title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: widget.titleColor,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 20),
              child: Text(
                widget.description ?? '',
                style: TextStyle(
                  // fontSize: 14,
                  color: Colors.black54,
                ),
              ),
            ),
            _buildButtonsBar(context)
          ],
        ),
      ],
    );
  }

  Widget _buildButtonsBar(BuildContext context) {
    var buttons = List<Widget>();
    // widget.onlyOkButton
    //     ? Container()
    //     : buttons.add(
    //         Container(
    //           width: MediaQuery.of(context).size.width * 0.4 - 30,
    //           child: RButton(
    //             widget.buttonCancelText ?? "Vazgeç",
    //             widget.onCancelButtonPressed ??
    //                 () => Navigator.of(context).pop(),
    //             color: widget.buttonCancelColor ?? AppColors.green,
    //             type: RButtonType.outlined,
    //           ),
    //         ),
    //       );
    buttons.add(
      Container(
        width: MediaQuery.of(context).size.width * 0.4 - 30,
        child: RaisedButton(
          onPressed:
              widget.onOkButtonPressed ?? () => Navigator.of(context).pop(),
          child: Text(
            widget.buttonOkText ?? "Tamam",
            style: TextStyle(color: widget.buttonOkColor ?? AppColors.green),
          ),
        ),
      ),
    );

    return Row(
      mainAxisAlignment: !widget.onlyOkButton
          ? MainAxisAlignment.spaceBetween
          : MainAxisAlignment.center,
      children: buttons,
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Dialog(
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: Container(
        transform: !_isDefaultEntryAnimation
            ? Matrix4.translationValues(
                _entryAnimation.value.dx * width,
                _entryAnimation.value.dy * width,
                0,
              )
            : null,
        height: MediaQuery.of(context).size.height * 0.6,
        width: MediaQuery.of(context).size.width * (0.8),
        child: Material(
            type: MaterialType.card,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(widget.cornerRadius ?? 8),
            ),
            elevation: Theme.of(context).dialogTheme.elevation ?? 24.0,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: _buildPortraitWidget(context, widget.imageWidget),
            )),
      ),
    );
  }
}
