import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  String name;
  String location;
  String adminEmail;
  DateTime date;
  String? id;
  void setId(String id)=>this.id=id;
  Event({
    required this.name,
    required this.adminEmail,
    required this.location,
    required this.date,
  });
  @override
  Event.fromJson(Map<String, dynamic> values)
      : name = values['name'],
        adminEmail = values['admin_email'],
        location = values['location'],
        date = (values['date'] as Timestamp).toDate();

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'admin_email': adminEmail,
      'location': location,
      'date': date,
    };
  }
}
