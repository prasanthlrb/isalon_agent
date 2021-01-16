import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iSalonAgent/utilities/HttpAddress.dart';
import 'package:velocity_x/velocity_x.dart';
import 'dart:convert';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:easy_localization/easy_localization.dart';

class PasswordChange extends StatefulWidget {
  @override
  _PasswordChange createState() => _PasswordChange();
}

class _PasswordChange extends State<PasswordChange> {
  var httpAddr = HttpAddress();
  TextEditingController _oldPasswordController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int cut_id;
  Future<void> getProfileDetails() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt('_id');
    setState(() {
      cut_id = id;
    });
  }

  _resetAction(context) {
    if (_passwordController.text.length < 8) {
      _alertDialog("Password Length More than 8");
    } else if (_passwordController.text != _confirmPasswordController.text) {
      _alertDialog("Password and Confirm Password Not Match");
    } else if (_oldPasswordController.text.length < 8) {
      _alertDialog("Please Enter Valid Old Password");
    } else {
      showLoadingDialog(context);
      http
          .post(
        "${httpAddr.url}api/salon-change-password",
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'APP_KEY': "8Shm171pe2oTGvJlql7nxe2Ys/tHJaiiVq6vr5wIu5EJhEEmI3gVi"
        },
        body: jsonEncode(<String, String>{
          'oldpassword': _oldPasswordController.text,
          'password': _passwordController.text,
          'salon_id': cut_id.toString(),
        }),
      )
          .then((response) {
        setState(() {});
        Map mapValue = json.decode(response.body);
        if (response.statusCode == 200) {
          Navigator.of(context, rootNavigator: true).pop(false);
          SnackBar snackBar = new SnackBar(
            content: new Text(mapValue['message']),
            backgroundColor: Colors.greenAccent,
            duration: Duration(seconds: 5),
          );
          _scaffoldKey.currentState.showSnackBar(snackBar);
        } else {
          Navigator.of(context, rootNavigator: true).pop(false);
          _alertDialog(mapValue['message']);
        }
      });
    }
  }

  void _alertDialog(String msg) {
    SnackBar snackBar = new SnackBar(
      content: new Text(msg),
      backgroundColor: Color.fromARGB(255, 255, 0, 0),
      duration: Duration(seconds: 5),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  showLoadingDialog(BuildContext context) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => AlertDialog(
        content: SizedBox(
            height: 84.0,
            child: Row(children: <Widget>[
              const SizedBox(width: 15.0),
              SizedBox(
                width: 100.0,
                child: Image.asset(
                  'assets/images/new_loading.gif',
                ),
              ),
              const SizedBox(width: 15.0),
              Expanded(
                child: Text('Please Wait...',
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 22.0,
                        fontWeight: FontWeight.w400)),
              )
            ])),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getProfileDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color(0xff222327),
      appBar: AppBar(
        title: Text(
          "change_password",
          style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 15.0,
              color: Colors.black54,
              fontFamily: "Gotik"),
        ).tr(),
        centerTitle: true,
        iconTheme: IconThemeData(color: Color(0xFF6991C7)),
        elevation: 0.0,
      ),
      body: Container(
        color: Color(0xff222327),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(20),
            ),
            SizedBox(height: 20),
            Expanded(
              child: Container(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(30),
                    child: Column(
                      children: <Widget>[
                        Text(
                          "change_password",
                          style: TextStyle(
                              color: Color(0xffceab67),
                              fontWeight: FontWeight.bold,
                              fontSize: 34.0),
                        ).tr(),
                        SizedBox(
                          height: 30,
                        ),
                        Text(
                          "old_password_enter",
                          style: TextStyle(color: Colors.grey, fontSize: 16.0),
                        ).tr(),
                        SizedBox(
                          height: 50.0,
                        ),
                        Container(
                            width: context.percentWidth * 100,
                            padding: EdgeInsets.all(0.0),
                            child: TextField(
                              obscureText: true,
                              controller: _oldPasswordController,
                              autocorrect: true,
                              decoration: InputDecoration(
                                hintText: 'old_password'.tr(),
                                prefixIcon: Icon(
                                  Icons.remove_red_eye,
                                  color: Colors.grey,
                                ),
                                hintStyle: TextStyle(color: Colors.grey),
                                filled: true,
                                fillColor: Color(0xff323345),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30.0)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30.0)),
                                ),
                              ),
                            )),
                        SizedBox(
                          height: 40.0,
                        ),
                        Container(
                          width: context.percentWidth * 100,
                          padding: EdgeInsets.all(0.0),
                          child: TextField(
                            obscureText: true,
                            controller: _passwordController,
                            autocorrect: true,
                            decoration: InputDecoration(
                              hintText: 'enter_new_password'.tr(),
                              prefixIcon: Icon(
                                Icons.remove_red_eye,
                                color: Colors.grey,
                              ),
                              hintStyle: TextStyle(color: Colors.grey),
                              filled: true,
                              fillColor: Color(0xff323345),
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30.0)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30.0)),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 40.0,
                        ),
                        Container(
                            width: context.percentWidth * 100,
                            padding: EdgeInsets.all(0.0),
                            child: TextField(
                              obscureText: true,
                              controller: _confirmPasswordController,
                              autocorrect: true,
                              decoration: InputDecoration(
                                hintText: 'enter_confirm_password'.tr(),
                                prefixIcon: Icon(
                                  Icons.remove_red_eye,
                                  color: Colors.grey,
                                ),
                                hintStyle: TextStyle(color: Colors.grey),
                                filled: true,
                                fillColor: Color(0xff323345),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30.0)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30.0)),
                                ),
                              ),
                            )),
                        SizedBox(
                          height: 40.0,
                        ),
                        GestureDetector(
                          onTap: () {
                            _resetAction(context);
                          },
                          child: Container(
                            height: 50,
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: Color(0xffceab67)),
                            child: Center(
                              child: Text(
                                "update",
                                style: TextStyle(
                                    color: Color(0xff232121),
                                    fontWeight: FontWeight.bold),
                              ).tr(),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
