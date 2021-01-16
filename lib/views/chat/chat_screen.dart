import 'package:flutter/material.dart';
import 'package:iSalonAgent/utilities/HttpAddress.dart';
import 'package:iSalonAgent/views/BookingDetails.dart';
import 'message_model.dart';
import 'user_model.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:pusher_websocket_flutter/pusher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';

class ChatScreen extends StatefulWidget {
  final SalonChat value;
  ChatScreen({Key key, this.value}) : super(key: key);
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  var httpAddr = HttpAddress();
  Channel channel;
  void initState() {
    super.initState();
    initPusher();
    _fetchChat();
  }

  List<Chat> list = List();
  TextEditingController _messageController = TextEditingController();
  Future _fetchChat() async {
    http.Response chat = await http.get(
        "${httpAddr.url}api/get-chat-salon/${widget.value.booking_id}",
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          'APP_KEY': "8Shm171pe2oTGvJlql7nxe2Ys/tHJaiiVq6vr5wIu5EJhEEmI3gVi"
        });
    setState(() {
      list = (json.decode(chat.body) as List)
          .map((data) => new Chat.fromJson(data))
          .toList();
    });
  }

  void _sendMessage() {
    // print('Booking Id ${widget.value.booking_id.toString()}');
    // print('Message ${_messageController.text}');
    String message = _messageController.text;
    setState(() {
      _messageController.text = '';
    });
    http
        .post(
          "${httpAddr.url}api/save-chat-salon",
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'APP_KEY': "8Shm171pe2oTGvJlql7nxe2Ys/tHJaiiVq6vr5wIu5EJhEEmI3gVi"
          },
          body: jsonEncode(<String, String>{
            'booking_id': widget.value.booking_id.toString(),
            'message': message,
          }),
        )
        .then((response) {});
  }

  Future<void> initPusher() async {
    try {
      await Pusher.init("590b6d6860cec4d1dc67", PusherOptions(cluster: "ap2"),
          enableLogging: true);
    } on PlatformException catch (e) {
      print(e.message);
    }
    Pusher.connect(onConnectionStateChange: (x) async {
      print(x.currentState);
      // if (mounted)
      //   setState(() {
      //     lastConnectionState = x.currentState;
      //   });
    }, onError: (x) {
      debugPrint("Error: ${x.message}");
    });
    channel = await Pusher.subscribe(
        '${widget.value.booking_id.toString().toString()}');
    channel.bind('chat-event', (data) {
      if (mounted) {
        // print(json.decode(data.data));
        list = List();
        _fetchChat();
        // Map values = json.decode(data.data);
        // setState(() {
        //   list.addAll(Chat.fromJson(values));
        // });
        // setState(() {
        //   list = (json.decode(data.data) as List)
        //       .map((data) => new Chat.fromJson(data))
        //       .toList();
        // });
      }
      setState(() {});
    });
  }

  _chatBubble(message, message_from, time) {
    if (message_from == 1) {
      return Column(
        children: <Widget>[
          Container(
            alignment: Alignment.topRight,
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.80,
              ),
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Text(
                "${message}",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
          // !isSameUser
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Text(
                '$time',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                width: 10,
              ),
            ],
          )
          //     : Container(
          //         child: null,
          //       ),
        ],
      );
    } else {
      return Column(
        children: <Widget>[
          Container(
            alignment: Alignment.topLeft,
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.80,
              ),
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Color(0xff323345),
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Text(
                "${message}",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
          // !isSameUser
          Row(
            children: <Widget>[
              SizedBox(
                width: 10,
              ),
              Text(
                '$time',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                ),
              ),
            ],
          )
          //     : Container(
          //         child: null,
          //       ),
        ],
      );
    }
  }

  _sendMessageArea() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8),
      height: 70,
      color: Color(0xff323345),
      child: Row(
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.message),
            iconSize: 25,
            color: Theme.of(context).primaryColor,
            onPressed: () {},
          ),
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration.collapsed(
                hintText: 'Send a message..',
                hintStyle: TextStyle(color: Colors.grey),
              ),
              textCapitalization: TextCapitalization.sentences,
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            iconSize: 25,
            color: Theme.of(context).primaryColor,
            onPressed: () {
              _sendMessage();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff222327),
      appBar: AppBar(
        brightness: Brightness.dark,
        centerTitle: true,
        title: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            children: [
              TextSpan(
                  text: widget.value.salon_name,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  )),
            ],
          ),
        ),
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            color: Colors.white,
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              reverse: true,
              padding: EdgeInsets.all(20),
              itemCount: list.length,
              itemBuilder: (BuildContext context, int index) {
                return _chatBubble(list[index].message.toString(),
                    list[index].message_from, list[index].time);
              },
            ),
          ),
          _sendMessageArea(),
        ],
      ),
    );
  }
}

class Chat {
  String message;
  int message_from;
  String time;
  Chat._({this.message, this.message_from, this.time});
  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat._(
      message: json['message'],
      message_from: json['message_from'],
      time: json['time'],
    );
  }
}
