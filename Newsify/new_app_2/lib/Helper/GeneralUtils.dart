
import 'package:flutter/material.dart';

class Utils {
  static BuildContext ?_context;
  static void showLoading(BuildContext context) async{
  
    await showDialog(
        barrierDismissible: false,
        useRootNavigator: true,
        context: context,
        builder: (ctx) {
          _context=ctx;
          Future.delayed(Duration(seconds: 10), () {
            Navigator.of(ctx).pop();
          });
          return AlertDialog(
            title: Row(
              children: [
                CircularProgressIndicator(),
                SizedBox(
                  width: 10,
                ),
                Text('Loading')
              ],
            ),
          );
        });
  }

  static void closeLoading() => Navigator.of(_context!).pop();
  static void showSnackBar(BuildContext context, Object e) {
   Navigator.of(context).pop();
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          e.toString(),
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        action: SnackBarAction(
          label: 'Hide',
          textColor: Colors.orange,
          onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
        ),
      ),
    );
  
  }
}
