import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'dart:convert';

import './msg_list.dart';
import './msg_form.dart';

class ChatRoom extends StatefulWidget {
  const ChatRoom({Key? key}) : super(key: key);

  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State {
  final List<Map> _list = [];
  late IO.Socket _socket;
  bool _connected = false;
  String _id = '';

  @override
  void initState() {
    super.initState();

    _connect();
  }

  @override
  void dispose() {
    super.dispose();
    _connected = false;
    _id = '';
    _socket.disconnect();
    _socket.destroy();
    _socket.close();
    print('close socket');
    // if (null != _socket) {
    //   _socket.disconnect();
    //   _socket.destroy();
    //   _socket.close();
    //   print('close socket');
    //   _socket = null;
    // }
  }

  void _connect() {
    print('new connect');
    _socket = IO.io("http://192.168.16.119:3001/",
        IO.OptionBuilder().setTransports(['websocket']).build());
    _socket.onConnect((_) {
      print('connect');
      setState(() {
        _connected = _socket.connected;
        print(_socket.id);
        _id = _socket.id!;
      });
    });
    _socket.onDisconnect((_) {
      print('disconnect');
      setState(() {
        _connected = _socket.connected;
      });
    });
    _socket.on('connect_error', (dynamic str) {
      _connected = _socket.connected;
      print('connect_error: $str');
    });
    _socket.on('error', (dynamic str) {
      print('error: $str');
    });

    _socket.on('message', (dynamic str) {
      setState(() {
        _list.add(jsonDecode(str));
      });
    });
    _socket.on('history', (dynamic str) {
      List<Map> l = [];
      jsonDecode(str).forEach((it) {
        l.add(jsonDecode(it));
      });
      setState(() {
        _list.addAll(l);
      });
    });
  }

  bool _sendMsg(String msg) {
    if (true != _connected || '' == _id) {
      print('sendMsg failed!');
      return false;
    }
    final Map<String, dynamic> data = {
      'type': 'message',
      'userId': _id,
      'message': msg,
    };
    _socket.emit("message", jsonEncode(data));
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Expanded(child: MsgList(list: _list)),
      MsgForm(connected: _connected, userId: _id, onSubmit: _sendMsg),
    ]);
  }
}
