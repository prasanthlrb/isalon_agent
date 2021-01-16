import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:iSalonAgent/utilities/progressdialog.dart';
import 'package:http/http.dart' as http;
import 'package:iSalonAgent/utilities/HttpAddress.dart';
import 'package:easy_localization/easy_localization.dart';

class ResetPage extends StatefulWidget {
  int _id;
  ResetPage(this._id);
  @override
  _ResetPage createState() => _ResetPage(_id);
}

class _ResetPage extends State<ResetPage> {
  _ResetPage(_id);
  var httpAddr = HttpAddress();
  TextEditingController _otpController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  void _signupAction(context) {
    print(widget._id.toString());
    if (_passwordController.text == '' || _passwordController.text == null) {
      _alertDialog("Please enter password");
    } else if (_passwordController.text != _confirmController.text) {
      _alertDialog("Password and ConfirmPassword Not Match");
    } else if (_passwordController.text.length < 8) {
      _alertDialog("Password Length More than 8");
    } else if (_otpController.text == '' || _otpController.text == null) {
      _alertDialog("Password Enter OTP");
    } else {
      showLoadingDialog(context);
      http
          .post(
        "${httpAddr.url}api/salon-reset-password",
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'APP_KEY': "8Shm171pe2oTGvJlql7nxe2Ys/tHJaiiVq6vr5wIu5EJhEEmI3gVi"
        },
        body: jsonEncode(<String, String>{
          'salon_id': widget._id.toString(),
          'otp': _otpController.text,
          'password': _passwordController.text,
        }),
      )
          .then((response) {
        Map mapValue = json.decode(response.body);
        Navigator.of(context, rootNavigator: true).pop(false);
        if (response.statusCode == 200) {
          Navigator.of(context).pushNamedAndRemoveUntil(
              'LoginScreen', (Route<dynamic> route) => false);
          // Navigator.of(context).push(PageRouteBuilder(
          //     pageBuilder: (_, __, ___) => new ResetPage(mapValue['_id'])));
          // _signUpStore(mapValue['name'], mapValue['customer_id'],
          //     mapValue['email'], mapValue['phone'], mapValue['message']);
        } else {
          _alertDialog(mapValue['message']);
        }
        // print(mapValue['message']);
        // mapValue.forEach((key, value) {
        //   print(value);
        //   print(key);
        // });
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

  // _ResetPage(_id);
  ProgressDialog pr;
  @override
  Widget build(BuildContext context) {
    pr = new ProgressDialog(context, ProgressDialogType.Normal);
    pr.setMessage('Please Wait...');
    return Scaffold(
      key: _scaffoldKey,
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
                          "reset_password",
                          style: TextStyle(
                              color: Color(0xffceab67),
                              fontWeight: FontWeight.bold,
                              fontSize: 34.0),
                        ).tr(),
                        SizedBox(
                          height: 30,
                        ),
                        Text(
                          "please_enter_otp",
                          style: TextStyle(color: Colors.grey, fontSize: 16.0),
                        ).tr(),
                        SizedBox(
                          height: 50.0,
                        ),
                        Container(
                          width: context.percentWidth * 100,
                          padding: EdgeInsets.all(0.0),
                          child: TextField(
                            autocorrect: true,
                            controller: _otpController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: 'OTP',
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
                              controller: _passwordController,
                              obscureText: true,
                              autocorrect: true,
                              decoration: InputDecoration(
                                hintText: 'enter_new_password'.tr(),
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
                          height: 40.0,
                        ),
                        Container(
                            width: context.percentWidth * 100,
                            padding: EdgeInsets.all(0.0),
                            child: TextField(
                              controller: _confirmController,
                              obscureText: true,
                              autocorrect: true,
                              decoration: InputDecoration(
                                hintText: 'enter_confirm_password'.tr(),
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
                          height: 40.0,
                        ),
                        GestureDetector(
                          onTap: () {
                            _signupAction(context);
                            // Navigator.of(context).push(PageRouteBuilder(
                            //     pageBuilder: (_, __, ___) =>
                            //         new RegisterScreen()));
                            // socialBottomSheet(context);
                            // print("Social Network pressed");
                          },
                          child: Container(
                            height: 50,
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: Color(0xffceab67)),
                            child: Center(
                              child: Text(
                                "reset_password".tr(),
                                style: TextStyle(
                                    color: Color(0xff232121),
                                    fontWeight: FontWeight.bold),
                              ),
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
