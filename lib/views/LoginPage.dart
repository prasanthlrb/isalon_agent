import 'package:flutter/material.dart';
// import 'package:flutter_login_signup/src/signup.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:iSalonAgent/Widget/bezierContainer.dart';
import 'package:iSalonAgent/Widget/bezierContainer.dart';
import 'package:iSalonAgent/utilities/HttpAddress.dart';
import 'package:iSalonAgent/views/BottomNavigationBar.dart';
import 'package:iSalonAgent/views/ForgotScreen.dart';
import 'package:iSalonAgent/views/HomePage.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var httpAddr = HttpAddress();
  String _token;
  void _loginNow(context) {
    var httpAddr = HttpAddress();
    if (nameController.text == '') {
      SnackBar snackBar = new SnackBar(
        content: new Text('Email Address is Required'),
        backgroundColor: Color.fromARGB(255, 255, 0, 0),
        duration: Duration(seconds: 5),
      );
      _scaffoldKey.currentState.showSnackBar(snackBar);
    } else if (passwordController.text == '') {
      SnackBar snackBar = new SnackBar(
        content: new Text('Password is Required'),
        backgroundColor: Color.fromARGB(255, 255, 0, 0),
        duration: Duration(seconds: 5),
      );
      _scaffoldKey.currentState.showSnackBar(snackBar);
    } else if (nameController.text != '' && passwordController.text != '') {
      //showAlertDialog(context);
      showLoadingDialog(context);
      http
          .post(
        "${httpAddr.url}api/salon-login",
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'APP_KEY': "8Shm171pe2oTGvJlql7nxe2Ys/tHJaiiVq6vr5wIu5EJhEEmI3gVi"
        },
        body: jsonEncode(<String, String>{
          'email': nameController.text,
          'password': passwordController.text,
          'fcm_token': _token,
        }),
      )
          .then((response) {
        Map mapValue = json.decode(response.body);
        Navigator.of(context, rootNavigator: true).pop(false);
        //print(json.decode(response.body));
        print(mapValue);
        if (response.statusCode == 200) {
          print(mapValue);
          _loginStore(
              mapValue['name'],
              mapValue['salon_id'],
              mapValue['email'],
              mapValue['message'],
              mapValue['user_type'],
              mapValue['cover_image'],
              mapValue['salon_name']);
        } else {
          ///Navigator.of(context, rootNavigator: true).pop(false);
          //Navigator.of(context, rootNavigator: true).pop(false);
          SnackBar snackBar = new SnackBar(
            content: new Text(mapValue['message']),
            backgroundColor: Color.fromARGB(255, 255, 0, 0),
            duration: Duration(seconds: 5),
          );
          _scaffoldKey.currentState.showSnackBar(snackBar);
        }
        // print(mapValue['message']);
        // mapValue.forEach((key, value) {
        //   print(value);
        //   print(key);
        // });
      });
    } else {
      Navigator.of(context, rootNavigator: true).pop(false);
      SnackBar snackBar = new SnackBar(
        content: new Text('Invalid Data'),
        backgroundColor: Color.fromARGB(255, 255, 0, 0),
        duration: Duration(seconds: 5),
      );
      _scaffoldKey.currentState.showSnackBar(snackBar);
    }
  }

  Future<void> _loginStore(name, salon_id, email, message, user_type,
      cover_image, salon_name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', name);
    await prefs.setInt('_id', salon_id);
    await prefs.setInt('user_type', user_type);
    await prefs.setString('email', email);
    await prefs.setString('cover_image', cover_image);
    await prefs.setString('salon_name', salon_name);
    SnackBar snackBar = new SnackBar(
      content: new Text(message),
      backgroundColor: Colors.green,
      duration: Duration(seconds: 5),
    );

    _scaffoldKey.currentState.showSnackBar(snackBar);
    _pageNavigation();
  }

  void _pageNavigation() {
    Navigator.of(context)
        .pushNamedAndRemoveUntil('HomeScreen', (Route<dynamic> route) => false);
  }

  Widget _title() {
    return Image.asset(
      "assets/images/logo.png",
      height: 200.0,
    );
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

  Future<void> getFCM() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('fcm_client_token');
    setState(() {
      _token = token;
    });
  }

  @override
  void initState() {
    super.initState();
    getFCM();
  }

  Future<bool> _onBackPressed() {
    return showDialog(
        barrierColor: Color(0xff222327),
        context: context,
        builder: (context) {
          return Theme(
            data: Theme.of(context)
                .copyWith(dialogBackgroundColor: Color(0xff222327)),
            child: AlertDialog(
              title: Text('Do you want to exit an App'),
              actions: <Widget>[
                FlatButton(
                  child: Text("No"),
                  onPressed: () => Navigator.pop(context, false),
                ),
                FlatButton(
                  child: Text("Yes"),
                  onPressed: () => Navigator.pop(context, true),
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.black,
        body: Container(
          height: height,
          child: Stack(
            children: <Widget>[
              Positioned(
                  top: -height * .15,
                  right: -MediaQuery.of(context).size.width * .4,
                  child: BezierContainer()),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: height * .2),
                      _title(),
                      SizedBox(height: 50),
                      Container(
                          width: context.percentWidth * 100,
                          padding: EdgeInsets.all(0.0),
                          child: TextField(
                            controller: nameController,
                            autocorrect: true,
                            decoration: InputDecoration(
                              hintText: 'your_email'.tr(),
                              prefixIcon: Icon(
                                Icons.email,
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
                        height: 20,
                      ),
                      Container(
                          width: context.percentWidth * 100,
                          padding: EdgeInsets.all(0.0),
                          child: TextField(
                            obscureText: true,
                            controller: passwordController,
                            autocorrect: true,
                            decoration: InputDecoration(
                              hintText: 'enter_password'.tr(),
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
                      // _emailPasswordWidget(),
                      SizedBox(height: 20),
                      GestureDetector(
                        onTap: () {
                          _loginNow(context);
                        },
                        child: Container(
                          height: 50,
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [Color(0xfffbb448), Color(0xffceab67)]),
                          ),
                          child: Center(
                            child: Text("login",
                                    style: TextStyle(
                                        color: Color(0xff232121),
                                        fontWeight: FontWeight.bold))
                                .tr(),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      // _submitButton(),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(PageRouteBuilder(
                              pageBuilder: (_, __, ___) => new ForgotScreen()));
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          alignment: Alignment.centerRight,
                          child: Text(
                            'forgot',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.white),
                          ).tr(),
                        ),
                      ),
                      // _divider(),
                      // _facebookButton(),
                      SizedBox(height: height * .015),
                      // _createAccountLabel(),
                    ],
                  ),
                ),
              ),
              // Positioned(top: 40, left: 0, child: _backButton()),
            ],
          ),
        ),
      ),
    );
  }
}
