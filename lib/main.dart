import 'package:flutter/material.dart';
// import 'package:socket_io_client/socket_io_client.dart' as IO;
// import 'dart:convert';

import './chat_room.dart';
// import './msg_form.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Socket.io 同步消息',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Socket.io 同步消息'),
        ),
        body: const ChatRoom(),
        // bottomNavigationBar: const Text('Socket.io 同步消息'),
      ),
    );
  }
}

// class ChatRoom extends StatefulWidget {
//   const ChatRoom({Key? key}) : super(key: key);

//   @override
//   _ChatRoomState createState() => _ChatRoomState();
// }

// class _ChatRoomState extends State {
//   List<Map> _list = [];
//   bool _connected = false;
//   late IO.Socket _socket;
//   String _id = '';

//   @override
//   void initState() {
//     super.initState();

//     _connect();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(children: [
//       Expanded(child: MsgList(list: _list)),
//       // MyCustomForm(),
//       // const Text('Socket.io 同步消息'),
//       MsgForm(connected: _connected, userId: _id, onSubmit: _sendMsg),
//     ]);
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     if (null != _socket) {
//       _socket.disconnect();
//       _socket.destroy();
//       _socket.close();
//       print('new close');
//       // _socket = null;
//     }
//   }

//   void _connect() {
//     print('new connect');
//     _socket = IO.io("http://192.168.16.119:3001/");
//     _socket.onConnect((_) {
//       print('connect');
//       setState(() {
//         _connected = _socket.connected;
//         print(_socket.id);
//         _id = _socket.id!;
//       });
//     });
//     _socket.onDisconnect((_) {
//       print('disconnect');
//       setState(() {
//         _connected = _socket.connected;
//       });
//     });
//     _socket.on('message', (dynamic str) {
//       print(str);
//       setState(() {
//         _list.add(jsonDecode(str));
//       });
//     });
//     _socket.on('history', (dynamic str) {
//       print(str);
//       List<Map> l = [];
//       jsonDecode(str).forEach((it) {
//         l.add(jsonDecode(it));
//       });
//       setState(() {
//         _list.addAll(l);
//       });
//     });
//   }

//   bool _sendMsg(String msg) {
//     if (null != _socket || !_connected) {
//       print('sendMsg failed!');
//       return false;
//     }
//     print('sendMsg: ${msg}');
//     return true;
//   }
// }

// class MsgList extends StatelessWidget {
//   const MsgList({Key? key, required this.list}) : super(key: key);

//   // MsgList(this.list);
//   final List<Map> list;

//   @override
//   Widget build(BuildContext context) {
//     return ListView(
//       children: list.map((it) {
//         return Text(it['message']);
//       }).toList(),
//     );
//   }
// }

// class MsgForm extends StatefulWidget {
//   const MsgForm({
//     Key? key,
//     this.connected = false,
//     this.userId = '',
//     required this.onSubmit,
//   }) : super(key: key);

//   final String userId;
//   final bool connected;
//   final Function onSubmit;

//   @override
//   _MsgFormState createState() => _MsgFormState();
// }

// class _MsgFormState extends State<MsgForm> {
//   final _formKey = GlobalKey<FormState>();

//   _onPressed() {
//     if (_formKey.currentState!.validate()) {
//       // ScaffoldMessenger.of(context).showSnackBar(
//       //   const SnackBar(content: Text('Processing Data')),
//       // );
//       print('onPressed');
//       // widget.onSubmit(_formKey.currentState!.value['text']);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Form(
//       key: _formKey,
//       child: Column(
//         children: <Widget>[
//           TextFormField(
//             minLines: 1,
//             maxLines: 3,
//             // The validator receives the text that the user has entered.
//             validator: (value) {
//               if (value == null || value.isEmpty) {
//                 return 'Please enter some text';
//               }
//               return null;
//             },
//             // onChanged: (value) {
//             //   print('First text field: $value');
//             // },
//           ),
//           Row(children: <Widget>[
//             Expanded(
//               child: Row(
//                 children: [
//                   Text("widget.connected"),
//                   Text(widget.connected ? "连接正常" : "正在重连..."),
//                   Text("  "),
//                   Expanded(
//                     child: Text("widget.userId"),
//                   ),
//                 ],
//               ),
//             ),
//             ElevatedButton(
//               onPressed: _onPressed,
//               child: const Text('发送'),
//             ),
//           ]),
//         ],
//       ),
//     );
//   }
// }
