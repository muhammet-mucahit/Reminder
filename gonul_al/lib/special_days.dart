import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'add_special.dart';
import 'login.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:async';
import 'showing_add.dart';

class SpecialDays extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SpecialDaysState();
}

class SpecialDaysState extends State<SpecialDays> {
  var nameController = TextEditingController();
  var dateController = TextEditingController();

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState() {
    _getMailPreference();
    var initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = IOSInitializationSettings();
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        selectNotification: onSelectNotification);
    super.initState();
  }

  // Future _scheduleNotification(DocumentSnapshot document) async {
  //   var scheduledNotificationDateTime = DateTime(
  //     2018,
  //     DateTime.september,
  //     27,
  //     20,
  //     13,
  //     20,
  //   );
  //   var androidPlatformChannelSpecifics = AndroidNotificationDetails(
  //       'your channel id', 'your channel name', 'your channel description',
  //       largeIcon: '@mipmap/ic_launcher',
  //       importance: Importance.Max,
  //       priority: Priority.High);
  //   var iOSPlatformChannelSpecifics = IOSNotificationDetails();
  //   var platformChannelSpecifics = NotificationDetails(
  //       androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
  //   await flutterLocalNotificationsPlugin.schedule(
  //       0,
  //       'Bugun Ozel Bir Gun!',
  //       document['name'],
  //       scheduledNotificationDateTime,
  //       platformChannelSpecifics);
  // }

  Future onSelectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }

    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Icon(Icons.ac_unit)),
    );
  }

  isTodaySpecial(DocumentSnapshot document) {
    var now = DateTime.now();
    var date = DateTime.parse(document['date']);
    if (now.day == date.day && now.month == date.month) {
      return true;
    }
    return false;
  }

  void _deleteSpecialDay(DocumentSnapshot document) {
    Firestore.instance.runTransaction((transaction) async {
      await transaction.delete(document.reference);
    });
  }

  Widget buildListItem(BuildContext context, DocumentSnapshot document) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).splashColor),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: ListTile(
        key: ValueKey(document.documentID),
        leading: CircleAvatar(
          backgroundColor: isTodaySpecial(document)
              ? Theme.of(context).accentColor
              : Theme.of(context).primaryColor,
          child: Text(
            document['name'][0].toString().toUpperCase(),
            style: TextStyle(
              color: isTodaySpecial(document)
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).selectedRowColor,
            ),
          ),
        ),
        title: Text(
          document['name'],
          style: TextStyle(fontSize: 20.0),
        ),
        subtitle: Text(document['date']),
        trailing: IconButton(
          icon: Icon(Icons.delete),
          onPressed: () {
            setState(() {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Emin misiniz?"),
                    content: Text(
                      "Silinen ozel gun tekrar erisilemez!",
                      style: TextStyle(
                        fontSize: 15.0,
                      ),
                    ),
                    actions: <Widget>[
                      FlatButton(
                        child: Text("Sil"),
                        onPressed: () {
                          _deleteSpecialDay(document);
                          Navigator.of(context).pop();
                          setState(() {});
                        },
                      ),
                      FlatButton(
                        child: Text("Kapat"),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            });
          },
        ),
        onLongPress: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return SimpleDialog(
                  children: <Widget>[
                    AddSpecialRouteState().builder(document, "GUNCELLE"),
                  ],
                );
              });
        },
        onTap: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return SimpleDialog(
                  children: <Widget>[
                    ShowAdd(),
                  ],
                );
              });
        },
      ),
    );
  }

  String eposta = "";

  _getMailPreference() async {
    final prefs = await SharedPreferences.getInstance();
    eposta = (prefs.getString(LoginPageState().mailKey) ?? "");
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Firestore.instance
            .collection('special_days')
            .where('id', isEqualTo: eposta)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: const Text('Loading...'));
          return ListView.builder(
              itemCount: snapshot.data.documents.length * 2,
              padding: const EdgeInsets.all(10.0),
              itemBuilder: (BuildContext context, int index) {
                if (index % 2 == 1)
                  return Padding(
                    padding: EdgeInsets.only(bottom: 10.0),
                  );
                else {
                  int pos = (index ~/ 2);
                  return buildListItem(context, snapshot.data.documents[pos]);
                }
              });
        });
  }
}
