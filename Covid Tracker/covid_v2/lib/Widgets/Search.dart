import 'package:covid_v2/Providers/Countries.dart';
import 'package:covid_v2/Providers/ThemePrv.dart';
import 'package:covid_v2/Screens/Main_Screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class DataSearch extends SearchDelegate<String> {
  List<Country> recentCountries = [];
@override
  ThemeData appBarTheme(BuildContext context) {
    // ignore: todo
    // TODO: implement appBarTheme
    return Theme.of(context);
  }
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(
            Icons.clear,
          ),
          onPressed: () {
            query = '';
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        ),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    throw UnimplementedError();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final themeData = Provider.of<ThemeChooser>(context);
    List<Country> countries = Provider.of<Countries>(context).countries;
    final suggestionList = query.isEmpty
        ? countries
        : countries
            .where((element) =>
                element.city.toLowerCase().startsWith(query.toLowerCase()))
            .toList();
    return ListView.builder(
      itemBuilder: (ctx, index) => Column(
        children: [
          InkWell(
            onTap: () {
              Provider.of<Countries>(context, listen: false)
                  .changeCurrentCountry(suggestionList[index].id);
              close(context, null);
            },
            child: Container(
              height: 60,
              child: Row(
                children: [
                  Expanded(
                    child: Icon(
                      Icons.location_city,
                      color: themeData.townColor,
                    ),
                    flex: 2,
                  ),
                  Expanded(
                    flex: 4,
                    child: RichText(
                      text: TextSpan(
                        text: suggestionList[index]
                            .city
                            .substring(0, query.length),
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold),
                        children: [
                          TextSpan(
                            text: suggestionList[index]
                                .city
                                .substring(query.length),
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ),
                  NumberWithLogo(themeData.casesColor, suggestionList[index].newCases),
                  NumberWithLogo(
                      themeData.recoveredColor, suggestionList[index].newRecovered),
                  NumberWithLogo(themeData.deathsColor, suggestionList[index].newDeaths),
                ],
              ),
            ),
          ),
          Divider(),
        ],
      ),
      itemCount: suggestionList.length,
    );
  }
}

class NumberWithLogo extends StatelessWidget {
  final Color color;
  final int number;

  const NumberWithLogo(
    this.color,
    this.number,
  );
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 3,
      child: Row(
        children: [
          Icon(
            Icons.arrow_circle_up_rounded,
            color: color,
          ),
          FittedBox(
            child: Text(
              NumberFormat('###,##0').format(number),
              style: TextStyle(color: color),
            ),
          )
        ],
      ),
    );
  }
}
