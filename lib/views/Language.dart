import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class LanguagePage extends StatefulWidget {
  @override
  _LanguageAppsState createState() => _LanguageAppsState();
}

enum SingingCharacter { english, arabic }

class _LanguageAppsState extends State<LanguagePage> {
  @override
  SingingCharacter _character = SingingCharacter.english;
  void initState() {
    super.initState();
    if (('languages').tr() == 'en') {
      setState(() {
        _character = SingingCharacter.english;
      });
    } else {
      setState(() {
        _character = SingingCharacter.arabic;
      });
    }
  }

  @override
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

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff222327),
      appBar: AppBar(
        title: Text(
          "Choose Language",
          style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 15.0,
              color: Colors.black54,
              fontFamily: "Gotik"),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: Color(0xFF6991C7)),
        elevation: 0.0,
      ),
      body: Column(
        children: <Widget>[
          ListTile(
            title: const Text('English'),
            leading: Radio(
              value: SingingCharacter.english,
              groupValue: _character,
              onChanged: (SingingCharacter value) {
                setState(() {
                  _character = value;
                  context.locale = Locale('en', 'UK');
                });
              },
            ),
          ),
          ListTile(
            title: const Text('Arabic'),
            leading: Radio(
              value: SingingCharacter.arabic,
              groupValue: _character,
              onChanged: (SingingCharacter value) {
                setState(() {
                  _character = value;
                  context.locale = Locale('ar', 'AE');
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
