import 'package:flutter/material.dart';
import 'package:flutter_alarm_app/controllers/alarm_provider.dart';
import 'package:flutter_alarm_app/utils/notification.dart';
import 'package:flutter_alarm_app/views/widgets/add_new_alarm.dart';
import 'package:flutter_alarm_app/views/widgets/clock.dart';
import 'package:flutter_alarm_app/views/widgets/custom_text.dart';
import 'package:flutter_alarm_app/views/widgets/list_alarms.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import 'widgets/custom_text.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePage> {
  bool sampleSwitch = true;
  final NotificationHelper _notificationHelper = NotificationHelper();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.microtask(
        () => Provider.of<AlarmProvider>(context, listen: false).fetchAlarm());
    _notificationHelper.configureSeelectNotificationSubject(context);
  }

  void didPopNext() {
    Future.microtask(
        () => Provider.of<AlarmProvider>(context, listen: false).fetchAlarm());
  }

  @override
  void dispose() {
    // TODO: implement dispose
    selectNotificationSubject.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("   Alarm", style: TextStyle(color: Colors.black)),
        backgroundColor: Theme.of(context).canvasColor,
        elevation: 0,
      ),
      body: SafeArea(
          child: Center(
        child: Column(
          children: [
            Container(width: 80.w, child: ClockWidget()),
            SizedBox(
              height: 10.w,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                NormalText(
                    text: "Alarm Active: 2", color: Colors.black, size: 13.sp),
                Container(
                  width: 2,
                  height: 10.w,
                  color: Colors.grey,
                ),
                NormalText(
                    text: "Alarm inactive: 4", color: Colors.black, size: 13.sp)
              ],
            ),
            SizedBox(
              height: 5.w,
            ),
            ListAlarms()
          ],
        ),
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showModalBottomSheet<dynamic>(
            isScrollControlled: true,
            shape: OutlineInputBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10)),
                borderSide: BorderSide.none),
            enableDrag: false,
            context: context,
            builder: (_) => AddNewAlarm()),
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
