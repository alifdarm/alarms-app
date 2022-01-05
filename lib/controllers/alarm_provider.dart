import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_alarm_app/models/alarm.dart';
import 'package:flutter_alarm_app/utils/background_service.dart';
import 'package:flutter_alarm_app/utils/common.dart';
import 'package:flutter_alarm_app/utils/database.dart';

enum AlarmType { OneShot, Periodic }

class AlarmProvider extends ChangeNotifier {
  final DatabaseHelper databaseHelper;
  List<Alarm> _alarms = [];

  AlarmProvider(this.databaseHelper) {
    fetchAlarm();
  }
  List<Alarm> get alarms => _alarms;

  Future<void> fetchAlarm() async {
    final result = await databaseHelper.getAlarms();
    _alarms = result;
    print(_alarms);
    notifyListeners();
  }

  Future<Alarm> getAlarmById(int id) async {
    final result = await databaseHelper.getAlarmById(id);
    return result;
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
    if (!alarm.isRinged) {
      // Jika sebelumnya alarm keadaan aktif
      await AndroidAlarmManager.cancel(alarm.alarmId);
      print("alarm ditunda");
    } else {
      if (alarm.scheduleType == "one_shot") {
        if (DateTime.now().isBefore(alarm.scheduleTime)) {
          await AndroidAlarmManager.oneShotAt(
              alarm.scheduleTime, alarm.alarmId, BackgroundService.callback);
        } else {
          await AndroidAlarmManager.oneShotAt(
              alarm.scheduleTime.add(Duration(days: 1)),
              alarm.alarmId,
              BackgroundService.callback);
        }
      } else {
        await AndroidAlarmManager.periodic(
            Duration(days: 1), alarm.alarmId, BackgroundService.callback,
            startAt: alarm.scheduleTime);
      }
    }
    await databaseHelper.updateAlarm(alarm);
    fetchAlarm();
  }

  Future<void> deleteAlarm(int id) async {
    await databaseHelper.removeFavorite(id);
    print("Alarm dibatalkan");
    fetchAlarm();
  }
}
