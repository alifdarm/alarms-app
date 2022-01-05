import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_alarm_app/controllers/alarm_provider.dart';
import 'package:flutter_alarm_app/models/alarm.dart';
import 'package:flutter_alarm_app/utils/background_service.dart';
import 'package:flutter_alarm_app/views/widgets/clock.dart';
import 'package:flutter_alarm_app/views/widgets/custom_text.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;

import '../../controllers/alarm_provider.dart';

class AddNewAlarm extends StatefulWidget {
  const AddNewAlarm({Key? key}) : super(key: key);

  @override
  _AddNewAlarmState createState() => _AddNewAlarmState();
}

class _AddNewAlarmState extends State<AddNewAlarm> {
  DateTime _dateTime = DateTime(DateTime.now().year, DateTime.now().month,
      DateTime.now().day, 0, 0, 0, 0, 0);
  int minute = 0;
  int hour = 0;
  final FixedExtentScrollController hourController =
      FixedExtentScrollController(initialItem: 0);
  final FixedExtentScrollController minuteController =
      FixedExtentScrollController(initialItem: 0);
  AlarmType type = AlarmType.OneShot;
  String alarmType(AlarmType alarmType) {
    if (alarmType == AlarmType.OneShot) {
      return "one_shot";
    } else {
      return "periodic";
    }
  }

  void setAlarm() async {
    if (type == AlarmType.OneShot) {
      if (_dateTime.hour < DateTime.now().hour) { // Dipastikan yang dimaksud adalah keesokan harinya
        await AndroidAlarmManager.oneShotAt(
          _dateTime.add(Duration(days: 1)), hour * 60 + minute, BackgroundService.callback,
          exact: true, wakeup: true, alarmClock: true);
      } else {
        await AndroidAlarmManager.oneShotAt(
          _dateTime, hour * 60 + minute, BackgroundService.callback,
          exact: true, wakeup: true, alarmClock: true);
      }

    } else {
      await AndroidAlarmManager.periodic(
        Duration(days: 1), hour * 60 + minute, BackgroundService.callback, startAt: _dateTime,
        exact: true, wakeup: true);
    }
    Provider.of<AlarmProvider>(context, listen: false)
        .insertAlarm(
            Alarm(hour * 60 + minute, _dateTime, alarmType(type), true));
    Navigator.pop(context);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(DotEnv.dotenv.get('BOX_NAME'));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    minuteController.dispose();
    hourController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      height: 90.h,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NormalText(
            text: "Add Alarm",
            color: Colors.black,
            size: 14.sp,
            weight: FontWeight.w700,
          ),
          SizedBox(
            height: 15.w,
          ),
          Container(
              height: 50.w,
              alignment: Alignment.center,
              child: ClockWidget(
                dateTime: _dateTime,
                isRealtime: false,
              )),
          SizedBox(
            height: 15.w,
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                height: 54,
                width: 25.w,
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(width: 2),
                        top: BorderSide(width: 2))),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      height: 100,
                      width: 10.w,
                      child: ListWheelScrollView(
                          itemExtent: 54,
                          diameterRatio: 1.2,
                          controller: hourController,
                          physics: FixedExtentScrollPhysics(),
                          onSelectedItemChanged: (val) {
                            print(val);
                            setState(() {
                              hour = val;
                              _dateTime = new DateTime(
                                  _dateTime.year,
                                  _dateTime.month,
                                  _dateTime.day,
                                  val,
                                  _dateTime.minute,
                                  0,
                                  0,
                                  0);
                            });
                          },
                          children: List.generate(
                              24,
                              (index) => Container(
                                    height: 64,
                                    width: 100.w,
                                    child: Center(
                                      child: NormalText(
                                          text: "$index".padLeft(2, "0"),
                                          size: 20.sp),
                                    ),
                                  )))),
                  SizedBox(
                    width: 12,
                    child: Center(
                        child: NormalText(
                      text: ":",
                      size: 20.sp,
                    )),
                  ),
                  Container(
                      height: 100,
                      width: 10.w,
                      child: ListWheelScrollView(
                          itemExtent: 54,
                          diameterRatio: 1.2,
                          physics: FixedExtentScrollPhysics(),
                          controller: minuteController,
                          onSelectedItemChanged: (val) {
                            print(val);
                            setState(() {
                              minute = val;
                              _dateTime = new DateTime(
                                  _dateTime.year,
                                  _dateTime.month,
                                  _dateTime.day,
                                  _dateTime.hour,
                                  val,
                                  0,
                                  0,
                                  0);
                            });
                          },
                          children: List.generate(
                              60,
                              (index) => Container(
                                    height: 64,
                                    width: 100.w,
                                    child: Center(
                                      child: NormalText(
                                          text: "$index".padLeft(2, "0"),
                                          size: 20.sp),
                                    ),
                                  )))),
                ],
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 18.0),
            child: NormalText(
              text: "Ringing Type",
              size: 13.sp,
              weight: FontWeight.normal,
            ),
          ),
          RadioListTile(
            contentPadding: EdgeInsets.zero,
            value: AlarmType.OneShot,
            groupValue: type,
            onChanged: (AlarmType? value) {
              setState(() {
                type = value!;
              });
            },
            title: Text("Ring Once"),
          ),
          RadioListTile(
            contentPadding: EdgeInsets.zero,
            value: AlarmType.Periodic,
            groupValue: type,
            onChanged: (AlarmType? value) {
              setState(() {
                type = value!;
              });
            },
            title: Text("Ring Periodic"),
          ),
          Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    print(_dateTime);
                    print("Hours: $hour");
                    print("Minute: $minute");
                    Navigator.pop(context);
                  },
                  child: NormalText(
                    size: 13.sp,
                    text: 'Cancel',
                  ),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          Theme.of(context).canvasColor)),
                ),
              ),
              SizedBox(
                width: 16,
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: setAlarm,
                  child: NormalText(
                    size: 13.sp,
                    text: 'Done',
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
