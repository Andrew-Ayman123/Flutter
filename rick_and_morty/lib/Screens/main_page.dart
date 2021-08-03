import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rick_and_morty/Providers/models.dart';
import 'package:rick_and_morty/Widgets/character.dart';
import 'package:rick_and_morty/Widgets/episode.dart';
import 'package:rick_and_morty/Widgets/loading.dart';
import 'package:rick_and_morty/Providers/handling_data.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    final data = Provider.of<DataHandler>(context);
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: ListView(
            shrinkWrap: true,
            children: [
              Image.asset(
                'lib/assets/Rick and Morty.png',
                fit: BoxFit.fill,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ChoiceChip(
                    onSelected: (_) => data.typeSetter(true),
                    label: Text('Characters'),
                    selected: data.typeGetter(TypeRM.characters),
                    avatar: Icon(Icons.person),
                  ),
                  Container(
                    width: 100,
                    height: 100,
                    child: Image.asset(
                      'lib/assets/Loading-gif.gif',
                      fit: BoxFit.contain,
                      alignment: Alignment.topLeft,
                    ),
                  ),
                  ChoiceChip(
                    onSelected: (_) => data.typeSetter(false),
                    disabledColor: Colors.black,
                    label: Text('Episodes'),
                    selected: data.typeGetter(TypeRM.episodes),
                    avatar: Icon(Icons.movie),
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              //to preview the grid
              FutureBuilder(
                future: data.characters,
                builder: (ctx, AsyncSnapshot<Map<String, dynamic>> snap) {
                  if (snap.connectionState == ConnectionState.waiting)
                    return Loading();
                  if (snap.hasError || snap.data == null)
                    return Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        FloatingActionButton.extended(
                          onPressed: () => setState(() {}),
                          label: Text(
                            'Error...Refresh',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          icon: Icon(
                            Icons.refresh_rounded,
                            size: 30,
                          ),
                        ),
                      ],
                    );

                  return Column(
                    children: [
                      GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        itemCount: (snap.data['data'] as List<dynamic>).length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: MediaQuery.of(context).orientation ==
                                  Orientation.portrait
                              ? 2
                              : 3,
                          crossAxisSpacing: 15,
                          mainAxisSpacing: 15,
                        ),
                        itemBuilder: (ctx2, index) => data
                                .typeGetter(TypeRM.characters)
                            ? SingleCharacter(
                                (snap.data['data'] as List<Character>)[index],
                              )
                            : EpisodeWidget(
                                (snap.data['data'] as List<Episode>)[index]),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (data.index != 1)
                            Directionality(
                              textDirection: TextDirection.rtl,
                              child: TextButton.icon(
                                style: TextButton.styleFrom(
                                  primary: Colors.white,
                                  backgroundColor: Colors.teal,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                onPressed: data.decrementIndex,
                                icon: Icon(Icons.arrow_forward),
                                label: Text('${data.index - 1}'),
                              ),
                            ),
                          SizedBox(
                            width: 10,
                          ),
                          if (snap.data['pagesNum'] != data.index)
                            TextButton.icon(
                              style: TextButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                primary: Colors.white,
                                backgroundColor: Colors.teal,
                              ),
                              onPressed: data.incrementIndex,
                              icon: Icon(Icons.arrow_forward),
                              label: Text('${data.index + 1}'),
                            )
                        ],
                      )
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
