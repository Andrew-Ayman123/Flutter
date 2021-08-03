import 'package:covid_v2/Providers/Countries.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/*class News extends StatefulWidget {
  final String img;
  final String text;
  final int primaryNumber;
  final Color color;
  final String city;
  final int secondryNumber;
  final DateTime date;
  News({
    @required this.text,
    @required this.img,
    @required this.color,
    @required this.city,
    @required this.primaryNumber,
    @required this.secondryNumber,
    @required this.date,
  });

  @override
  _NewsState createState() => _NewsState();
}

class _NewsState extends State<News> with TickerProviderStateMixin {
  AnimationController animationController1;
  AnimationController animationController2;
  @override
  void initState() {
    animationController1 = AnimationController(
      duration: Duration(milliseconds: 0),
      vsync: this,
    );
    animationController2 = AnimationController(
        duration: Duration(
          milliseconds: 1000,
        ),
        vsync: this);
    animationController1.forward();
    animationController2.forward();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant News oldWidget) {
    animationController1 = AnimationController(
      duration: Duration(milliseconds: 700),
      vsync: this,
    );
    animationController1.forward();
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    animationController1.dispose();
    animationController2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return FadeTransition(
      opacity: animationController2,
      child: Container(
        padding: EdgeInsets.all(mediaQuery.size.width * .02),
        height: mediaQuery.size.height * .175,
        child: Card(
          elevation: 5,
          child: Container(
            padding: EdgeInsets.all(mediaQuery.size.width * .005),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: mediaQuery.size.width * .02,
                ),
                Center(
                  child: Container(
                    height: mediaQuery.size.height * .1,
                    child: FittedBox(
                      child: Image.asset(
                        widget.img,
                        color: widget.color,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: mediaQuery.size.width * .02,
                ),
                Container(
                  width: mediaQuery.size.width * .3,
                  height: mediaQuery.size.height * .2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FittedBox(
                        child: Text(
                          widget.text,
                          style: TextStyle(
                              color: widget.color,
                              fontSize: 20,
                              fontFamily: 'Quicksand',
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Row(
                        children: [
                          FadeTransition(
                            opacity: animationController1,
                            child: widget(
                              child: Text(
                                widget.city,
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                  fontFamily: 'Quicksand',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            DateFormat('d/M/y').format(widget.date),
                            style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                                fontFamily: 'Quicksand',
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: mediaQuery.size.width * .1,
                ),
                Center(
                  child: Container(
                    width: mediaQuery.size.width * .25,
                    child: FittedBox(
                      child: FadeTransition(
                        opacity: animationController1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              NumberFormat('###,000')
                                  .format(widget.primaryNumber),
                              style: TextStyle(
                                color: widget.color,
                                fontSize: 30,
                                fontFamily: 'Quicksand',
                              ),
                            ),
                            if (widget.secondryNumber != 0)
                              Row(
                                children: [
                                  Text(
                                    NumberFormat('###,##0')
                                        .format(widget.secondryNumber),
                                    style: TextStyle(
                                      color: widget.color.withOpacity(.7),
                                      fontSize: 15,
                                      fontFamily: 'Quicksand',
                                      fontWeight: FontWeight.bold
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Icon(
                                    Icons.arrow_circle_up_sharp,
                                    color: widget.color.withOpacity(.7),
                                     size: 25,
                                  ),
                                ],
                              )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}*/
class News extends StatelessWidget {
  final String img;
  final String text;
  final int primaryNumber;
  final Color color;
  final String city;
  final int secondryNumber;
  final DateTime date;
  News({
    @required this.text,
    @required this.img,
    @required this.color,
    @required this.city,
    @required this.primaryNumber,
    @required this.secondryNumber,
    @required this.date,
  });
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Center(
        child: ListTile(
          contentPadding: const EdgeInsets.all(15),
          leading: Image.asset(
            img,
            fit: BoxFit.cover,
            color: color,
          ),
          title: Text(
            text,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            '$city ${DateFormat('d/M/y').format(date)}',
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                NumberFormat('###,##0').format(primaryNumber),
                style: Theme.of(context).textTheme.bodyText2.copyWith(
                      color: color,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
              ),
              if (secondryNumber != 0)
                FittedBox(
                  child: Row(
                    children: [
                      Text(
                        NumberFormat('###,##0').format(secondryNumber),
                        style: TextStyle(color: color),
                      ),
                      Icon(
                        Icons.arrow_upward_rounded,
                        color: color,
                        size: 20,
                      ),
                    ],
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
