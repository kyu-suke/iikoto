import 'package:flutter/material.dart';
import 'package:iikoto/database/happy_database_provider.dart';
import 'package:iikoto/settings/screen_arguments.dart';

class CalendarDetailPage extends StatefulWidget {
  CalendarDetailPage({Key key, this.arguments}) : super(key: key);

  final ScreenArguments arguments;

  @override
  _CalendarDetailPageState createState() => new _CalendarDetailPageState();
}

class _CalendarDetailPageState extends State<CalendarDetailPage> {
  Widget happyTexts;

  Future<void> getHappies(List<int> happyIds) async {
    final happies = happyIds == null ? [] : await happiesByIds(happyIds);
    happyTexts = new Container(
        padding: new EdgeInsets.all(32.0),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: happies
              .map((e) => Container(
                    margin: const EdgeInsets.all(16.0),
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(e.createdAtHis),
                            Text(e.text),
                          ],
                        )
                      ],
                    ),
                  ))
              .toList(),
        ));
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    final List<int> args = widget.arguments.ids;
    getHappies(args);
  }

  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Navigator'),
      ),
      body: SingleChildScrollView(
          child: new Container(
        padding: new EdgeInsets.all(32.0),
        child: new Center(
          child: happyTexts,
        ),
      )),
    );
  }
}
