import 'package:flutter/material.dart';
import 'package:zakir/constants.dart';

class ZListItem extends StatefulWidget {
  final String title;
  final String subtitle;
  final String iconPath;
  final int typeIndex;
  final VoidCallback onTap;

  ZListItem(this.title, this.typeIndex, this.iconPath,
      {this.subtitle, this.onTap});

  @override
  State<StatefulWidget> createState() {
    return _ZListItemState();
  }
}

class _ZListItemState extends State<ZListItem> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
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
        Icons.more_vert,
        color: AppColors.blackLight,
      ),
      onTap: widget.onTap,
    );
  }
}
