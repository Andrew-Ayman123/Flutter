import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'dart:math' as math;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Calcuator',
      theme: ThemeData(primaryColor: Colors.blue),
      home: MyAppMain(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyAppMain extends StatefulWidget {
  @override
  _MyAppMainState createState() => _MyAppMainState();
}

class _MyAppMainState extends State<MyAppMain> {
  String resultExp = '0';
  String typeExp = '0';
  String exp = '';
  double typeFontSize = 38;
  double resultFontSize = 48;

  void calcFunc(String text) {
    setState(() {
      if (text == 'C') {
        typeExp = '0';
        resultExp = '0';
        typeFontSize = 38;
        resultFontSize = 48;
      } else if (text == '⌫') {
        typeExp = typeExp.substring(0, typeExp.length - 1);
        if (typeExp == '') typeExp = '0';
        typeFontSize = 48;
        resultFontSize = 38;
      } else if (text == '=') {
        typeFontSize = 38;
        resultFontSize = 48;
        exp = typeExp;
        exp = exp.replaceAll('×', '*');
        exp = exp.replaceAll('÷', '/');
        for (int i = 0; i <= 9; i++) {
          exp = exp.replaceAll('$i𝜋', '$i*${math.pi}');
        }
        exp = exp.replaceAll('𝜋', '${math.pi}');

        try {
          Parser p = Parser();
          Expression exp1 = p.parse(exp);
          ContextModel cm = ContextModel();
          resultExp = '${exp1.evaluate(EvaluationType.REAL, cm)}';
          if (resultExp == 'NaN') resultExp = 'Undefined';
        } catch (e) {
          resultExp = 'Error';
        }
      } else {
        if (typeExp == '0') {
          if (text == '0')
            typeExp += text;
          else
            typeExp = text;
        } else {
          typeExp += text;
        }
        typeFontSize = 48;
        resultFontSize = 38;
      }
    });
  }

  Widget button(String text, Color color, double height) {
    return Container(
      height: MediaQuery.of(context).size.height * .1 * height,
      color: color,
      child: FlatButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0.0),
          side: BorderSide(
            color: Colors.white,
            style: BorderStyle.solid,
            width: 1,
          ),
        ),
        onPressed: ()=>calcFunc(text),
        padding: EdgeInsets.all(5),
        child: FittedBox(
          child: Text(
            text,
            style: TextStyle(fontSize: 30, color: Colors.white),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Simple Calculator',
          textAlign: TextAlign.center,
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Column(
        children: [
          Container(
            alignment: Alignment.centerRight,
            padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
            child: FittedBox(
              child: Text(
                typeExp,
                style: TextStyle(fontSize: typeFontSize),
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerRight,
            padding: EdgeInsets.fromLTRB(10, 30, 10, 0),
            child: Container(
              child: Text(
                resultExp,
                style: TextStyle(fontSize: resultFontSize),
              ),
            ),
          ),
          Expanded(
            child: Divider(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * .75,
                child: Table(
                  children: [
                    TableRow(
                      children: [
                        button('C', Colors.redAccent, 1),
                        button('⌫', Colors.blue, 1),
                        button('÷', Colors.blue, 1),
                      ],
                    ),
                    TableRow(
                      children: [
                        button('7', Colors.black54, 1),
                        button('8', Colors.black54, 1),
                        button('9', Colors.black54, 1),
                      ],
                    ),
                    TableRow(
                      children: [
                        button('4', Colors.black54, 1),
                        button('5', Colors.black54, 1),
                        button('6', Colors.black54, 1),
                      ],
                    ),
                    TableRow(
                      children: [
                        button('1', Colors.black54, 1),
                        button('2', Colors.black54, 1),
                        button('3', Colors.black54, 1),
                      ],
                    ),
                    TableRow(
                      children: [
                        button('.', Colors.black54, 1),
                        button('0', Colors.black54, 1),
                        button('𝜋', Colors.black54, 1),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * .25,
                child: Table(
                  children: [
                    TableRow(
                      children: [
                        button('×', Colors.blue, 1),
                      ],
                    ),
                    TableRow(
                      children: [
                        button('-', Colors.blue, 1),
                      ],
                    ),
                    TableRow(
                      children: [
                        button('+', Colors.blue, 1),
                      ],
                    ),
                    TableRow(
                      children: [
                        button('=', Colors.redAccent, 2),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
