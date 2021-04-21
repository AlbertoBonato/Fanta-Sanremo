import 'package:fanta_sanremo/models/gettone.dart';
import 'package:fanta_sanremo/models/user.dart';
import 'package:fanta_sanremo/state/app_state.dart';
import 'package:fanta_sanremo/services/database.dart';
import 'package:fanta_sanremo/state/gettone_state.dart';
import 'package:fanta_sanremo/utils/components.dart';
import 'package:fanta_sanremo/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

class GettoneScreen extends StatefulWidget {
  @override
  _GettoneScreenState createState() => _GettoneScreenState();
}

class _GettoneScreenState extends State<GettoneScreen> {
  Future<List<Gettone>> gettoniF = getGettoni();

  @override
  Widget build(BuildContext context) {
    var state = context.watch<AppState>();
    return Scaffold(
      appBar: AppBar(
        title: Text("Seleziona gettone"),
      ),
      body: SafeArea(
        child: Container(
            child: state.canChangeGettone
                ? FutureBuilder(
                    future: gettoniF,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Container();
                      }
                      if (snapshot.hasData) {
                        return GettoniList(snapshot.data);
                      }
                      return Container(
                        child: Center(child: MyLoader()),
                        color: color_b2,
                      );
                    })
                : NonSelectableGettone()),
      ),
    );
  }
}

class GettoniList extends StatelessWidget {
  List<Gettone> gettoni;

  GettoniList(this.gettoni);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (context, index) => Divider(
        color: color_b5,
      ),
      itemCount: gettoni.length,
      itemBuilder: (context, i) {
        return ListTile(
          title: Text(
            gettoni[i].name,
            style: TextStyle(
              color: color_b5,
              fontWeight: FontWeight.w700,
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${gettoni[i].points}',
                style: TextStyle(fontFamily: secondFont),
              ),
              Text(
                ' pt',
                style: TextStyle(
                  color: color_b5,
                  fontWeight: FontWeight.w700,
                ),
              )
            ],
          ),
          onTap: () async {
            var state = context.read<AppState>();
            if (state.canChangeGettone) {
              UserGettone userGettone = await setUserGettone(gettoni[i].name);
              if (userGettone.name != null &&
                  userGettone.selectionDate != null) {
                GettoneState gettoneState =
                    GettoneState.fromUserGettone(userGettone);
                gettoneState.persist();
                state.setSelectedGettone(gettoni[i].name);
              }
            } else {
              Toast.show("Ora non puoi cambiare gettone", context,
                  duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
            }
            Navigator.pop(context);
          },
        );
      },
    );
  }
}

class NonSelectableGettone extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(32, 32, 32, 0),
      child: Text(
        'Al momento non puoi cambiare gettone!',
        style: TextStyle(color: color_b5, fontSize: 18),
      ),
    );
  }
}
