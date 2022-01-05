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

class _MyHomePageState extends State<HomePage> with WidgetsBindingObserver {
  bool sampleSwitch = true;
  final NotificationHelper _notificationHelper = NotificationHelper();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    Future.microtask(
        () => Provider.of<AlarmProvider>(context, listen: false).fetchAlarm());
    _notificationHelper.configureSeelectNotificationSubject(context);
  }

  void didPopNext() {
    Future.microtask(
        () => Provider.of<AlarmProvider>(context, listen: false).fetchAlarm());
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);
    print(state);
    if (state == AppLifecycleState.detached ||
        state == AppLifecycleState.inactive) return;

    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.resumed) {
      print("App Resumed");
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    selectNotificationSubject.close();
    WidgetsBinding.instance!.removeObserver(this);
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
            Consumer<AlarmProvider>(
              builder: (context, provider, _) {
                  final activeUser = provider.alarms
                      .where((element) => element.isRinged)
                      .length;
                  final inactiveUser = provider.alarms.length - activeUser;
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        NormalText(
                            text: "Alarm Active", color: Colors.black, size: 13.sp),
                        NormalText(text: activeUser.toString(), size: 18.sp, weight: FontWeight.bold)
                      ],
                    ),
                    Container(
                      width: 2,
                      height: 10.w,
                      color: Colors.grey,
                    ),
                    Column(
                      children: [
                        NormalText(
                            text: "Alarm inactive", color: Colors.black, size: 13.sp),
                        NormalText(text: inactiveUser.toString(), size: 18.sp, weight: FontWeight.bold,)
                      ],
                    )
                  ],
                );
              }
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
