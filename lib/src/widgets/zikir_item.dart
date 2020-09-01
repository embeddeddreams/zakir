import 'package:flutter/material.dart';
import 'package:zakir/constants.dart';
import 'package:zakir/src/models/zikir_list_vm.dart';

class ZikirItem extends StatefulWidget {
  final ZikirListVM item;

  ZikirItem(this.item);

  @override
  State<StatefulWidget> createState() {
    return _ZikirItemState();
  }
}

class _ZikirItemState extends State<ZikirItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.black26)),
      ),
      // margin: EdgeInsets.symmetric(vertical: 2),
      padding: EdgeInsets.all(16),
      height: widget.item.description == null ? 170 : 195,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          widget.item.description == null
              ? Container()
              : Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text(
                    widget.item.description,
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.indigoDark,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(
              widget.item.text,
              textDirection: TextDirection.rtl,
              overflow: TextOverflow.ellipsis,
              maxLines: 3,
              style: TextStyle(
                fontSize: 20,
                color: AppColors.indigoDark,
                fontFamily: "Amiri",
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              widget.item.tag == null
                  ? Container()
                  : Text(
                      widget.item.tag,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppColors.greenLight,
                      ),
                    ),
              Text(
                "Virdime Ekle",
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.green,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
