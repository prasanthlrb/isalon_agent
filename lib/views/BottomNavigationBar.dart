import 'package:flutter/material.dart';
import 'package:iSalonAgent/views/Booking.dart';
// import 'package:laundry/UI/ProfilePage.dart';
import 'package:iSalonAgent/views/HomePage.dart';
// import 'package:laundry/UI/OrderPage.dart';
// import 'package:laundry/UI/PricePage.dart';
// import 'package:laundry/UI/Notification.dart';
import 'package:flutter/services.dart';
import 'package:iSalonAgent/views/ProfilePage.dart';
import 'package:iSalonAgent/views/ServicePage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';

class bottomNavigationBar extends StatefulWidget {
  @override
  _bottomNavigationBarState createState() => _bottomNavigationBarState();
}

class _bottomNavigationBarState extends State<bottomNavigationBar> {
  int currentIndex = 0;
  int valName;

  /// Set a type current number a layout class
  Widget callPage(int current) {
    if (valName == 1) {
      switch (current) {
        case 0:
          return new HomePage();
        case 1:
          return new ServicePage();
        case 2:
          return new Booking();
        case 3:
          return new ProfilePage();
          break;
        default:
          return HomePage();
      }
    } else {
      switch (current) {
        case 0:
          return new HomePage();
        case 1:
          return new Booking();
        case 2:
          return new ProfilePage();
          break;
        default:
          return HomePage();
      }
    }
  }

  orderShow() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      valName = prefs.getInt('user_type');
    });
    // print('user_type' + valName.toString());
  }

  @override
  void initState() {
    super.initState();
    orderShow();
  }

  /// Build BottomNavigationBar Widget
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    if (valName == 1) {
      return Scaffold(
        body: callPage(currentIndex),
        bottomNavigationBar: Theme(
          data: Theme.of(context).copyWith(
              canvasColor: Colors.white,
              textTheme: Theme.of(context).textTheme.copyWith(
                  caption: TextStyle(color: Colors.black26.withOpacity(0.15)))),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: currentIndex,
            fixedColor: Color(0xffe5b344),
            onTap: (value) {
              currentIndex = value;
              setState(() {});
            },
            items: [
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                  size: 23.0,
                ),
                title: Text(
                  "home",
                  style: TextStyle(fontFamily: "Berlin", letterSpacing: 0.5),
                ).tr(),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.design_services),
                title: Text(
                  "services",
                  style: TextStyle(fontFamily: "Berlin", letterSpacing: 0.5),
                ).tr(),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart),
                title: Text(
                  "bookings",
                  style: TextStyle(fontFamily: "Berlin", letterSpacing: 0.5),
                ).tr(),
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.person,
                  size: 24.0,
                ),
                title: Text(
                  "account",
                  style: TextStyle(fontFamily: "Berlin", letterSpacing: 0.5),
                ).tr(),
              ),
            ],
          ),
        ),
      );
    } else {
      return Scaffold(
        body: callPage(currentIndex),
        bottomNavigationBar: Theme(
          data: Theme.of(context).copyWith(
              canvasColor: Colors.white,
              textTheme: Theme.of(context).textTheme.copyWith(
                  caption: TextStyle(color: Colors.black26.withOpacity(0.15)))),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: currentIndex,
            fixedColor: Color(0xffe5b344),
            onTap: (value) {
              currentIndex = value;
              setState(() {});
            },
            items: [
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                  size: 23.0,
                ),
                title: Text(
                  "home",
                  style: TextStyle(fontFamily: "Berlin", letterSpacing: 0.5),
                ),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart),
                title: Text(
                  "Booking",
                  style: TextStyle(fontFamily: "Berlin", letterSpacing: 0.5),
                ),
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.person,
                  size: 24.0,
                ),
                title: Text(
                  "account",
                  style: TextStyle(fontFamily: "Berlin", letterSpacing: 0.5),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}
