import 'package:asdt_app/constants/fonts.dart';
import 'package:asdt_app/helpers/dialog.dart';
import 'package:asdt_app/helpers/firebase_firestore.dart';
import 'package:asdt_app/helpers/format.dart';
import 'package:asdt_app/widgets/custom_listview.dart';
import 'package:asdt_app/widgets/custom_scaffold.dart';
import 'package:asdt_app/widgets/custom_textformfield.dart';
import 'package:flutter/material.dart';

import '../../../widgets/custom_loading_button.dart';

class CreateNewEventScreen extends StatefulWidget {
  const CreateNewEventScreen({super.key});
  static const routeName = "/CreateEvent";

  @override
  State<CreateNewEventScreen> createState() => _CreateNewEventScreenState();
}

class _CreateNewEventScreenState extends State<CreateNewEventScreen> {
  final formKey = GlobalKey<FormState>();
  String? eventName, eventLocation;
  DateTime eventDate = DateTime.now();
  Future<void> createEvent() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (!formKey.currentState!.validate()) {
      return;
    }
    formKey.currentState!.save();
    if (await FirebaseFirestoreHelper.addNewEvent(
        eventName: eventName!,
        eventLocation: eventLocation!,
        eventDate: eventDate,
        context: context)) {
      Navigator.of(context).pop();
    }
  }

  void setEventName(String? txt) {
    eventName = txt!.trim();
  }

  void setEventLocation(String? txt) {
    eventLocation = txt!.trim();
  }

  void setEventDateDay() async {
    final date = await DialogHelper.displayDateDay(context, eventDate);
    if (date != null) {
      eventDate = DateTime(
          date.year, date.month, date.day, eventDate.hour, eventDate.minute);
      setState(() {});
    }
  }

  void setEventDateTime() async {
    final timeOfDay = await DialogHelper.displayDateTime(context, eventDate);
    if (timeOfDay != null) {
      eventDate = DateTime(eventDate.year, eventDate.month, eventDate.day,
          timeOfDay.hour, timeOfDay.minute);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: AppBar(
        title: const Text('Create New Event'),
      ),
      body: Form(
        key: formKey,
        child: CustomListView(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 26),
          children: [
            CustomTextFormField(
              onSaved: setEventName,
              type: CustomTextInputType.eventName,
            ),
            const SizedBox(
              height: 8,
            ),
            CustomTextFormField(
              onSaved: setEventLocation,
              type: CustomTextInputType.eventLocation,
            ),
            SizedBox(
              height: 16,
            ),
            FittedBox(
              child: Text(
                'Event Date: \n${FormatHelper.formatDate(eventDate)}',
                style: Theme.of(context).textTheme.bodyText2,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            FittedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  OutlinedButton(
                      onPressed: setEventDateDay,
                      child: Text("Change Day"),
                      style: ButtonStyle()),
                  SizedBox(
                    width: 8,
                  ),
                  OutlinedButton(
                      onPressed: setEventDateTime, child: Text("Change Time")),
                ],
              ),
            ),
            CustomLoadingButton(
                text: 'Submit', onPressed: createEvent, icon: Icon(Icons.add)),
          ],
        ),
      ),
    );
  }
}
