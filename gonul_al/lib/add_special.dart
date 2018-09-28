import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';

List<int> days = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 30];

class AddSpecialRoute extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AddSpecialRouteState();
}

class AddSpecialRouteState extends State<AddSpecialRoute> {
  var nameController = TextEditingController();
  var dateController = TextEditingController();

  bool _isValidDate(String date) {
    try {
      List<String> items = [];
      items = date.split("-");
      int year = int.parse(items[0]);
      int month = int.parse(items[1]);
      if (items.length != 3 ||
          items[0].length != 4 ||
          items[1].length != 2 ||
          month > 12 ||
          month < 1) return false;

      if (year % 4 == 0) {
        days[1] = 29;
        if (year % 100 == 0 && year % 400 != 0) days[1] = 28;
      }

      int day = int.parse(items[2]);
      if (day < 1 || day > days[month - 1]) return false;

      days[1] = 28;
    } catch (e) {
      return false;
    }

    return true;
  }

  // Control TextField's to avoid wrong values
  bool areCorrectTextFields(BuildContext context) {
    if (nameController.text == "" ||
        nameController.text == null ||
        dateController.text == "" ||
        dateController.text == null) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text("Lutfen tum alanlari doldurunuz!"),
        ),
      );
      return false;
    }
    if (!_isValidDate(dateController.text)) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text("Lutfen gecerli bir tarih giriniz! (YIL-GUN-AY)"),
        ),
      );
      return false;
    }
    return true;
  }

  String eposta = "";

  _getMailPreference() async {
    final prefs = await SharedPreferences.getInstance();
    eposta = (prefs.getString(LoginPageState().mailKey) ?? "");
  }

  void _addSpecialDay() {
    _getMailPreference();
    Firestore.instance.runTransaction(
      (Transaction transaction) async {
        CollectionReference reference =
            Firestore.instance.collection('special_days');

        await reference.add({
          'id': eposta,
          'name': nameController.text,
          'date': dateController.text
        });
      },
    );
  }

  void _updateSpecialDay(DocumentSnapshot document) {
    _getMailPreference();
    Firestore.instance.runTransaction((transaction) async {
      await transaction.update(document.reference,
          {"name": nameController.text, "date": dateController.text});
    });
  }

  Widget builder(document, buttonText) {
    if (document != null) {
      nameController.text = document['name'];
      dateController.text = document['date'];
    }

    return Builder(
      builder: (context) => Container(
            padding: EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: nameController,
                  style: Theme.of(context).textTheme.display1,
                  decoration: InputDecoration(
                    labelText: "Isim",
                    border: OutlineInputBorder(),
                    hintText: "Mucahit Dogum Gunu",
                    hintStyle: TextStyle(fontSize: 20.0),
                  ),
                  maxLength: 30,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                ),
                TextField(
                  controller: dateController,
                  style: Theme.of(context).textTheme.display1,
                  decoration: InputDecoration(
                    labelText: "Tarih",
                    border: OutlineInputBorder(),
                    hintText: "1996-07-20",
                    hintStyle: TextStyle(fontSize: 20.0),
                  ),
                  keyboardType: TextInputType.datetime,
                  maxLength: 10,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                ),
                RaisedButton(
                  color: Theme.of(context).accentColor,
                  child: Text(
                    buttonText,
                    style: TextStyle(
                        letterSpacing: 7.5,
                        fontSize: 17.5,
                        color: Theme.of(context).primaryColor),
                  ),
                  onPressed: () {
                    if (!areCorrectTextFields(context)) return;
                    if (buttonText == "EKLE")
                      _addSpecialDay();
                    else
                      _updateSpecialDay(document);
                    Navigator.of(context).pop();
                    setState(() {});
                  },
                ),
              ],
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: builder(null, "EKLE"),
    );
  }
}
