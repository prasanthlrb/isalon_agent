import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:iSalonAgent/utilities/progressdialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iSalonAgent/views/ResetPage.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:iSalonAgent/utilities/HttpAddress.dart';
import 'package:easy_localization/easy_localization.dart';

class ForgotScreen extends StatefulWidget {
  @override
  _ForgotScreen createState() => _ForgotScreen();
}

class _ForgotScreen extends State<ForgotScreen> {
  var httpAddr = HttpAddress();
  TextEditingController _emailController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  // ProgressDialog pr;
  void _signupAction(context) {
    print('Working');
    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(_emailController.text);
    if (emailValid == false) {
      // pr.hide();
      _alertDialog("Enter Valid Email ID");
    } else {
      showLoadingDialog(context);
      http
          .post(
        "${httpAddr.url}api/salon-forget-password",
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'APP_KEY': "8Shm171pe2oTGvJlql7nxe2Ys/tHJaiiVq6vr5wIu5EJhEEmI3gVi"
        },
        body: jsonEncode(<String, String>{
          'email': _emailController.text,
        }),
      )
          .then((response) {
        Map mapValue = json.decode(response.body);
        Navigator.of(context, rootNavigator: true).pop(false);
        if (response.statusCode == 200) {
          // pr.hide();
          print(mapValue);
          print(mapValue['_id']);
          Navigator.of(context).push(PageRouteBuilder(
              pageBuilder: (_, __, ___) => new ResetPage(mapValue['_id'])));
          // _signUpStore(mapValue['name'], mapValue['customer_id'],
          //     mapValue['email'], mapValue['phone'], mapValue['message']);
        } else {
          // pr.hide();
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

  @override
  Widget build(BuildContext context) {
    // pr = ProgressDialog(context, ProgressDialogType.Normal);
    // pr.setMessage('Please Wait...');
    return SafeArea(
      child: Scaffold(
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
                IconButton(
                    icon: new Icon(
                      Icons.arrow_back,
                      color: Color(0xffceab67),
                      size: 30.0,
                    ),
                    onPressed: () {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          'LoginScreen', (Route<dynamic> route) => false);
                    }),
                SizedBox(height: 20),
                Expanded(
                  child: Container(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.all(30),
                        child: Column(
                          children: <Widget>[
                            Text(
                              "forgot_password",
                              style: TextStyle(
                                  color: Color(0xffceab67),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 34.0),
                            ).tr(),
                            SizedBox(
                              height: 30,
                            ),
                            Text(
                              "forgot_page_details",
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 16.0),
                            ).tr(),
                            SizedBox(
                              height: 70.0,
                            ),
                            Container(
                                width: context.percentWidth * 100,
                                padding: EdgeInsets.all(0.0),
                                child: TextField(
                                  controller: _emailController,
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
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(30.0)),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(30.0)),
                                    ),
                                  ),
                                )),
                            SizedBox(
                              height: 70.0,
                            ),
                            GestureDetector(
                              onTap: () {
                                // pr.show();
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
                                    "reset_password",
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
          )),
    );
  }
}
