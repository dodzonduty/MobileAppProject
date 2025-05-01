import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ListTileElements extends StatelessWidget {
  final String titleListTile;
  final Color? iconColor;
  final Color listTileColor;
  final IconData? leadingIcon;
  final ImageSource listTileSource;
  const ListTileElements({super.key, required this.titleListTile, required this.listTileColor, this.leadingIcon, required this.listTileSource, this.iconColor});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(leadingIcon, color: iconColor),
      title: Text(titleListTile,
      style: TextStyle(
        fontSize: 18.0,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.bold,
        color: listTileColor,
         fontFamily: "Inter")),
      onTap: () {
        Navigator.pop(context, listTileSource);
        },
      );
  }
}