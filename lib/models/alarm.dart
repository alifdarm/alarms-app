class Alarm {
  int alarmId;
  DateTime scheduleTime;
  String scheduleType;
  bool isRinged;

  Alarm(this.alarmId, this.scheduleTime, this.scheduleType, this.isRinged);

  factory Alarm.fromJson(Map<String, dynamic> json) => Alarm(
    json["alarm_id"],
    DateTime.parse(json["schedule_time"]), 
    json["schedule_type"], 
    json["is_ringed"] == 1
  );

  Map<String, dynamic> toJson() => {
        "alarm_id": alarmId,
        "schedule_time": scheduleTime.toIso8601String(),
        "schedule_type": scheduleType,
        "is_ringed": isRinged ? 1 : 0
      };
}
