import 'package:fanta_sanremo/models/user.dart';
import 'package:fanta_sanremo/services/database.dart';
import 'package:fanta_sanremo/utils/components.dart';
import 'package:fanta_sanremo/utils/theme.dart';
import 'package:flutter/material.dart';

class RankScreen extends StatefulWidget {
  @override
  _RankScreenState createState() => _RankScreenState();
}

class _RankScreenState extends State<RankScreen> {
  Future<List<User>> rank;

  @override
  void initState() {
    rank = getRank();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Classifica"),
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: rank,
          builder: (context, users) {
            if (users.hasData) {
              return ListView.separated(
                  separatorBuilder: (context, index) => Divider(
                    color: color_b5,
                  ),
                  itemCount: users.data.length,
                  itemBuilder: (context, i) {
                    return ListTile(
                        title: Text(
                          (users.data)[i].name,
                          style: TextStyle(
                            color: color_b5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${(users.data)[i].points.total}',
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
                        onTap: () {});
                  });
            }
            if (users.hasError) {
              print(users.error.toString());
              return Container(child: Center(child: Text('Errore interno')));
            }
            return Container(child: Center(child: MyLoader()));
          },
        ),
      ),
    );
  }
}