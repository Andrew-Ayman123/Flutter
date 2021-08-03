import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:new_app_2/Helper/FireStoreHelper.dart';
import 'package:new_app_2/Helper/filtersUtils.dart';
import 'package:new_app_2/Screens/UserPage.dart';
import 'package:new_app_2/webThings.dart';
import 'package:new_app_2/widgets/articles.dart';
import 'package:new_app_2/Helper/searchUtils.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _page = 0;
  Widget get body {
    if (kIsWeb && MediaQuery.of(context).size.width > 800) return WebMainPage();
    switch (_page) {
      case 0:
        return Articles();

      case 1:
        return Center(
          child: UserPage(),
        );

      default:
        return Center(
          child: CircularProgressIndicator(),
        );
    }
  }

  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              showSearch(context: context, delegate: DataSearch(true));
            },
            icon: Icon(Icons.search),
          ),
          PopupMenuButton<String>(
            onSelected: (String? value) async {
              if (value == null) return;
              if (value == 'Categories') {
                final categories = await FireStoreHepler.categories().first;
                value = await showModalBottomSheet<String>(
                  context: context,
                  builder: (ctxMenu) => ListView(
                    children: categories.docs
                        .map(
                          (e) => Column(
                            children: [
                              InkWell(
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Filter by ${e['value']}'),
                                      Checkbox(
                                        value: Filters.filters
                                            .contains(e['value']),
                                        onChanged: (_) {},
                                        materialTapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                      )
                                    ],
                                  ),
                                ),
                                onTap: () {
                                  final boo =
                                      Filters.categoryList.contains(e['value']);
                                  if (!boo)
                                    Filters.categoryList.add(e['value']!);
                                  else
                                    Filters.categoryList.remove(e['value']!);
                                  Navigator.of(ctxMenu).pop(e['value']);
                                },
                              ),
                              Divider(height: 0, thickness: 2)
                            ],
                          ),
                        )
                        .toList(),
                  ),
                );
              }

              final boo = Filters.filters.contains(value);
              if (!boo)
                Filters.filters.add(value!);
              else
                Filters.filters.remove(value!);
              setState(() {});
            },
            itemBuilder: (ctxPop) => [
              PopupMenuItem<String>(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Sort by time'),
                    Checkbox(
                      value: Filters.filters.contains('Time'),
                      onChanged: (_) {},
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    )
                  ],
                ),
                value: 'Time',
              ),
              PopupMenuItem<String>(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Sort by Most Rated'),
                    Checkbox(
                      value: Filters.filters.contains('Most Rated'),
                      onChanged: (_) {},
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ],
                ),
                value: 'Most Rated',
              ),
              PopupMenuItem(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Filter by Categories'),
                    Icon(Icons.arrow_left_rounded)
                  ],
                ),
                value: 'Categories',
              )
            ],
          ),
        ],
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 40,
              child: Image.asset(
                'Assets/main_logo.png',
              ),
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              'Newsify',
              style: GoogleFonts.openSans(fontSize: 30),
            ),
          ],
        ),
      ),
      bottomNavigationBar: kIsWeb && MediaQuery.of(context).size.width > 800
          ? null
          : CurvedNavigationBar(
              height: 50,
              color:Colors.grey.shade900,
              buttonBackgroundColor: 
                 
                  Colors.black,
              key: _bottomNavigationKey,
              items: <Widget>[
                Icon(Icons.list, size: 30,color:Colors.white),
                Icon(Icons.person, size: 30,color:Colors.white),
              ],
              onTap: (index) {
                setState(() {
                  _page = index;
                });
              },
            ),
      body: body,
    ));
  }
}
