import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iSalonAgent/utilities/HttpAddress.dart';
import 'package:iSalonAgent/views/Booking.dart';
import 'package:iSalonAgent/views/chat/chat_screen.dart';
import 'package:velocity_x/velocity_x.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:easy_localization/easy_localization.dart';

var _txtCustomHead = TextStyle(
  color: Colors.black54,
  fontSize: 17.0,
  fontWeight: FontWeight.w600,
  fontFamily: "Gotik",
);
var _txtCustomSub = TextStyle(
  color: Colors.black38,
  fontSize: 13.5,
  fontWeight: FontWeight.w500,
  fontFamily: "Gotik",
);

class BookingDetails extends StatefulWidget {
  final Book value;
  BookingDetails({Key key, this.value}) : super(key: key);
  @override
  _BookingDetails createState() => _BookingDetails();
}

class _BookingDetails extends State<BookingDetails> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  TextEditingController _otp = TextEditingController();

  List<Items> list = List();
  List<BookingPackage> package = List();
  var httpAddr = HttpAddress();
  static var _txtCustom = TextStyle(
    color: Colors.white54,
    fontSize: 15.0,
    fontWeight: FontWeight.w500,
    fontFamily: "Gotik",
  );
  int payment_status;
  int booking_status;
  String city = '';
  String addr_title = '';
  String c_address = '';
  String landmark = '';
  String lat;
  String lng;
  Future<void> _fetchItem() async {
    http.Response get_service = await http.get(
        "${httpAddr.url}api/get-booking-item/${widget.value.booking_id}",
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          'APP_KEY': "8Shm171pe2oTGvJlql7nxe2Ys/tHJaiiVq6vr5wIu5EJhEEmI3gVi"
        });

    http.Response get_package = await http.get(
        "${httpAddr.url}api/get-booking-package/${widget.value.booking_id}",
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          'APP_KEY': "8Shm171pe2oTGvJlql7nxe2Ys/tHJaiiVq6vr5wIu5EJhEEmI3gVi"
        });

    if (widget.value.address_id != 0) {
      http.Response manage_address = await http.get(
          "${httpAddr.url}api/get-manage-address/${widget.value.address_id}",
          headers: {
            "Content-Type": "application/json",
            "Accept": "application/json",
            'APP_KEY': "8Shm171pe2oTGvJlql7nxe2Ys/tHJaiiVq6vr5wIu5EJhEEmI3gVi"
          });
      Map ma = json.decode(manage_address.body);

      setState(() {
        city = ma['city'];
        addr_title = ma['addr_title'];
        c_address = ma['address'];
        landmark = ma['landmark'];
        lat = ma['lat'];
        lng = ma['lng'];
      });
    }

    setState(() {
      payment_status = widget.value.payment_status;
      booking_status = widget.value.booking_status;
      list = (json.decode(get_service.body) as List)
          .map((data) => new Items.fromJson(data))
          .toList();

      package = (json.decode(get_package.body) as List)
          .map((data) => new BookingPackage.fromJson(data))
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

  _submitOtp() {
    if (_otp.text == '') {
      SnackBar snackBar = new SnackBar(
        content: new Text("Please Enter OTP"),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 5),
      );
      _key.currentState.showSnackBar(snackBar);
    } else {
      http
          .post(
        "${httpAddr.url}api/booking-otp-verified",
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'APP_KEY': "8Shm171pe2oTGvJlql7nxe2Ys/tHJaiiVq6vr5wIu5EJhEEmI3gVi"
        },
        body: jsonEncode(<String, String>{
          'otp': _otp.text,
          'id': widget.value.booking_id.toString(),
        }),
      )
          .then((response) {
        if (response.statusCode == 200) {
          setState(() {
            booking_status = 1;
          });
          SnackBar snackBar = new SnackBar(
            content: new Text("Code Apply Successfully Successfully"),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 5),
          );
          _key.currentState.showSnackBar(snackBar);

          // Navigator.of(context).pushNamedAndRemoveUntil(
          //     'HomeScreen', (Route<dynamic> route) => false);
        } else {
          SnackBar snackBar = new SnackBar(
            content: new Text("Verification Code Not Valid"),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 5),
          );
          _key.currentState.showSnackBar(snackBar);
        }
      });
    }
  }

  // String _name;
  // _getProfileData() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //     _name = prefs.getString('name');
  //     // _cover_image = prefs.getString('cover_image');
  //   });
  // }

  void initState() {
    super.initState();
    _fetchItem();
    //_getProfileData();
  }

  Future<bool> _showAlert() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Color(0xff222327),
        contentPadding: EdgeInsets.only(left: 25, right: 25),
        title: Center(child: Text("Payment Confirm")),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        content: Container(
          height: 100,
          width: 250,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Text(
                "Have a Received Payment From Customer",
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
                    'No',
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
                width: MediaQuery.of(context).size.width * 0.25,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.20,
                child: RaisedButton(
                  child: new Text(
                    'Yes',
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Color(0xFF121A21),
                  shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30.0),
                  ),
                  onPressed: () {
                    //saveIssue();
                    _paymentPaid();
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  void _mapLocation() async {
    final lats = lat;
    final lngs = lng;
    final url = 'https://www.google.com/maps/search/?api=1&query=$lats,$lngs';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _paymentPaid() {
    http
        .post(
      "${httpAddr.url}api/update-booking-status",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'APP_KEY': "8Shm171pe2oTGvJlql7nxe2Ys/tHJaiiVq6vr5wIu5EJhEEmI3gVi"
      },
      body: jsonEncode(<String, String>{
        'booking_id': widget.value.booking_id.toString(),
      }),
    )
        .then((response) {
      if (response.statusCode == 200) {
        setState(() {
          payment_status = 1;
        });
        SnackBar snackBar = new SnackBar(
          content: new Text("Paid Successfully"),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 5),
        );
        _key.currentState.showSnackBar(snackBar);
      } else {
        SnackBar snackBar = new SnackBar(
          content: new Text("Booking ID Not Found"),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 5),
        );
        _key.currentState.showSnackBar(snackBar);
      }
    });
  }

  Future<bool> _onBackPressed() {
    Navigator.of(context).pushNamedAndRemoveUntil(
        'BookingScreen', (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        key: _key,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil(
                'BookingScreen', (Route<dynamic> route) => false),
          ),
          title: Center(
              child: Text(
            "bookings",
            style: TextStyle(
                fontFamily: 'Montserrat', fontWeight: FontWeight.bold),
          ).tr()),
        ),
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: Container(
                    color: Color(0xff222327),
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(
                              top: 0.0, left: 0.0, right: 0.0, bottom: 0.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4.0)),
                              gradient: LinearGradient(
                                  colors: <Color>[
                                    new Color(0x0000000),
                                    new Color(0xFF000000),
                                  ],
                                  stops: [
                                    0.0,
                                    1.0
                                  ],
                                  begin: FractionalOffset(0.0, 0.0),
                                  end: FractionalOffset(0.0, 1.0)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(height: 10),
                                SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text('Customer Details',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20,
                                                color: Colors.white))
                                        .tr(),
                                  ],
                                ),
                                SizedBox(height: 20),
                                Card(
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Expanded(
                                            flex: 9,
                                            child: ListTile(
                                              leading: Icon(
                                                  Icons.supervised_user_circle),
                                              title: Text(
                                                '${widget.value.customer_name}',
                                                style: TextStyle(
                                                    color: Colors.grey),
                                              ),
                                              subtitle: Text(
                                                  '${widget.value.customer_email}'),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 3,
                                            child: Row(
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    _onCall(widget
                                                        .value.customer_phone);
                                                  },
                                                  child: Icon(
                                                    Icons.call,
                                                    color: Color(0xffceab67),
                                                    size: 40.0,
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    Navigator.of(context).push(
                                                      PageRouteBuilder(
                                                          pageBuilder: (_, __, ___) => new ChatScreen(
                                                              value: SalonChat(
                                                                  booking_id: widget
                                                                      .value
                                                                      .booking_id,
                                                                  salon_name: widget
                                                                      .value
                                                                      .customer_name
                                                                      .toString())),
                                                          transitionDuration:
                                                              Duration(
                                                                  milliseconds:
                                                                      600),
                                                          transitionsBuilder: (_,
                                                              Animation<double>
                                                                  animation,
                                                              __,
                                                              Widget child) {
                                                            return Opacity(
                                                              opacity: animation
                                                                  .value,
                                                              child: child,
                                                            );
                                                          }),
                                                    );
                                                  },
                                                  child: Icon(
                                                    Icons.chat,
                                                    color: Color(0xffceab67),
                                                    size: 40.0,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                      Divider(color: Colors.grey),
                                      widget.value.address_id != 0
                                          ? Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                Expanded(
                                                  flex: 5,
                                                  child: ListTile(
                                                    leading: Icon(Icons
                                                        .location_city_outlined),
                                                    title: Text(
                                                      '${city}',
                                                      style: TextStyle(
                                                          color: Colors.grey),
                                                    ),
                                                    subtitle:
                                                        Text('${landmark}'),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 5,
                                                  child: Column(
                                                    children: [
                                                      Text('${addr_title}',
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              color:
                                                                  Colors.grey)),
                                                      Text('${c_address}',
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              color:
                                                                  Colors.grey)),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 2,
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      _mapLocation();
                                                    },
                                                    child: Icon(
                                                      Icons.map_rounded,
                                                      color: Color(0xffceab67),
                                                      size: 40.0,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                          : SizedBox(height: 0.0),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text('booking_details',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20,
                                                color: Colors.white))
                                        .tr(),
                                  ],
                                ),
                                SizedBox(height: 20),
                                Card(
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Expanded(
                                            flex: 7,
                                            child: ListTile(
                                              leading: Icon(Icons.timelapse),
                                              title: Text(
                                                '${widget.value.appointment_date}',
                                                style: TextStyle(
                                                    color: Colors.grey),
                                              ),
                                              subtitle: Text(
                                                  '${widget.value.appointment_time}'),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 6,
                                            child: Text(
                                                'Booking ID: #${widget.value.booking_id}',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.grey)),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 20),
                                booking_status == 0
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text('verification_code',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 20,
                                                        color: Colors.white))
                                                .tr(),
                                          ),
                                        ],
                                      )
                                    : SizedBox(height: 10),
                                booking_status == 0
                                    ? Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: context.percentWidth * 100,
                                            padding: EdgeInsets.all(0.0),
                                            child: TextField(
                                              obscureText: true,
                                              controller: _otp,
                                              autocorrect: true,
                                              decoration: InputDecoration(
                                                hintText: 'Enter Customer OTP',
                                                prefixIcon: Icon(
                                                  Icons.remove_red_eye,
                                                  color: Colors.grey,
                                                ),
                                                hintStyle: TextStyle(
                                                    color: Colors.grey),
                                                filled: true,
                                                fillColor: Color(0xff323345),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              30.0)),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              30.0)),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 20),
                                          GestureDetector(
                                            onTap: () {
                                              _submitOtp();
                                              // _loginNow(context);
                                            },
                                            child: Container(
                                              height: 50,
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 10),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                                gradient: LinearGradient(
                                                  begin: Alignment.centerLeft,
                                                  end: Alignment.centerRight,
                                                  colors: [
                                                    Color(0xfffbb448),
                                                    Color(0xffceab67)
                                                  ],
                                                ),
                                              ),
                                              child: Center(
                                                child: Text("Submit",
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xff232121),
                                                        fontWeight:
                                                            FontWeight.bold)),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    : SizedBox(
                                        height: 0,
                                      ),
                                SizedBox(height: 20),
                                package.length > 0
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text('booking_packages',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 20,
                                                        color: Colors.white))
                                                .tr(),
                                          ),
                                        ],
                                      )
                                    : SizedBox(height: 0),
                                SizedBox(height: 10),
                                confirmPackage(),
                                list.length > 0
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text('booking_services',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 20,
                                                        color: Colors.white))
                                                .tr(),
                                          ),
                                        ],
                                      )
                                    : SizedBox(height: 0),
                                SizedBox(height: 10),
                                bodyData(),
                                Divider(color: Colors.white54),
                                Padding(
                                  padding: const EdgeInsets.only(right: 10.0),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                Text("sub_total",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            fontSize: 16.0,
                                                            color:
                                                                Colors.white54,
                                                            fontFamily:
                                                                "Gotik"))
                                                    .tr(),
                                                Text(
                                                    "AED ${widget.value.subtotal}",
                                                    style: TextStyle(
                                                        color: Colors.white54))
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                Text("discount",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            fontSize: 16.0,
                                                            color: Color(
                                                                0xff57d7ca),
                                                            fontFamily:
                                                                "Gotik"))
                                                    .tr(),
                                                Text(
                                                    "AED ${widget.value.discount}",
                                                    style: TextStyle(
                                                        color: Colors.white54))
                                              ],
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 150.0),
                                              child: Text(
                                                  widget.value.discount != '0.0'
                                                      ? '(coupon Applied)'
                                                      : '',
                                                  style: TextStyle(
                                                    color: Color(0xff57d7ca),
                                                  )),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 40.0),
                                                  child: Text(
                                                      '____________________',
                                                      style: TextStyle(
                                                          color:
                                                              Colors.white54)),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                Text("total",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            fontSize: 22.0,
                                                            color:
                                                                Colors.white54,
                                                            fontFamily:
                                                                "Gotik"))
                                                    .tr(),
                                                Text(
                                                    "AED ${widget.value.total}",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        fontSize: 22.0,
                                                        color: Colors.white54,
                                                        fontFamily: "Gotik"))
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 40.0,
                                                          bottom: 10.0),
                                                  child: Text(
                                                    '____________________',
                                                    style: TextStyle(
                                                        color: Colors.white54),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                payment_status == 1
                                    ? Row(
                                        children: [
                                          Expanded(
                                            flex: 3,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Image.asset(
                                                  'assets/images/paid.png',
                                                  height: 100.0,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      )
                                    : Row(
                                        children: [
                                          Expanded(
                                            flex: 3,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    _showAlert();
                                                    // _loginNow(context);
                                                  },
                                                  child: Container(
                                                    height: 50,
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 10),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50),
                                                      gradient: LinearGradient(
                                                          begin: Alignment
                                                              .centerLeft,
                                                          end: Alignment
                                                              .centerRight,
                                                          colors: [
                                                            Color(0xfffbb448),
                                                            Color(0xffceab67)
                                                          ]),
                                                    ),
                                                    child: Center(
                                                      child: Text("Pay Now",
                                                          style: TextStyle(
                                                              color: Color(
                                                                  0xff232121),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            flex: 3,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Image.asset(
                                                  'assets/images/unpaid.png',
                                                  height: 100.0,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                Divider(color: Colors.white54),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget confirmPackage() {
    return Column(
      children: package.map((e) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {
              // _getPackDetails(e.package_name, e.price, e.package_id);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    image: DecorationImage(
                      image: NetworkImage(
                        '${httpAddr.url}upload_files/${e.package_image}',
                      ),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                Text(
                  "${e.package_name}",
                  style: TextStyle(color: Colors.white, fontSize: 18.0),
                ),
                Text(
                  "AED ${e.package_price}",
                  style: TextStyle(color: Colors.grey, fontSize: 14.0),
                )
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget bodyData() {
    if (list.length > 0) {
      return DataTable(
          dataRowHeight: 100,
          columnSpacing: 10.0,
          columns: <DataColumn>[
            DataColumn(
              label: Container(
                  width: context.percentWidth * 55,
                  child: Text("service_name",
                          style: TextStyle(color: Colors.white, fontSize: 18.0))
                      .tr()),
              numeric: false,
              onSort: (i, b) {},
            ),
            DataColumn(
              label: Container(
                  width: context.percentWidth * 15,
                  child: Text("price",
                          style: TextStyle(color: Colors.white, fontSize: 18.0))
                      .tr()),
              numeric: false,
              onSort: (i, b) {},
            ),
          ],
          rows: list
              .map((data) => DataRow(
                    cells: [
                      DataCell(
                          Container(
                            height: 70.0,
                            child: Row(
                              children: [
                                // CircleAvatar(
                                //     radius: 50.0,
                                //     backgroundImage:
                                //
                                Image.network(
                                  '${httpAddr.url}upload_files/${data.image}',
                                  width: 70,
                                  height: 70,
                                  fit: BoxFit.contain,
                                ),

                                // ClipOval(
                                //   child: Image.asset(
                                //     "assets/images/salon.jpg",
                                //     height: 100,
                                //     width: 75,
                                //     fit: BoxFit.cover,
                                //   ),
                                // ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 15.0),
                                  child: Text(
                                    'languages'.tr() == 'en'
                                        ? data.en_name
                                        : data.ar_name,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          onTap: () {}),
                      DataCell(
                          Text(data.price.toString(),
                              style: TextStyle(color: Colors.white)),
                          onTap: () {}),
                    ],
                  ))
              .toList());
    } else {
      return Padding(
        padding: new EdgeInsets.all(25.0),
      );
    }
  }
}

class Items {
  String en_name, ar_name, image, price;
  Items._({this.ar_name, this.en_name, this.image, this.price});
  factory Items.fromJson(Map<String, dynamic> json) {
    return Items._(
      en_name: json['service_name_english'],
      ar_name: json['service_name_arabic'],
      image: json['service_image'],
      price: json['price'],
    );
  }
}

class SalonChat {
  int booking_id;
  String salon_name;
  SalonChat({this.booking_id, this.salon_name});
}

class BookingPackage {
  String package_name, package_price, package_image;
  BookingPackage._({this.package_name, this.package_price, this.package_image});
  factory BookingPackage.fromJson(Map<String, dynamic> json) {
    return BookingPackage._(
      package_name: json['package_name'],
      package_price: json['package_price'],
      package_image: json['package_image'],
    );
  }
}
