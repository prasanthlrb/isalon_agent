import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:iSalonAgent/utilities/HttpAddress.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';

class AlertPage extends StatefulWidget {
  @override
  _AlertPage createState() => _AlertPage();
}

class _AlertPage extends State<AlertPage> {
  var httpAddr = HttpAddress();
  List<Alert> alert = List();
  Future getAbout() async {
    http.Response alertData = await http
        .get("${httpAddr.url}api/get-push-notification-shop/${_id}", headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
      'APP_KEY': "8Shm171pe2oTGvJlql7nxe2Ys/tHJaiiVq6vr5wIu5EJhEEmI3gVi"
    });
    setState(() {
      alert = (json.decode(alertData.body) as List)
          .map((data) => new Alert.fromJson(data))
          .toList();
    });
    removeAlerts();
  }

  int _id;
  _getProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _id = prefs.getInt('_id');
    });
  }

  Future<bool> _showAlert(title, desc) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Color(0xff222327),
        contentPadding: EdgeInsets.only(left: 25, right: 25),
        title: Center(child: Text("${title}")),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        content: Container(
          height: 150,
          width: 300,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Text(
                "${desc}",
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ),
        ),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width * 0.20,
                child: RaisedButton(
                  child: new Text(
                    'Close',
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Color(0xFF121A21),
                  shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30.0),
                  ),
                  onPressed: () {
                    //saveIssue();
                    Navigator.of(context).pop();
                  },
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.01,
              ),
            ],
          )
        ],
      ),
    );
  }

  static var _txtCustomHead = TextStyle(
    color: Colors.black54,
    fontSize: 17.0,
    fontWeight: FontWeight.w600,
    fontFamily: "Gotik",
  );

  static var _txtCustomSub = TextStyle(
    color: Colors.black38,
    fontSize: 15.0,
    fontWeight: FontWeight.w500,
    fontFamily: "Gotik",
  );
  Future<void> removeAlerts() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('alerts');
  }

  @override
  void initState() {
    super.initState();
    getAbout();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff222327),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil(
              'HomeScreen', (Route<dynamic> route) => false),
        ),
        title: Text(
          "notification",
          style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 15.0,
              color: Colors.black54,
              fontFamily: "Gotik"),
        ).tr(),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Color(0xff222327),
          child: Column(
            children: alert.map((e) {
              return GestureDetector(
                onTap: () {
                  _showAlert(e.title.toString(), e.description.toString());
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 12.0, top: 20.0, right: 12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          ClipRRect(
                            borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(20),
                                topRight: Radius.circular(20)),
                            child: Card(
                              color: Colors.white,
                              elevation: 5,
                              shape: Border(
                                  right: BorderSide(
                                      color: Color(0xffceab67), width: 8)),
                              child: ListTile(
                                leading: Icon(
                                  Icons.notification_important,
                                  size: 50.0,
                                ),
                                title: Text(
                                  e.title.toString(),
                                  style: TextStyle(color: Color(0xffceab67)),
                                ),
                                subtitle: Text(
                                  e.description.toString(),
                                  style: TextStyle(
                                      color: Colors.black.withOpacity(0.6)),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class Alert {
  String title;
  String description;

  Alert._({this.title, this.description});
  factory Alert.fromJson(Map<String, dynamic> json) {
    return Alert._(
      title: json['title'],
      description: json['description'],
    );
  }
}
