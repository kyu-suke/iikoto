import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:iikoto/database/happy_database_provider.dart';
import 'package:iikoto/model/happy.dart';
import "package:intl/intl.dart";
import 'package:iikoto/services/count_stream_service.dart';

class LineChartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          const Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(
                left: 36.0,
                top: 24,
              ),
              child: Text(
                'log',
                style: TextStyle(
                    color: Color(
                      0xff6f6f97,
                    ),
                    fontSize: 32,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Container(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 28,
                right: 28,
              ),
              child: LineChartArea(),
            ),
          ),
        ],
      ),
    );
  }
}

class LineChartArea extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LineChartAreaState();
}

class LineChartAreaState extends State<LineChartArea> {
  final countStreamService = CountStreamService();

  LineChartAreaState() {

    countStreamService.onAdd.listen((value) {
      print("↓ is listened value!!!");
      print(value);
      setPlots();
    });
  }

  bool isShowingMainData;

  DateTime date;
  List<FlSpot> spots = [];

  String get year {
    return "${date.year}";
  }

  String get month {
    return "${date.month}";
  }

  List<String> dates = [];

  void setDates() {
    dates = [];
    final month = date.month;
    for (var baseDate = DateTime(date.year, date.month, 1);
        baseDate.month == month;
        baseDate = baseDate.add(new Duration(days: 1))) {
      dates.add(new DateFormat('yyyy-MM-dd 00:00:00.000').format(baseDate));
    }
  }

  @override
  void initState() {
    super.initState();
    isShowingMainData = true;
    final datetime = DateTime.now();
    date = new DateTime(datetime.year, datetime.month, 1);
    spots.add(FlSpot(0, 0));
    setPlots();
  }

  void setPlots() {
    setDates();
    Map<String, CountHappyByDate> countByDate = {};
    countHappiesByMonth(DateFormat('yyyy-MM').format(date)).then((value) => {
          spots = [],
          value.forEach((element) {
            countByDate[element.createdAt.toString()] = element;
          }),
          dates.asMap().forEach((key, value) {
            if (countByDate.containsKey(value)) {
              spots.add(FlSpot(key + 0.0, countByDate[value].count + 0.0));
            } else {
              spots.add(FlSpot(key + 0.0, 0.0));
            }
          }),
          setState(() {})
        });
  }

  DateTime prevMonth() {
    return new DateTime(date.year, date.month - 1, 1);
  }

  DateTime nextMonth() {
    return new DateTime(date.year, date.month + 1, 1);
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2 / 3,
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(18)),
        ),
        child: Stack(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(
                  child: _chartArea(),
                ),
                Container(
                  child: _arrowArea(),
                ),
                SizedBox(height: 30),
              ],
            ),
          ],
        ),
      ),
    );
  }

  LineChartData sampleData2() {
    return LineChartData(
      lineTouchData: LineTouchData(
        enabled: true,
      ),
      gridData: FlGridData(
        show: false,
      ),
      titlesData: FlTitlesData(
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          getTextStyles: (value) => const TextStyle(
            color: Color(0xff72719b),
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          margin: 10,
          getTitles: (value) {
            switch (value.toInt()) {
              case 1:
                return '1st';
              case 15:
                return '15th';
              case 30:
                return '30th';
            }
            return '';
          },
        ),
        leftTitles: SideTitles(
          showTitles: true,
          getTextStyles: (value) => const TextStyle(
            color: Color(0xff75729e),
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          getTitles: (value) {
            switch (value.toInt()) {
              case 5:
                return '5';
              case 10:
                return '10';
              case 15:
                return '15';
              case 20:
                return '20';
            }
            return '';
          },
          margin: 8,
          reservedSize: 30,
        ),
      ),
      borderData: FlBorderData(
          show: true,
          border: const Border(
            bottom: BorderSide(
              color: Color(0xff4e4965),
              width: 4,
            ),
            left: BorderSide(
              color: Colors.transparent,
            ),
            right: BorderSide(
              color: Colors.transparent,
            ),
            top: BorderSide(
              color: Colors.transparent,
            ),
          )),
      minX: 0,
      maxX: 31,
      maxY: 20,
      minY: 0,
      lineBarsData: linesBarData(),
    );
  }

  List<LineChartBarData> linesBarData() {
    return [
      LineChartBarData(
        spots: spots,
        isCurved: true,
        curveSmoothness: 0,
        colors: const [
          Color(0x4427b6fc),
        ],
        barWidth: 1,
        isStrokeCapRound: true,
        dotData: FlDotData(show: true),
        belowBarData: BarAreaData(
          show: false,
        ),
      ),
    ];
  }

  Widget _arrowArea() {
    return Container(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        IconButton(
          icon: Icon(
            Icons.arrow_back,
            // color: Colors.white.withOpacity(1.0),
            color: Color(
              0xff6f6f97,
            ),
          ),
          onPressed: () {
            setState(() {
              date = prevMonth();
              setPlots();
            });
          },
        ),
        IconButton(
          icon: Icon(
            Icons.arrow_forward,
            // color: Colors.white.withOpacity(1.0),
            color: Color(
              0xff6f6f97,
            ),
          ),
          onPressed: () {
            setState(() {
              date = nextMonth();
              setPlots();
            });
          },
        ),
      ],
    ));
  }

  Widget _chartArea() {
    return Container(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(
          year,
          style: TextStyle(
            color: Color(0xff827daa),
            fontSize: 16,
          ),
          textAlign: TextAlign.center,
        ),
        Text(
          month,
          style: TextStyle(
              color: Color(0xff827daa),
              fontSize: 32,
              fontWeight: FontWeight.bold,
              letterSpacing: 2),
          textAlign: TextAlign.center,
        ),
        const SizedBox(
          height: 37,
        ),
        Padding(
          padding: const EdgeInsets.only(right: 16.0, left: 6.0),
          child: LineChart(
            sampleData2(),
            swapAnimationDuration: const Duration(milliseconds: 250),
          ),
        ),
      ],
    ));
  }
}
