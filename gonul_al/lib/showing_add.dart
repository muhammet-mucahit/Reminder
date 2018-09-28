import 'package:flutter/material.dart';

String yemeksepeti =
    "https://img-s1.onedio.com/id-554c61be9c1308242be1a0e0/rev-0/w-600/h-300/s-b5652fd29ff92f9f22be7c14d79fd11dd966655c.jpg";

String ciceksepeti =
    "https://kampanyabul.org/wp-content/uploads/2016/05/ciceksepeti.jpg";

String hepsiburada =
    "https://www.technopat.net/wp-content/uploads/2017/06/Hepsiburada-Logo.jpg";

String gittigidiyor =
    "https://www.stockmount.com/SayfaResimler/EnBuyuk/0/gittigidiyor-entegrasyon.jpg";

String n11 =
    "https://kurumsal.n11.com/assets/logo/logo-n11-ikisatirli-large.png";

String sahibinden =
    "https://www.kioskla.co/wp-content/uploads/2017/10/sahibinden-.jpg";

String ets =
    "http://www.vectorslogo.com/wp-content/uploads/2016/10/Ets-Tur.jpg";

class ShowAdd extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ShowAddState();
}

class ShowAddState extends State<ShowAdd> {
  @override
  Widget build(BuildContext context) {
    Widget adButton(String image) {
      return Card(
        child: RaisedButton(
          color: Theme.of(context).primaryColor,
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Image.network(
            image,
          ),
        ),
      );
    }

    return Builder(
      builder: (context) => Container(
            child: Column(
              children: [
                adButton(yemeksepeti),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                ),
                adButton(ciceksepeti),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                ),
                adButton(hepsiburada),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                ),
                adButton(gittigidiyor),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                ),
                adButton(n11),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                ),
                adButton(sahibinden),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                ),
                adButton(ets),
              ],
            ),
          ),
    );
  }
}