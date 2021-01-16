import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iSalonAgent/utilities/HttpAddress.dart';
import 'package:velocity_x/velocity_x.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:easy_localization/easy_localization.dart';

class ServicePage extends StatefulWidget {
  @override
  _ServicePage createState() => new _ServicePage();
}

class _ServicePage extends State<ServicePage> {
  TextEditingController priceController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  List<Service> list = List();
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
    print(_id);
    http.Response service =
        await http.get("${httpAddr.url}api/get-salon-service/${_id}", headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
      'APP_KEY': "8Shm171pe2oTGvJlql7nxe2Ys/tHJaiiVq6vr5wIu5EJhEEmI3gVi"
    });
    setState(() {
      print(json.decode(service.body));
      list = (json.decode(service.body) as List)
          .map((data) => new Service.fromJson(data))
          .toList();
    });
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

  void _updateService(service_id) {
    showLoadingDialog(context);
    http
        .post(
      "${httpAddr.url}api/update-salon-service",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'APP_KEY': "8Shm171pe2oTGvJlql7nxe2Ys/tHJaiiVq6vr5wIu5EJhEEmI3gVi"
      },
      body: jsonEncode(<String, String>{
        'price': priceController.text,
        'duration': timeController.text,
        'id': service_id.toString(),
      }),
    )
        .then((response) {
      Navigator.of(context, rootNavigator: true).pop(false);
      Map mapValue = json.decode(response.body);
      SnackBar snackBar = new SnackBar(
        content: new Text(mapValue['message']),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 5),
      );

      _scaffoldKey.currentState.showSnackBar(snackBar);
      _fetchServices();
    });
  }

  Future<bool> _showService(service_name, service_id) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Color(0xff222327),
        contentPadding: EdgeInsets.only(left: 25, right: 25),
        title: Center(child: Text("$service_name")),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        content: Container(
          height: 200,
          width: 300,
          child: SingleChildScrollView(
              child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Container(
                  width: context.percentWidth * 100,
                  padding: EdgeInsets.all(0.0),
                  child: TextField(
                    controller: priceController,
                    autocorrect: true,
                    decoration: InputDecoration(
                      hintStyle: TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: Color(0xff323345),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
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
                    controller: timeController,
                    autocorrect: true,
                    decoration: InputDecoration(
                      hintStyle: TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: Color(0xff323345),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      ),
                    ),
                  )),
            ],
          )),
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
                width: MediaQuery.of(context).size.width * 0.08,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.20,
                child: RaisedButton(
                  child: new Text(
                    'Update',
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Color(0xFF121A21),
                  shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30.0),
                  ),
                  onPressed: () {
                    //saveIssue();
                    _updateService(service_id);
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

  @override
  void initState() {
    super.initState();
    getProfileDetails();
  }

  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Color(0xff222327),
        appBar: AppBar(
          title: Center(
              child: Text(
            "service_list",
            style: TextStyle(
                fontFamily: 'Montserrat', fontWeight: FontWeight.bold),
          ).tr()),
        ),
        body: SingleChildScrollView(
          child: Container(
            color: Color(0xff222327),
            child: Column(
              children: list.map((e) {
                return makeCard(
                    e.duration,
                    e.price,
                    e.service_id,
                    e.service_image,
                    e.service_name_arabic,
                    e.service_name_english);
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  Widget makeCard(duration, price, service_id, service_image,
      service_name_arabic, service_name_english) {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
      height: 150,
      width: double.maxFinite,
      child: GestureDetector(
        onTap: () {
          setState(() {
            priceController.text = price;
            timeController.text = duration;
          });
          'languages'.tr() == 'en'
              ? _showService(service_name_english, service_id)
              : _showService(service_name_arabic, service_id);
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
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: NetworkImage(
                        '${httpAddr.url}upload_files/${service_image}',
                      ),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    'languages'.tr() == 'en'
                        ? Text('$service_name_english',
                            style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                                color: Color(0xffceab67)))
                        : Text('$service_name_arabic',
                            style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                                color: Color(0xffceab67))),
                    SizedBox(
                      height: 10,
                    ),
                    Text('price'.tr() + ' : $price',
                        style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                            color: Color(0xffceab67))),
                    SizedBox(
                      height: 10,
                    ),
                    Text('time'.tr() + ' : $duration',
                        style: TextStyle(
                            fontSize: 10.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey)),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Icon(
                  Icons.edit_outlined,
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

class Service {
  int service_id;
  String service_image,
      service_name_english,
      service_name_arabic,
      price,
      duration;
  Service._(
      {this.duration,
      this.price,
      this.service_id,
      this.service_image,
      this.service_name_arabic,
      this.service_name_english});
  factory Service.fromJson(Map<String, dynamic> json) {
    return Service._(
      service_id: json['service_id'],
      service_image: json['service_image'],
      service_name_english: json['service_name_english'],
      service_name_arabic: json['service_name_arabic'],
      price: json['price'],
      duration: json['duration'],
    );
  }
}
