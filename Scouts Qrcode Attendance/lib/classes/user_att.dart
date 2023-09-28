import 'package:cloud_firestore/cloud_firestore.dart';

class AppUserAttendance{
    String email,eventId;
  DateTime date;
  
  
  AppUserAttendance({
    required this.email,
    required this.eventId,
    required this.date,
  });
  @override
  AppUserAttendance.fromJson(Map<String, dynamic> values)
      : email = values['email'],
        eventId = values['event_id'],
        date = (values['date'] as Timestamp).toDate();

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'event_id': eventId,
      'date': date,
    };
  }
}