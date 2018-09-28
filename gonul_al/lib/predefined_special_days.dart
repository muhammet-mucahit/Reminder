import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'add_special.dart';
import 'special_days.dart';
import 'showing_add.dart';

class PredefinedSpecialDays extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => PredefinedSpecialDaysState();
}

class PredefinedSpecialDaysState extends State<PredefinedSpecialDays> {
  Widget buildListItem(BuildContext context, DocumentSnapshot document) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).splashColor),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: ListTile(
        key: ValueKey(document.documentID),
        leading: CircleAvatar(
          backgroundColor: SpecialDaysState().isTodaySpecial(document)
              ? Theme.of(context).accentColor
              : Theme.of(context).primaryColor,
          child: Text(
            document['name'][0].toString().toUpperCase(),
            style: TextStyle(
              color: SpecialDaysState().isTodaySpecial(document)
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).selectedRowColor,
            ),
          ),
        ),
        title: Text(
          document['name'],
          style: TextStyle(fontSize: 20.0),
        ),
        subtitle: Text(document['date'].split(" ")[0]),
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

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Firestore.instance
            .collection('predefined_special_days')
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
