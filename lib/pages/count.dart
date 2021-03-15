import 'package:flutter/material.dart';
import 'chart.dart';
import 'calendar.dart';
import 'dart:async';
import 'package:iikoto/model/happy.dart';
import 'package:iikoto/database/happy_database_provider.dart';

class CountPage extends StatefulWidget {
  CountPage({Key key}) : super(key: key);

  @override
  _CountPageState createState() => _CountPageState();
}

class _CountPageState extends State<CountPage> {
  _CountPageState() {
    getHappyCount().then((value) => {
      _counter = value,
      setState(() {}),
    });
  }

  int _counter = 0;
  String _text = "";

  void _incrementCounter() async {
    setState(() {
      insertHappy(Happy(
        text: _text,
        createdAt: DateTime.now(),
      ));
    });

    final happy = await countHappiesByCreatedAt(DateTime.now());
    setState(() {
      _counter = happy.count;
    });
  }

  void _handleText(String e) {
    setState(() {
      _text = e;
    });
  }

  void _incrementCounterWithComment(BuildContext context) async {
    await showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
                child: Column(
                  children: [
                    TextField(
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: InputDecoration(
                        hintText: "input happy things.",
                      ),
                      onChanged: _handleText,
                    ),
                  ],
                )),
            Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.width * 0.2,
                child: new ElevatedButton(
                  child: Icon(Icons.add),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.orange,
                    onPrimary: Colors.white,
                  ),
                  onPressed: () => {
                    Navigator.of(context).pop(),
                    _incrementCounter(),
                  },
                ))
          ],
        );
      },
    );
  }

  Future<int> getHappyCount() async {
    final happy = await countHappiesByCreatedAt(DateTime.now());
    return happy.count;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Container(
                height: MediaQuery.of(context).size.width * 0.8,
                child: Column(
                  children: [
                    Text(
                      'Number of good things that happened today.',
                    ),
                    Text(
                      '$_counter',
                      style: Theme.of(context).textTheme.headline4,
                    ),
                  ],
                )),
            Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.width * 0.2,
                child: new ElevatedButton(
                  child: Icon(Icons.add_comment_outlined),
                  style: ElevatedButton.styleFrom(
                      primary: Colors.blueAccent,
                      onPrimary: Colors.white,
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(0.0),
                      )),
                  onPressed: () async {
                    _incrementCounterWithComment(context);
                  },
                )),
            Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.width * 0.2,
                child: new ElevatedButton(
                  child: Icon(Icons.add),
                  style: ElevatedButton.styleFrom(
                      primary: Colors.orange,
                      onPrimary: Colors.white,
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(0.0),
                      )),
                  onPressed: _incrementCounter,
                ))
          ],
        ),
      ),
    );
  }
}
