import 'package:flutter/material.dart';
import 'package:iSalonAgent/views/AlertPage.dart';
import 'package:iSalonAgent/views/Language.dart';
import 'package:iSalonAgent/views/PasswordChange.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:iSalonAgent/utilities/HttpAddress.dart';
import 'package:iSalonAgent/utilities/HttpAddress.dart';

class ProfilePage extends StatefulWidget {
  @override
  _profilState createState() => _profilState();
}

/// Custom Font
var _txt = TextStyle(
  color: Colors.black,
  fontFamily: "CM Sans Serif",
);

String _name = '';
String _cover_image = '';

/// Get _txt and custom value of Variable for Name User
var _txtName = _txt.copyWith(
    fontWeight: FontWeight.w700, color: Colors.white, fontSize: 17.0);

/// Get _txt and custom value of Variable for Edit text
var _txtEdit = _txt.copyWith(color: Colors.black26, fontSize: 15.0);

/// Get _txt and custom value of Variable for Category Text
var _txtCategory = _txt.copyWith(
    fontSize: 14.5, color: Colors.white, fontWeight: FontWeight.w500);

class _profilState extends State<ProfilePage> {
  var httpAddr = HttpAddress();
  _logout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('_id');
    prefs.remove('name');
    prefs.remove('email');
    prefs.remove('user_type');
    prefs.remove('cover_image');
    prefs.remove('salon_name');

    Navigator.of(context).pushNamedAndRemoveUntil(
        'LoginScreen', (Route<dynamic> route) => false);
    // Navigator.of(context)
    //     .push(PageRouteBuilder(pageBuilder: (_, __, ___) => new LoginScreen()));
  }

  _login() {
    Navigator.of(context).pushNamedAndRemoveUntil(
        'LoginScreen', (Route<dynamic> route) => false);
  }

  _getProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _name = prefs.getString('name');
      _cover_image = prefs.getString('cover_image');
    });
  }

  Future<bool> _onBackPressed() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
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
  }

  void initState() {
    super.initState();
    _getProfileData();
  }

  manageAddress() {
    if (_name == null || _name == '' || _name == 'Guest') {
      return Padding(
        padding: const EdgeInsets.all(0.0),
      );
    } else {
      return category(
        txt: "profile2",
        padding: 30.0,
        image: "assets/icon/address.png",
        tap: () {
          // Navigator.of(context).push(PageRouteBuilder(
          //     pageBuilder: (_, __, ___) => new AddressPlace()));
        },
      );
    }
  }

  editProfile() {
    if (_name == null || _name == '' || _name == 'Guest') {
      return Padding(
        padding: const EdgeInsets.all(0.0),
      );
    } else {
      return InkWell(
        onTap: () {
          Navigator.of(context).push(PageRouteBuilder(
              pageBuilder: (_, __, ___) => new PasswordChange()));
        },
        child: Padding(
          padding: const EdgeInsets.only(top: 5.0),
          child: Text(
            "profile1",
            style: _txtEdit,
          ).tr(),
        ),
      );
    }
  }

  loginOut() {
    if (_name == null || _name == '' || _name == 'Guest') {
      return category(
        padding: 38.0,
        txt: "profile7",
        image: "assets/icon/login.png",
        tap: () {
          _login();
        },
      );
    } else {
      return category(
        padding: 38.0,
        txt: "profile6",
        image: "assets/icon/logout.png",
        tap: () {
          _logout();
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    var _profile_link = Padding(
      padding: const EdgeInsets.only(top: 210.0),
      child: Column(
        /// Setting Category List
        children: <Widget>[
          /// Call category class
          Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: Text(
              'hello'.tr() + ' ${_name}',
              style: _txtName,
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Divider(
              color: Colors.grey,
              height: 2.0,
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.of(context).push(PageRouteBuilder(
                  pageBuilder: (_, __, ___) => new PasswordChange()));
            },
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 15.0, left: 30.0),
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(right: 30.0, left: 30.0),
                        child: Icon(
                          Icons.remove_red_eye,
                          size: 23.0,
                          color: Color(0xffceab67),
                        ),
                      ),
                      Text(
                        'change_password',
                        style: _txtCategory,
                      ).tr(),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Divider(
              color: Colors.grey,
              height: 2.0,
            ),
          ),

          InkWell(
            onTap: () {
              Navigator.of(context).push(PageRouteBuilder(
                  pageBuilder: (_, __, ___) => new LanguagePage()));
            },
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 15.0, left: 30.0),
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(right: 30.0, left: 30.0),
                        child: Icon(
                          Icons.language,
                          size: 23.0,
                          color: Color(0xffceab67),
                        ),
                      ),
                      Text(
                        'language',
                        style: _txtCategory,
                      ).tr(),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Divider(
              color: Colors.grey,
              height: 2.0,
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.of(context).push(PageRouteBuilder(
                  pageBuilder: (_, __, ___) => new AlertPage()));
            },
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 15.0, left: 30.0),
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(right: 30.0, left: 30.0),
                        child: Icon(
                          Icons.notification_important,
                          size: 23.0,
                          color: Color(0xffceab67),
                        ),
                      ),
                      Text(
                        'notification',
                        style: _txtCategory,
                      ).tr(),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Divider(
              color: Colors.grey,
              height: 2.0,
            ),
          ),
          InkWell(
            onTap: () {
              _logout();
            },
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 15.0, left: 30.0),
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(right: 30.0, left: 30.0),
                        child: Icon(
                          Icons.exit_to_app,
                          size: 23.0,
                          color: Color(0xffceab67),
                        ),
                      ),
                      Text(
                        'logout',
                        style: _txtCategory,
                      ).tr(),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Divider(
              color: Colors.grey,
              height: 2.0,
            ),
          ),
        ],
      ),
    );
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        backgroundColor: Color(0xff222327),
        body: Container(
          color: Color(0xff222327),
          child: Stack(
            children: <Widget>[
              /// Setting Header Banner
              Container(
                height: 200.0,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(
                            '${httpAddr.url}upload_files/${_cover_image}'),
                        fit: BoxFit.cover)),
              ),
              // _profile,
              _profile_link
            ],
          ),
        ),
      ),
    );
  }
}

class category extends StatelessWidget {
  @override
  String txt, image;
  GestureTapCallback tap;
  double padding;
  Icons icon;

  category({this.txt, this.icon, this.tap, this.padding, this.image});

  Widget build(BuildContext context) {
    return InkWell(
      onTap: tap,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 15.0, left: 30.0),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(right: padding, left: padding),
                  child: Icon(Icons.remove_red_eye),
                ),
                Text(
                  txt,
                  style: _txtCategory,
                ).tr(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
