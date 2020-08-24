import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants.dart';

class SourceDialogBox extends StatefulWidget {
  SourceDialogBox({
    this.narration,
    this.authenticity,
    this.reference,
    this.height = 100,
  });

  final String narration;
  final String authenticity;
  final String reference;
  final double height;

  @override
  _SourceDialogBoxState createState() => _SourceDialogBoxState();
}

class _SourceDialogBoxState extends State<SourceDialogBox> {
  @override
  Widget build(BuildContext context) {
    print(widget.height);
    return AlertDialog(
      contentPadding: EdgeInsets.fromLTRB(15, 20, 15, 0),
      backgroundColor: AppColors.background,
      elevation: 25,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          width: 2,
          color: AppColors.forestGreen,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      content: Container(
        // height: widget.height,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              widget.narration == null || widget.narration.isEmpty
                  ? SizedBox()
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Text(
                        widget.narration ?? "",
                        textAlign: TextAlign.justify,
                        style: GoogleFonts.montserrat(
                          textStyle: TextStyle(
                            color: AppColors.indigoDark,
                            // fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
              widget.authenticity == null || widget.authenticity.isEmpty
                  ? SizedBox(height: 10)
                  : Padding(
                      padding: const EdgeInsets.fromLTRB(5, 10, 5, 10),
                      child: Text(
                        widget.authenticity ?? "",
                        textAlign: TextAlign.justify,
                        style: GoogleFonts.notoSans(
                          textStyle: TextStyle(
                            color: Colors.black.withAlpha(170),
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
              Text(
                widget.reference ?? "",
                style: GoogleFonts.libreBaskerville(
                  textStyle: TextStyle(
                    color: AppColors.blackLight,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[],
    );
  }
}
