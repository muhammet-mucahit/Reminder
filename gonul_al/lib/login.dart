import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  TextEditingController mailController = TextEditingController();

  String eposta = "";
  String mailKey = "e-posta";

  @override
  void initState() {
    super.initState();
    _getMailPreference();
  }

  _saveMailPreference(String mail) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(mailKey, mail);
  }

  _getMailPreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      eposta = (prefs.getString(mailKey) ?? "");
    });
  }

  Widget logo() => Hero(
        tag: 'hero',
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 60.0,
          child: Icon(Icons.people, size: 75.0),
        ),
      );

  Widget email() => TextField(
        controller: mailController,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          hintText: 'E-Posta',
          contentPadding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 10.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32.0),
          ),
        ),
      );

  Widget password() => TextField(
        obscureText: true,
        decoration: InputDecoration(
          hintText: 'Password',
          contentPadding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 10.0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
        ),
      );

  Widget loginButton() => RaisedButton(
        shape: StadiumBorder(),
        color: Theme.of(context).accentColor,
        child: Text(
          "Giris",
          style: TextStyle(
            letterSpacing: 5.0,
            fontSize: 15.0,
            color: Theme.of(context).primaryColor,
          ),
        ),
        onPressed: () {
          _saveMailPreference(mailController.text);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MyHomePage()),
          );
          // Navigator.pop(context);
        },
      );

  Widget login() {
    return Scaffold(
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          children: <Widget>[
            logo(),
            email(),
            Padding(
              padding: EdgeInsets.only(
                top: 20.0,
              ),
            ),
            loginButton(),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (eposta == "" || eposta == null)
      return login();
    else
      return MyHomePage();
  }
}
