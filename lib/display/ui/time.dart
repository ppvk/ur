library ur.time;

import 'dart:async';
import 'dart:html';

/// You can make a new clock, but one's already made. It's 'clock'
abstract class Clock {
  // Time Meter Variables
  static Element _currDay = querySelector('#day');
  static Element _currTime = querySelector('#time');
  static Element _currDate = querySelector('#date');

  static start() async {
    _getDate();
    _currDay.text = dayofweek;
    _currTime.text = time;
    _currDate.text = day + ' of ' + month;
    new Timer.periodic(new Duration(seconds: 10), (_) async {
      _getDate();
      await window.animationFrame;
      _currDay.text = dayofweek;
      _currTime.text = time;
      _currDate.text = day + ' of ' + month;
    });
  }

  static String _dayofweek, _year, _day, _month, _time;
  static int _dayInt, _monthInt;
  static List _dPM = [29, 3, 53, 17, 73, 19, 13, 37, 5, 47, 11, 1];

  // Getters, so they can only be written by the Clock
  static String get dayofweek => _dayofweek;

  static String get year => _year;

  static String get day => _day;

  static String get month => _month;

  static String get time => _time;

  static List<int> get daysPerMonth => _dPM;

  // Integer versions
  static int get dayInt => _dayInt;

  static int get monthInt => _monthInt;

  static List _Months = const [
    'Primuary',
    'Spork',
    'Bruise',
    'Candy',
    'Fever',
    'Junuary',
    'Septa',
    'Remember',
    'Doom',
    'Widdershins',
    'Eleventy',
    'Recurse'
  ];
  static List _Days_of_Week = const [
    'Hairday',
    'Moonday',
    'Twoday',
    'Weddingday',
    'Theday',
    'Fryday',
    'Standday',
    'Fabday'
  ];

  static _getDate() {
    //
    // there are 4435200 real seconds in a game year
    // there are 14400 real seconds in a game day
    // there are 600 real seconds in a game hour
    // there are 10 real seconds in a game minute
    //

    //
    // how many real seconds have elapsed since game epoch?
    //
    int ts = (new DateTime.now().millisecondsSinceEpoch * 0.001).floor();
    int sec = ts - 1238562000;

    int year = (sec / 4435200).floor();
    sec -= year * 4435200;

    int day_of_year = (sec / 14400).floor();
    sec -= day_of_year * 14400;

    int hour = (sec / 600).floor();
    sec -= hour * 600;

    int minute = (sec / 10).floor();
    sec -= minute * 10;

    //
    // turn the 0-based day-of-year into a day & month
    //

    List MonthAndDay = _day_to_md(day_of_year);

    //
    // get day-of-week
    //

    int days_since_epoch = day_of_year + (307 * year);

    int day_of_week = days_since_epoch % 8;

    //
    // Append to our day_of_month
    //
    String suffix;
    if (MonthAndDay[1].toString().endsWith('1'))
      suffix = 'st';
    else if (MonthAndDay[1].toString().endsWith('2'))
      suffix = 'nd';
    else if (MonthAndDay[1].toString().endsWith('3'))
      suffix = 'rd';
    else
      suffix = 'th';

    //
    // Fix am pm times
    //

    String h = hour.toString();
    String m = minute.toString();
    String ampm = 'am';
    if (minute < 10) m = '0' + minute.toString();
    if (hour >= 12) {
      ampm = 'pm';
      if (hour > 12) h = (hour - 12).toString();
    }
    if (h == '0') h = (12).toString();
    String CurrentTime = (h + ':' + m + ampm);

    List data = [
      'Year ' + year.toString(),
      _Months[MonthAndDay[0] - 1],
      MonthAndDay[1].toString() + suffix,
      _Days_of_Week[day_of_week],
      CurrentTime,
      MonthAndDay[1],
      MonthAndDay[0]
    ];
    _dayofweek = data[3];
    _time = data[4];
    _day = data[2];
    _month = data[1];
    _year = data[0];

    _dayInt = data[5];
    _monthInt = data[6];
  }

  static List _day_to_md(id) {
    int cd = 0;

    int daysinMonths = daysPerMonth[0] +
        daysPerMonth[1] +
        daysPerMonth[2] +
        daysPerMonth[3] +
        daysPerMonth[4] +
        daysPerMonth[5] +
        daysPerMonth[6] +
        daysPerMonth[7] +
        daysPerMonth[8] +
        daysPerMonth[9] +
        daysPerMonth[10] +
        daysPerMonth[11];

    for (int i = 0; i < (daysinMonths); i++) {
      cd += daysPerMonth[i];
      if (cd > id) {
        int m = i + 1;
        int d = id + 1 - (cd - daysPerMonth[i]);
        return [m, d];
      }
    }

    return [0, 0];
  }
}
