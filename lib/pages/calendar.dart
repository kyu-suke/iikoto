import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel;
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'calendar_detail.dart';
import 'package:iikoto/database/happy_database_provider.dart';
import 'package:iikoto/services/navigation_service.dart';
import 'package:iikoto/settings/screen_arguments.dart';

class CalendarPage extends StatefulWidget {
  CalendarPage({Key key}) : super(key: key);

  @override
  _CalendarPageState createState() => new _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  @override
  void initState() {
    super.initState();
  }

  _CalendarPageState() {
    getHappies().then((value) => {
          value.forEach((element) {
            setState(() {
              _markedDateMap.add(
                  DateTime(element.createdAt.year, element.createdAt.month,
                      element.createdAt.day),
                  new Event(
                    date: DateTime(element.createdAt.year,
                        element.createdAt.month, element.createdAt.day),
                    id: element.id,
                    icon: _eventIcon,
                  ));
            });
          }),
        });
  }

  DateTime _currentDate = DateTime.now();
  String _currentMonth = DateFormat.yMMM().format(DateTime.now());

  static Widget _eventIcon = new Container(
    decoration: new BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(1000)),
        border: Border.all(color: Colors.blue, width: 2.0)),
    child: new Icon(
      Icons.person,
      color: Colors.amber,
    ),
  );

  EventList<Event> _markedDateMap = new EventList<Event>();

  CalendarCarousel _calendarCarousel;
  Row _calendarHeader;

  @override
  Widget build(BuildContext context) {
    _calendarHeader = new Row(
      children: <Widget>[
        Expanded(
            child: Text(
          _currentMonth,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24.0,
          ),
        )),
        FlatButton(
          child: Text('PREV'),
          onPressed: () {
            setState(() {
              _currentDate =
                  DateTime(_currentDate.year, _currentDate.month - 1);
              _currentMonth = DateFormat.yMMM().format(_currentDate);
            });
          },
        ),
        FlatButton(
          child: Text('NEXT'),
          onPressed: () {
            setState(() {
              _currentDate =
                  DateTime(_currentDate.year, _currentDate.month + 1);
              _currentMonth = DateFormat.yMMM().format(_currentDate);
            });
          },
        )
      ],
    );

    _calendarCarousel = CalendarCarousel<Event>(
      todayBorderColor: Colors.green,
      onDayPressed: (DateTime date, List<Event> events) {
        this.setState(() => _currentDate = date);
        final ids = events.map((e) => e.id).toList();
        NavigationService.pushInTab(
          "/calendar_detail",
          arguments: ScreenArguments(
            DateTime.now().toIso8601String(),
            ids: ids,
          ),
        );
      },
      daysHaveCircularBorder: true,
      showOnlyCurrentMonthDate: false,
      weekendTextStyle: TextStyle(
        color: Colors.red,
      ),
      thisMonthDayBorderColor: Colors.grey,
      weekFormat: false,
      markedDatesMap: _markedDateMap,
      height: 420.0,
      targetDateTime: _currentDate,
      customGridViewPhysics: NeverScrollableScrollPhysics(),
      markedDateCustomShapeBorder:
          CircleBorder(side: BorderSide(color: Colors.grey)),
      markedDateCustomTextStyle: TextStyle(
        fontSize: 18,
        color: Colors.blue,
      ),
      showHeader: false,
      todayTextStyle: TextStyle(
        color: Colors.amber,
      ),
      todayButtonColor: Colors.transparent,
      selectedDayTextStyle: TextStyle(
        color: Colors.yellow,
      ),
      prevDaysTextStyle: TextStyle(
        fontSize: 16,
        color: Colors.pinkAccent,
      ),
      inactiveDaysTextStyle: TextStyle(
        color: Colors.tealAccent,
        fontSize: 16,
      ),
      onCalendarChanged: (DateTime date) {
        this.setState(() {
          _currentDate = date;
          _currentMonth = DateFormat.yMMM().format(_currentDate);
        });
      },
    );

    return new Scaffold(
        body: Align(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(flex: 10, child: Container()),
          Expanded(flex: 1, child: Container(child: _calendarHeader,)),
          Expanded(flex: 8, child: Container(child: _calendarCarousel,) ),
        ],
      ),
    ));
  }
}
