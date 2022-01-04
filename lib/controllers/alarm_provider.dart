import 'package:flutter/foundation.dart';
import 'package:flutter_alarm_app/models/alarm.dart';
import 'package:flutter_alarm_app/utils/common.dart';
import 'package:flutter_alarm_app/utils/database.dart';

enum AlarmType { OneShot, Periodic }

class AlarmProvider extends ChangeNotifier {
  final DatabaseHelper databaseHelper;
  List<Alarm> _alarms = [];

  AlarmProvider(this.databaseHelper);
  List<Alarm> get alarms => _alarms;

  Future<void> fetchAlarm() async {
    final result = await databaseHelper.getAlarms();
    _alarms = result;
    notifyListeners();
  }

  Future<void> insertAlarm(Alarm alarm) async {
    final result = await databaseHelper.insertAlarm(alarm);
    if (result) {
      fetchAlarm();
    } else {
      showToast("Alarm pada waktu yang sama telah ada");
    }
  }

  Future<void> updateAlarm(Alarm alarm) async {
    await databaseHelper.updateAlarm(alarm);
    fetchAlarm();
  }

  Future<void> deleteAlarm(int id) async {
    await databaseHelper.removeFavorite(id);
    fetchAlarm();
  }
}
