import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iSalonAgent/utilities/HttpAddress.dart';
import 'package:iSalonAgent/views/BookingDetails.dart';
import 'package:velocity_x/velocity_x.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:easy_localization/easy_localization.dart';

class Booking extends StatefulWidget {
  @override
  _Booking createState() => new _Booking();
}

class _Booking extends State<Booking> {
  @override
  List<Booked> list = List();
  int _id;
  var httpAddr = HttpAddress();
  Future<void> getProfileDetails() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt('_id');
    setState(() {
      _id = id;
    });
    if (id == null || id == '') {
      Navigator.of(context).pushNamedAndRemoveUntil(
          'LoginScreen', (Route<dynamic> route) => false);
    }
    _fetchServices();
  }

  Future _fetchServices() async {
    http.Response book =
        await http.get("${httpAddr.url}api/get-salon-booking/${_id}", headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
      'APP_KEY': "8Shm171pe2oTGvJlql7nxe2Ys/tHJaiiVq6vr5wIu5EJhEEmI3gVi"
    });
    setState(() {
      // print(json.decode(book.body));
      list = (json.decode(book.body) as List)
          .map((data) => new Booked.fromJson(data))
          .toList();
    });
  }

  _onCall(numbers) async {
    final phone = "tel:+971$numbers";
    if (await canLaunch(phone)) {
      await launch(phone);
    } else {
      throw 'Could not launch $phone';
    }
  }

  @override
  void dispose() {
    // _controller.dispose();
    super.dispose();
    print("Dispose Called");
  }

  // void didUpdateWidget(Example oldWidget) {
  //   super.didUpdateWidget(oldWidget);
  // }

  _onDirection(lat, lng) async {
    final lats = lat;
    final lngs = lng;
    print('Lat : ${lat}');
    final url = 'https://www.google.com/maps/search/?api=1&query=$lats,$lngs';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  void initState() {
    super.initState();
    getProfileDetails();
  }

  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        backgroundColor: Color(0xff222327),
        appBar: AppBar(
          title: Center(
              child: Text(
            "bookings",
            style: TextStyle(
                fontFamily: 'Montserrat', fontWeight: FontWeight.bold),
          ).tr()),
          actions: <Widget>[
            FlatButton(
              textColor: Colors.black,
              onPressed: () {
                setState(() {
                  list = List();
                });
                _fetchServices();
              },
              child: Icon(Icons.autorenew),
              shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            color: Color(0xff222327),
            child: Column(
              children: list.map((e) {
                return makeCard(
                    e.appointment_date,
                    e.appointment_time,
                    e.booking_id,
                    e.booking_status,
                    e.coupon,
                    e.customer_email,
                    e.customer_name,
                    e.customer_phone,
                    e.discount,
                    e.otp,
                    e.subtotal,
                    e.total,
                    e.payment_status,
                    e.address_id);
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  Widget makeCard(
      appointment_date,
      appointment_time,
      booking_id,
      booking_status,
      coupon,
      customer_email,
      customer_name,
      customer_phone,
      discount,
      otp,
      subtotal,
      total,
      payment_status,
      address_id) {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
      height: 150,
      width: double.maxFinite,
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            PageRouteBuilder(
                pageBuilder: (_, __, ___) => new BookingDetails(
                    value: Book(
                        appointment_date: appointment_date,
                        appointment_time: appointment_time,
                        otp: otp,
                        total: total,
                        coupon: coupon,
                        discount: discount,
                        subtotal: subtotal,
                        booking_id: booking_id,
                        booking_status: booking_status,
                        customer_email: customer_email,
                        customer_name: customer_name,
                        customer_phone: customer_phone,
                        payment_status: payment_status,
                        address_id: address_id)),
                transitionDuration: Duration(milliseconds: 600),
                transitionsBuilder:
                    (_, Animation<double> animation, __, Widget child) {
                  return Opacity(
                    opacity: animation.value,
                    child: child,
                  );
                }),
          );

          // _onCall(phone);
        },
        child: Card(
          color: Color(0xff323345),
          elevation: 5,
          child: Row(
            //mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      booking_status == 0
                          ? Icons.insert_invitation
                          : Icons.check_circle_outline,
                      color: Color(0xffceab67),
                      size: 40.0,
                    ),
                    Text('${appointment_date}',
                        style: TextStyle(fontSize: 14.0, color: Colors.grey)),
                    Text('${appointment_time}',
                        style: TextStyle(fontSize: 14.0, color: Colors.grey)),
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('#$booking_id',
                        style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                            color: Color(0xffceab67))),
                    SizedBox(
                      height: 10,
                    ),
                    Text('${customer_name}',
                        style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                            color: Color(0xffceab67))),
                    SizedBox(
                      height: 10,
                    ),
                    // Text(address == null ? 'Home Services' : '$address',
                    //     style: TextStyle(
                    //         fontSize: 10.0,
                    //         fontWeight: FontWeight.bold,
                    //         color: Colors.grey)),
                  ],
                ),
              ),
              payment_status == 0
                  ? Expanded(
                      flex: 3,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/unpaid.png',
                            height: 100.0,
                          ),
                        ],
                      ),
                    )
                  : Expanded(
                      flex: 3,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/paid.png',
                            height: 100.0,
                          ),
                        ],
                      ),
                    ),
              Expanded(
                flex: 1,
                child: Icon(
                  Icons.chevron_right,
                  color: Color(0xffceab67),
                  size: 50.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Booked {
  int booking_id;
  String customer_phone;
  String appointment_date;
  String appointment_time;
  String otp;
  String total;
  String coupon;
  String discount;
  String subtotal;
  String customer_name;
  String customer_email;
  int booking_status;
  int payment_status;
  int address_id;
  Booked._(
      {this.booking_id,
      this.appointment_date,
      this.appointment_time,
      this.otp,
      this.total,
      this.coupon,
      this.discount,
      this.subtotal,
      this.booking_status,
      this.customer_email,
      this.customer_name,
      this.customer_phone,
      this.payment_status,
      this.address_id});
  factory Booked.fromJson(Map<String, dynamic> json) {
    return Booked._(
      booking_id: json['booking_id'],
      appointment_date: json['appointment_date'],
      appointment_time: json['appointment_time'],
      otp: json['otp'],
      total: json['total'],
      coupon: json['coupon'],
      discount: json['discount'],
      subtotal: json['subtotal'],
      booking_status: json['booking_status'],
      customer_email: json['customer_email'],
      customer_name: json['customer_name'],
      customer_phone: json['customer_phone'],
      payment_status: json['payment_status'],
      address_id: json['address_id'],
    );
  }
}

class Book {
  int booking_id;
  String customer_phone;
  String appointment_date;
  String appointment_time;
  String otp;
  String total;
  String coupon;
  String discount;
  String subtotal;
  String customer_name;
  String customer_email;
  int booking_status;
  int payment_status;
  int address_id;
  Book(
      {this.booking_id,
      this.appointment_date,
      this.appointment_time,
      this.otp,
      this.total,
      this.coupon,
      this.discount,
      this.subtotal,
      this.booking_status,
      this.customer_email,
      this.customer_name,
      this.customer_phone,
      this.payment_status,
      this.address_id});
}
