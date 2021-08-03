import 'package:chat_app/Utils/Theme.dart';
import 'package:chat_app/widgets/Chat/ChatWidget.dart';
import 'package:chat_app/widgets/Chat/SendMessage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SingleChatScreen extends StatelessWidget {
  static const routeName = '/SingleChatScreen';
  @override
  Widget build(BuildContext context) {
    final userReciver =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          leadingWidth: 30,
          elevation: 0,
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.only(right: 5),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: userReciver['reciverImage']),
              ),
              Text(
                userReciver['user']['name'],
              ),
            ],
          ),
          automaticallyImplyLeading: true,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: Provider.of<ThemeChooser>(context).gradientColors,
              ),
            ),
          ),
        ),
        body: Container(
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: Provider.of<ThemeChooser>(context).gradientColors,
            ),
          ),
          child: Column(
            children: [
              Expanded(
                child: Messages(
                    userReciver['chatId'], userReciver['reciverImage']),
              ),
              SendMessage(userReciver['chatId']),
            ],
          ),
        ),
      ),
    );
  }
}
