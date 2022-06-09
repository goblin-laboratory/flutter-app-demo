import 'package:flutter/material.dart';

class MsgForm extends StatefulWidget {
  const MsgForm({
    Key? key,
    this.connected = false,
    this.userId = '',
    required this.onSubmit,
  }) : super(key: key);

  final String userId;
  final bool connected;
  final Function onSubmit;

  @override
  _MsgFormState createState() => _MsgFormState();
}

class _MsgFormState extends State<MsgForm> {
  final _formKey = GlobalKey<FormState>();
  String _msg = '';

  _onPressed() {
    if (_formKey.currentState!.validate()) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(content: Text('Processing Data')),
      // );
      print('onPressed');
      print('_msg: ${_msg}');
      widget.onSubmit(_msg);
      _formKey.currentState!.reset();
      // widget.onSubmit(_formKey.currentState!.value['text']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            minLines: 1,
            maxLines: 3,
            // The validator receives the text that the user has entered.
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '请输入消息';
              }
              return null;
            },
            onChanged: (val) {
              _msg = val;
            },
          ),
          Row(children: <Widget>[
            Expanded(
              child: Row(
                children: [
                  Text(widget.connected ? "连接正常" : "正在重连..."),
                  Text("    "),
                  Expanded(
                    child: Text(widget.userId),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: _onPressed,
              child: const Text('发送'),
            ),
          ]),
        ],
      ),
    );
  }
}
