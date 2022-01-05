import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_alarm_app/controllers/alarm_provider.dart';
import 'package:flutter_alarm_app/views/widgets/custom_text.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:intl/intl.dart';

class ListAlarms extends StatefulWidget {
  const ListAlarms({Key? key}) : super(key: key);

  @override
  _ListAlarmsState createState() => _ListAlarmsState();
}

class _ListAlarmsState extends State<ListAlarms> {
  bool sampleSwitch = true;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Scrollbar(
        child: Consumer<AlarmProvider>(builder: (context, data, _) {
          return ListView(
            shrinkWrap: true,
            physics: ScrollPhysics(),
            children: List.generate(
              data.alarms.length,
              (index) {
                final alarm = data.alarms[index];
                return ListTile(
                  title: NormalText(
                      text: DateFormat("hh:mm a").format(alarm.scheduleTime),
                      color: Colors.black,
                      size: 16.sp),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      NormalText(
                          text: alarm.scheduleType == "one_shot"
                              ? "Ring Once"
                              : "Periodic",
                          color: Colors.black,
                          size: 11.sp),
                      TextButton.icon(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                    title: Text("Menghapus Alarm"),
                                    content:
                                        Text("Apakah Anda akan melanjutkan?"),
                                    actions: [
                                      TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: Text("Cancel")),
                                      TextButton(
                                          onPressed: () async {
                                            Provider.of<AlarmProvider>(context,
                                                    listen: false)
                                                .deleteAlarm(alarm.alarmId);
                                            await AndroidAlarmManager.cancel(
                                                alarm.alarmId);
                                            Navigator.pop(context);
                                          },
                                          child: Text("Ok")),
                                    ],
                                  ));
                        },
                        label: Text("Delete"),
                        icon: Icon(Icons.delete),
                        style: ButtonStyle(
                            foregroundColor:
                                MaterialStateProperty.all(Colors.red)),
                      )
                    ],
                  ),
                  trailing: Switch(
                    onChanged: (bool value) {
                      setState(() {
                        alarm.isRinged = !alarm.isRinged;
                        print(alarm.isRinged);
                        Provider.of<AlarmProvider>(context, listen: false)
                            .updateAlarm(alarm);
                      });
                    },
                    value: alarm.isRinged,
                  ),
                );
              },
            ),
          );
        }),
      ),
    );
  }
}
