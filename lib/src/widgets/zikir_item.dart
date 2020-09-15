import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zakir/constants.dart';
import 'package:zakir/src/models/view_models/zikir_list_vm.dart';
import 'package:zakir/src/providers/app_state_provider.dart';

class ZikirItem extends StatefulWidget {
  final ZikirListVM item;
  final VoidCallback delete;

  ZikirItem(this.item,{this.delete});

  @override
  State<StatefulWidget> createState() {
    return _ZikirItemState();
  }
}

class _ZikirItemState extends State<ZikirItem> {
  AppStateProvider _provider;

  @override
  void initState() {
    _provider = Provider.of<AppStateProvider>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.black26)),
      ),
      // margin: EdgeInsets.symmetric(vertical: 2),
      padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
      height: widget.item.description == null ? 155 : 175,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          widget.item.description == null
              ? Container()
              : Text(
                  widget.item.description,
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.indigoDark,
                    fontWeight: FontWeight.bold,
                  ),
                ),
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
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
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.greenLight,
                      ),
                    ),
              Container(
                width: 50,
                height: 30,
                child: FlatButton(
                  padding: EdgeInsets.zero,
                  onPressed: widget.delete,
                  child: Text(
                    "Kaldır",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.red.withAlpha(200),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
