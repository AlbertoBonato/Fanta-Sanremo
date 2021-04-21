import 'package:fanta_sanremo/models/question.dart';
import 'package:fanta_sanremo/state/app_state.dart';
import 'package:fanta_sanremo/models/user.dart';
import 'package:fanta_sanremo/screens/home/menu_data.dart';
import 'package:fanta_sanremo/screens/rules_screen.dart';
import 'package:fanta_sanremo/screens/user_screen.dart';
import 'package:fanta_sanremo/services/database.dart';
import 'package:fanta_sanremo/state/gettone_state.dart';
import 'package:fanta_sanremo/utils/components.dart';
import 'package:fanta_sanremo/utils/theme.dart';
import 'package:fanta_sanremo/utils/utils.dart';
import 'package:flutter/material.dart';

import 'dart:math' as math;

import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;

  final List<Tuple2<Widget, String>> _screens = <Tuple2<Widget, String>>[
    Tuple2(HomeScreen(), 'Fanta Sanremo'),
    Tuple2(UserScreen(), 'Profilo Utente'),
    Tuple2(RulesScreen(), 'Regole Gioco')
  ];

  void changeTab(int index) {
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AppBar(
        title: Text(
          _screens[_currentIndex].item2,
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: color_b5,
          ),
        ),
        backgroundColor: color_b1.withOpacity(0.8),
        shadowColor: grey.withOpacity(0.2),
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(child: _screens[_currentIndex].item1),
      bottomNavigationBar: BottomNavigationBar(
        onTap: changeTab,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profilo',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notes),
            label: 'Regole',
          ),
        ],
        backgroundColor: color_b1.withOpacity(0.8),
        unselectedItemColor: color_b3,
        selectedItemColor: color_b5,
        selectedFontSize: 13,
        unselectedFontSize: 12,
        iconSize: 27,
        elevation: 0,
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<MenuData> menuData = MenuData.tabIconsList;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => refreshState());
  }

  Future<void> refreshState() async {
    List<User> rank = await getRank();
    var state = context.read<AppState>();
    state.updateRankPositionPoints(rank);
    List<Question> questions = await getQuestions();
    state.addNewQuestions(questions);
    state.updateQuestionsVisibility(questions);
    return;
  }

  Future<void> reloadGettone() async {
    var state = context.read<AppState>();
    state.refreshGettone(await readGettoneState());
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color_b1,
        image: DecorationImage(
            image: AssetImage('assets/images/ariston2.jpg'),
            fit: BoxFit.fill,
            alignment: Alignment.centerLeft,
            scale: 0.4),
      ),
      child: Center(
        child: RefreshIndicator(
          onRefresh: reloadGettone,
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 22),
            child: Column(
              children: [
                // Main box
                Container(
                  decoration: BoxDecoration(
                      color: color_b1.withOpacity(0.8),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8.0),
                          bottomLeft: Radius.circular(8.0),
                          bottomRight: Radius.circular(8.0),
                          topRight: Radius.circular(68.0)),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                            color: grey.withOpacity(0.2),
                            offset: Offset(1.1, 1.1),
                            blurRadius: 10.0),
                      ],
                      gradient: LinearGradient(
                        colors: <Color>[color_b1_lighter, color_b1],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(10, 10, 34, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Gara',
                          style: TextStyle(
                              fontSize: 27,
                              color: color_b5,
                              fontWeight: FontWeight.w900),
                        ),
                        Stack(
                          children: [
                            Consumer<AppState>(builder: (context, state, child) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Punti',
                                    style: TextStyle(fontSize: 18, color: color_b5),
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Icon(
                                        Icons.stars,
                                        color: color_b5,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        state.points.isNotEmpty ? state.points : '',
                                        style: TextStyle(
                                            fontFamily: secondFont,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600,
                                            color: color_b5),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        state.points.isNotEmpty ? 'pt' : '',
                                        style:
                                            TextStyle(fontSize: 17, color: color_b5),
                                      )
                                    ],
                                  ),
                                  Text(
                                    'Posizione',
                                    style: TextStyle(fontSize: 18, color: color_b5),
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Icon(
                                        Icons.insights,
                                        color: color_b5,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        state.position,
                                        style: TextStyle(
                                            fontFamily: secondFont,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600,
                                            color: color_b5),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        '/ ${state.rank.length}',
                                        style:
                                            TextStyle(fontSize: 17, color: color_b5),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    'Gettone selezionato',
                                    style: TextStyle(fontSize: 18, color: color_b5),
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Icon(
                                        Icons.help,
                                        color: color_b5,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text('${state.selectedGettoneName}',
                                          overflow: TextOverflow.fade,
                                          softWrap: false,
                                          style: TextStyle(
                                              fontFamily: secondFont,
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600,
                                              color: color_b5)),
                                    ],
                                  ),
                                ],
                              );
                            }),
                            Positioned(right: 0, child: CounterSerate()),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Container(height: 50,),
                Container(
                  height: 230,
                  width: double.infinity,
                  child: ListView.builder(
                    itemCount: menuData.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, int index) {
                      return MenuView(
                        menuData: menuData[index],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CounterSerate extends StatefulWidget {
  @override
  _CounterSerateState createState() => _CounterSerateState();
}

class _CounterSerateState extends State<CounterSerate>
    with TickerProviderStateMixin {

  int daysToStart = firstDay.difference(DateTime.now()).inDays + 1;
  int daysToEnd = lastDay.difference(DateTime.now()).inDays + 1;
  String daysLabel;
  int daysNumber;
  int mAngle;

  AnimationController controller;

  @override
  void initState() {
    this.controller = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);
    DateTime now = DateTime.now();
    int daysToStartInDays = firstDay.difference(now).inDays;
    int daysToEndInDays = lastDay.difference(now).inDays;
    if (daysToStartInDays == 0 ) {
      int daysToStartInMinutes = firstDay.difference(now).inMinutes;
      if (daysToStartInMinutes >= 0) {
        daysToStart = 1;
      } else if (daysToStartInMinutes < 0) {
        daysToStart = 0;
      }
    }
    if (daysToEndInDays == 0 ) {
      int daysToEndInMinutes = lastDay.difference(now).inMinutes;
      if (daysToEndInMinutes >= 0) {
        daysToEnd = 1;
      } else if (daysToEndInMinutes < 0) {
        daysToEnd = 0;
      }
    }
    if (daysToStart > 0) {
      daysLabel = (daysToStart == 1) ? 'Giorno' : 'Giorni';
      daysNumber = daysToStart;
    } else if (daysToEnd > 0) {
      daysLabel = (daysToEnd == 1) ? 'Serata' : 'Serate';
      daysNumber = daysToEnd;
    } else {
      daysLabel = 'Serate';
      daysNumber = 0;
    }
    mAngle = (daysToEnd > 0 ) ? 36 * daysToEnd : 0;
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var animation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: controller,
        curve: Interval((1 / 9) * 1, 1.0, curve: Curves.fastOutSlowIn)));
    this.controller.forward();
    return AnimatedBuilder(
        animation: controller,
        builder: (BuildContext context, Widget child) {
          return FadeTransition(
            opacity: animation,
            child: Stack(
              overflow: Overflow.visible,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(100.0),
                      ),
                      border: new Border.all(
                          width: 4, color: Color(0xFF00B6F0).withOpacity(0.2)),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          '- $daysNumber',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: secondFont,
                            fontWeight: FontWeight.normal,
                            fontSize: 24,
                            letterSpacing: 0.0,
                            color: color_b5,
                          ),
                        ),
                        Text(
                          daysLabel,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: secondFont,
                            fontWeight: FontWeight.w400,
                            fontSize: 15,
                            letterSpacing: 0.0,
                            color: color_b5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: CustomPaint(
                    painter: CurvePainter(
                        colors: [
                          color_b3,
                          color_b3,
                          color_b5,
                        ],
                        angle:
                            mAngle + (360 - mAngle) * (1.0 - animation.value)),
                    child: SizedBox(
                      width: 108,
                      height: 108,
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }
}

class MenuView extends StatelessWidget {
  const MenuView({Key key, this.menuData}) : super(key: key);

  final MenuData menuData;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 130,
      child: Stack(
        children: <Widget>[
          InkWell(
            onTap: () => Navigator.push(context,
                MyPageTransition(child: menuData.destination ?? Scaffold())),
            child: Padding(
              padding:
                  const EdgeInsets.only(top: 32, left: 8, right: 8, bottom: 32),
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: HexColor(menuData.endColor).withOpacity(0.6),
                        offset: const Offset(1.1, 4.0),
                        blurRadius: 5.0),
                  ],
                  gradient: LinearGradient(
                      colors: <HexColor>[
                        HexColor(menuData.startColor),
                        HexColor(menuData.endColor),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      stops: [0.1, 1]),
                  borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(8.0),
                    bottomLeft: Radius.circular(8.0),
                    topLeft: Radius.circular(8.0),
                    topRight: Radius.circular(54.0),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 54, left: 16, right: 14, bottom: 8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        menuData.titleTxt,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 19,
                          letterSpacing: 0.2,
                          color: color_b5,
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8, bottom: 8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                menuData.meals.join('\n'),
                                style: TextStyle(
                                  // fontFamily: secondFont,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 11,
                                  letterSpacing: 0.2,
                                  color: color_b5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            child: Container(
              width: 84,
              height: 84,
              decoration: BoxDecoration(
                color: Color(0xFFFAFAFA).withOpacity(0.2),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            top: 10,
            left: 12,
            child: SizedBox(
              width: 60,
              height: 60,
              child: Image.asset(menuData.imagePath),
            ),
          )
        ],
      ),
    );
  }
}

class CurvePainter extends CustomPainter {
  final double angle;
  final List<Color> colors;

  CurvePainter({this.colors, this.angle = 30});

  @override
  void paint(Canvas canvas, Size size) {
    List<Color> colorsList = List<Color>();
    if (colors != null) {
      colorsList = colors;
    } else {
      colorsList.addAll([Colors.white, Colors.white]);
    }

    final shdowPaint = new Paint()
      ..color = Colors.black.withOpacity(0.4)
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10;
    final shdowPaintCenter = new Offset(size.width / 2, size.height / 2);
    final shdowPaintRadius =
        math.min(size.width / 2, size.height / 2) - (14 / 2);
    canvas.drawArc(
        new Rect.fromCircle(center: shdowPaintCenter, radius: shdowPaintRadius),
        degreeToRadians(278),
        degreeToRadians(360 - (365 - angle)),
        false,
        shdowPaint);

    shdowPaint.color = Colors.grey.withOpacity(0.3);
    shdowPaint.strokeWidth = 12;
    canvas.drawArc(
        new Rect.fromCircle(center: shdowPaintCenter, radius: shdowPaintRadius),
        degreeToRadians(278),
        degreeToRadians(360 - (365 - angle)),
        false,
        shdowPaint);

    shdowPaint.color = Colors.grey.withOpacity(0.2);
    shdowPaint.strokeWidth = 16;
    canvas.drawArc(
        new Rect.fromCircle(center: shdowPaintCenter, radius: shdowPaintRadius),
        degreeToRadians(278),
        degreeToRadians(360 - (365 - angle)),
        false,
        shdowPaint);

    shdowPaint.color = Colors.grey.withOpacity(0.1);
    shdowPaint.strokeWidth = 18;
    canvas.drawArc(
        new Rect.fromCircle(center: shdowPaintCenter, radius: shdowPaintRadius),
        degreeToRadians(278),
        degreeToRadians(360 - (365 - angle)),
        false,
        shdowPaint);

    final rect = new Rect.fromLTWH(0.0, 0.0, size.width, size.width);
    final gradient = new SweepGradient(
      startAngle: degreeToRadians(268),
      endAngle: degreeToRadians(270.0 + 360),
      tileMode: TileMode.repeated,
      colors: colorsList,
    );
    final paint = new Paint()
      ..shader = gradient.createShader(rect)
      ..strokeCap = StrokeCap.round // StrokeCap.round is not recommended.
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10;
    final center = new Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width / 2, size.height / 2) - (14 / 2);

    canvas.drawArc(
        new Rect.fromCircle(center: center, radius: radius),
        degreeToRadians(278),
        degreeToRadians(360 - (365 - angle)),
        false,
        paint);

    final gradient1 = new SweepGradient(
      tileMode: TileMode.repeated,
      colors: [Colors.white, Colors.white],
    );

    var cPaint = new Paint();
    cPaint..shader = gradient1.createShader(rect);
    cPaint..color = Colors.white;
    cPaint..strokeWidth = 14 / 2;
    canvas.save();

    final centerToCircle = size.width / 2;
    canvas.save();

    canvas.translate(centerToCircle, centerToCircle);
    canvas.rotate(degreeToRadians(angle + 2));

    canvas.save();
    canvas.translate(0.0, -centerToCircle + 14 / 2);
    canvas.drawCircle(new Offset(0, 0), 3, cPaint);

    canvas.restore();
    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  double degreeToRadians(double degree) {
    return (math.pi / 180) * degree;
  }
}
