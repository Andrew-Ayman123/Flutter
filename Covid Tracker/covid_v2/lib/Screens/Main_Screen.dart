import 'package:covid_v2/Providers/Countries.dart';
import 'package:covid_v2/Providers/ThemePrv.dart';
import 'package:covid_v2/Widgets/News.dart';
import 'package:covid_v2/Widgets/Search.dart';
import 'package:covid_v2/Widgets/AppDrawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  static const routeName = '/MainScreen';
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Future<void> fetch() {
    return Provider.of<Countries>(context, listen: false)
        .fetchData()
        .catchError((error) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Unable to Connect to the internet'),
      ));
    });
  }

  @override
  void initState() {
    fetch();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //final countriesData = Provider.of<Countries>(context);

    // final countries = countriesData.countries;
    //final Country country = countriesData.country;
    final themeData = Provider.of<ThemeChooser>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Covid-19 Tracker'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              //Navigator.of(context).pushNamed(SearchBar.routeName);
              showSearch(context: context, delegate: DataSearch());
            },
          )
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: Provider.of<Countries>(context, listen: false).fetchData(),
        builder: (ctx, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting)
            return Center(
              child: const CircularProgressIndicator(),
            );
          if (dataSnapshot.error != null) {
            return Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Unable to Connect',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                  FloatingActionButton.extended(
                    onPressed: () {
                      setState(() {
                        fetch();
                      });
                    },
                    label: const Text('Refresh'),
                    icon: const Icon(Icons.refresh),
                  )
                ],
              ),
            );
          } else {
            return Consumer<Countries>(
              builder: (ctx, itemData, child) {
                return RefreshIndicator(
                  onRefresh: fetch,
                  child: ListView(
                    itemExtent: 150,
                    children: [
                      News(
                        text: 'Total Cases',
                        img: 'Assets/Images/Cases.png',
                        color: themeData.casesColor,
                        city: itemData.country.city,
                        primaryNumber: itemData.country.totalCases,
                        secondryNumber: itemData.country.newCases,
                        date: itemData.country.date,
                      ),
                      News(
                        text: 'Active Cases',
                        img: 'Assets/Images/Active Cases .png',
                        color: themeData.activeCasesColor,
                        city: itemData.country.city,
                        primaryNumber: itemData.country.activeCases,
                        secondryNumber: 0,
                        date: itemData.country.date,
                      ),
                      News(
                        text: 'Recovered',
                        img: 'Assets/Images/Recovered.png',
                        color: themeData.recoveredColor,
                        city: itemData.country.city,
                        primaryNumber: itemData.country.totalRecovered,
                        secondryNumber: itemData.country.newRecovered,
                        date: itemData.country.date,
                      ),
                      News(
                        text: 'Deaths',
                        img: 'Assets/Images/Deaths.png',
                        color: themeData.deathsColor,
                        city: itemData.country.city,
                        primaryNumber: itemData.country.totalDeaths,
                        secondryNumber: itemData.country.newDeaths,
                        date: itemData.country.date,
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
