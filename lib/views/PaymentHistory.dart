import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:iSalonAgent/utilities/HttpAddress.dart';
import 'package:easy_localization/easy_localization.dart';

class PaymentHistory extends StatefulWidget {
  int _id;
  PaymentHistory(this._id);
  @override
  _PaymentHistory createState() => _PaymentHistory(_id);
}

var _txtCustomSub = TextStyle(
  color: Colors.black38,
  fontSize: 13.5,
  fontWeight: FontWeight.w500,
  fontFamily: "Gotik",
);

class _PaymentHistory extends State<PaymentHistory> {
  List<Transcation> list = List();
  _PaymentHistory(_id);
  var httpAddr = HttpAddress();
  Future getAbout() async {
    print(widget._id);
    http.Response trans = await http.get(
        "${httpAddr.url}api/get-salon-booking-transaction/${widget._id}",
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          'APP_KEY': "8Shm171pe2oTGvJlql7nxe2Ys/tHJaiiVq6vr5wIu5EJhEEmI3gVi"
        });
    setState(() {
      list = (json.decode(trans.body) as List)
          .map((data) => new Transcation.fromJson(data))
          .toList();
    });
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
        title: Text(
          "payment_history",
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
      body: SingleChildScrollView(
        child: Container(
          color: Color(0xff222327),
          child: Column(
            children: <Widget>[
              // Padding(
              //   padding: const EdgeInsets.all(20.0),
              //   child: Divider(
              //     height: 0.5,
              //     color: Colors.black12,
              //   ),
              // ),
              Padding(
                padding: EdgeInsets.only(top: 0.0, left: 0.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 12.0, top: 20.0, right: 12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: list.map((data) {
                          return dataTransaction(
                            ordeId: data.booking_id,
                            date: '${data.date}',
                            total: " ${data.total} AED",
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class dataTransaction extends StatelessWidget {
  @override
  int ordeId;
  String date, total;

  dataTransaction({this.ordeId, this.date, this.total});

  Widget build(BuildContext context) {
    return Container(
      color: Color(0xff323345),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  width: 50.0,
                  child: Text(
                    "#${ordeId.toString()}",
                    style: _txtCustomSub.copyWith(color: Colors.white54),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 1.0),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 1.0),
                  child: Text(
                    date,
                    style: _txtCustomSub.copyWith(
                        color: Colors.white38,
                        fontSize: 11.0,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                Text(total,
                    style: _txtCustomSub.copyWith(
                      color: Colors.redAccent,
                      fontSize: 16.0,
                    )),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Divider(
              height: 0.5,
              color: Colors.black12,
            ),
          ),
        ],
      ),
    );
  }
}

class Transcation {
  int booking_id;
  String date;
  String total;
  int payment_type;
  int payment_status;
  String payment_id;
  Transcation._(
      {this.booking_id,
      this.date,
      this.total,
      this.payment_type,
      this.payment_status,
      this.payment_id});
  factory Transcation.fromJson(Map<String, dynamic> json) {
    return Transcation._(
      booking_id: json['booking_id'],
      date: json['date'],
      total: json['total'],
      payment_type: json['payment_type'],
      payment_status: json['payment_status'],
      payment_id: json['payment_id'],
    );
  }
}
