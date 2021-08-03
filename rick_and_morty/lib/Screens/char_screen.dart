import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rick_and_morty/Providers/models.dart';
import 'package:rick_and_morty/Widgets/FadeInImage.dart';
import 'package:rick_and_morty/Widgets/Gender.dart';

// ignore: must_be_immutable
class CharacterScreen extends StatelessWidget {
  static const routeName = '/CharacterScreen';
  Character char;

  @override
  Widget build(BuildContext context) {
    char = ModalRoute.of(context).settings.arguments as Character;
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Opacity(
              opacity: .6,
              child: Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage('lib/assets/Matrix.gif'),
                  ),
                ),
              ),
            ),
            Center(
              child: ClipPath(
                child: Container(
                  width: MediaQuery.of(context).size.width * .9,
                  height: MediaQuery.of(context).size.height * .9,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Theme.of(context).accentColor,
                      width: 3,
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Theme.of(context).accentColor.withOpacity(.9),
                        Colors.transparent,
                      ],
                    ),
                  ),
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(
                      MediaQuery.of(context).size.width * .05,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: AnimatedTextKit(
                                  totalRepeatCount: 1,
                                  animatedTexts: [
                                    TyperAnimatedText(char.name,
                                        textAlign: TextAlign.center,
                                        textStyle: TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        speed: Duration(milliseconds: 200)),
                                  ]),
                            ),
                            Text(
                              char.id,
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                color: Colors.tealAccent,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Hero(
                            tag: 'img${char.id}',
                            child: FadeImageRM(
                              link: char.imageUrl,
                              id: int.parse(char.id),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Status : ',
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                            CircleAvatar(
                              backgroundColor: char.statusColor,
                              maxRadius: 5,
                            ),
                            SizedBox(
                              width: 2,
                            ),
                            Expanded(
                              child: Text(
                                '${char.statusName}',
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          'Species : ${char.species}',
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        if (char.type.isNotEmpty)
                          Text(
                            'Type : ${char.type}',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Gender(
                              icon: FontAwesomeIcons.mars,
                              type: 'Male',
                              isIt: char.gender == 'Male',
                            ),
                            Gender(
                              icon: FontAwesomeIcons.venus,
                              type: 'Female',
                              isIt: char.gender == 'Female',
                            ),
                            Gender(
                              icon: FontAwesomeIcons.venusMars,
                              type: 'GenderLess',
                              isIt: char.gender == 'Genderless' ||
                                  char.gender == 'unknown',
                            )
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        FittedBox(
                          child: Text(
                            'Origin : ${char.originName}',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                        FittedBox(
                          child: Text(
                            'Location : ${char.locationName}',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                        Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Text(
                                'Episodes : ',
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                              ...char.episodes
                                  .map<Widget>(
                                    (e) => Text('$e '),
                                  )
                                  .toList(),
                            ]),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// class MyClip extends CustomClipper<Path> {
//   @override
//   getClip(Size size) {
//     // TODO: implement getClip
//     throw UnimplementedError();
//   }

//   @override
//   bool shouldReclip(covariant CustomClipper oldClipper) {
//     // TODO: implement shouldReclip
//     throw UnimplementedError();
//   }
// }
