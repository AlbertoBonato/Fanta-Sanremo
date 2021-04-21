import 'package:fanta_sanremo/models/competitor.dart';
import 'package:fanta_sanremo/services/database.dart';
import 'package:fanta_sanremo/utils/theme.dart';
import 'package:fanta_sanremo/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class BetScreen extends StatefulWidget {
  @override
  _BetScreenState createState() => _BetScreenState();
}

class _BetScreenState extends State<BetScreen> {
  String myBet;

  @override
  void initState() {
    super.initState();
    getMyBet().then((value) => setState(() {
          myBet = value;
        }));
  }

  void saveBet(String competitorName) async {
    if (DateTime.now().isBefore(lastBetDay)) {
      bool saved = await addBet(competitorName);
      if (saved) {
        setState(() {
          myBet = competitorName;
        });
      }
    } else {
      Toast.show("Votazioni chiuse!", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Televoto"),
      ),
      body: SafeArea(
        child: ListView.separated(
            separatorBuilder: (context, index) => Divider(
                  color: color_b5,
                ),
            itemCount: competitors.length,
            itemBuilder: (context, i) {
              String competitorName = competitors[i].name;
              String song = competitors[i].song;
              String imageFile = competitors[i].imageFile;
              return ListTile(
                leading: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image:
                              AssetImage('assets/images/competitors/$imageFile')),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                            color: grey.withOpacity(0.2),
                            offset: Offset(1.1, 1.1),
                            blurRadius: 10),
                        BoxShadow(
                            color: grey.withOpacity(0.2),
                            offset: Offset(-1.1, -1.1),
                            blurRadius: 10),
                      ]),
                ),
                title: Text(
                  competitorName,
                  style: TextStyle(
                    color: (myBet != null && competitorName == myBet)
                        ? color_b1
                        : color_b5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                subtitle: Text(
                  song,
                  style: TextStyle(
                      color: (myBet != null && competitorName == myBet)
                          ? color_b1
                          : color_b5,
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                ),
                onTap: () => saveBet(competitorName),
                selected: (myBet != null && competitorName == myBet),
                selectedTileColor: color_b4,
              );
            }),
      ),
    );
  }
}
