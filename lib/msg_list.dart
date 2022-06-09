import 'package:flutter/material.dart';

class MsgList extends StatelessWidget {
  const MsgList({Key? key, required this.list}) : super(key: key);

  final List<Map> list;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: list.map((it) {
        return Text(it['message']);
      }).toList(),
    );
  }
}
