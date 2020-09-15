import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zakir/constants.dart';
import 'package:zakir/src/providers/app_state_provider.dart';

class ZikirGroupItem extends StatefulWidget {
  final String title;
  final String subtitle;
  final String iconPath;
  final int typeIndex;
  final List<int> zikirIds;
  final VoidCallback onTap;

  ZikirGroupItem(this.title, this.typeIndex, this.iconPath, this.zikirIds,
      {this.subtitle, this.onTap});

  @override
  State<StatefulWidget> createState() {
    return _ZikirGroupItemState();
  }
}

class _ZikirGroupItemState extends State<ZikirGroupItem> {
  @override
  void initState() {
    //
    print(widget.zikirIds);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.black12)),
      ),
      child: Center(
        child: ListTile(
          onTap: widget.onTap,
          leading: Image.asset(
            widget.iconPath,
            width: 32,
            height: 32,
          ),
          title: Text(
            widget.title,
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          subtitle: widget.subtitle == null
              ? null
              : Text(
                  widget.subtitle,
                  style: TextStyle(fontSize: 12),
                ),
          trailing: Icon(
            Icons.chevron_right,
            color: AppColors.green,
          ),
          //  PopupMenuButton<int>(
          //   padding: EdgeInsets.zero,
          //   onSelected: (int val) {
          //     if (val == 1) addAllToVird(widget.zikirIds);
          //   },
          //   itemBuilder: (context) => [
          //     PopupMenuItem(
          //       value: 1,
          //       child: Text(
          //         "Virdime Ekle",
          //         style: TextStyle(color: Colors.black87),
          //       ),
          //     ),
          //     // PopupMenuItem(
          //     //   value: 2,
          //     //   enabled: false,
          //     //   child: Text(
          //     //     "Hatırlatıcı Ekle",
          //     //     style: TextStyle(color: Colors.black26),
          //     //   ),
          //     // ),
          //   ],
          // ),
        ),
      ),
    );
  }
}
