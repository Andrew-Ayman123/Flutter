import 'package:flutter/material.dart';

enum Status { alive, dead, unknown }

class Character {
  String id;
  String name;
  Status status;
  String species;
  String type;
  String gender;
  DateTime created;
  String imageUrl;
  String locationName;
  String originName;
  List<int> episodes;
  Character(Map<String, dynamic> map) {
    id = map['id'].toString();
    name = map['name'];
    status = map['status'] == 'Alive'
        ? Status.alive
        : map['status'] == 'Dead'
            ? Status.dead
            : Status.unknown;
    species = map['species'];
    type = map['type'];
    gender = map['gender'];
    created = DateTime.parse(map['created']);
    imageUrl = map['image'];
    locationName = map['location']['name'];
    originName = map['origin']['name'];
    episodes = map['episode']
        .map<int>(
          (e) => int.parse(
            e.substring(e.lastIndexOf('/') + 1),
          ),
        )
        .toList();
  }
  String get statusName {
    if (status == Status.alive)
      return 'Alive';
    else if (status == Status.dead)
      return 'Dead';
    else if (status == Status.unknown)
      return 'Unkown';
    else
      return 'Error';
  }

  Color get statusColor {
    if (status == Status.alive)
      return Colors.greenAccent;
    else if (status == Status.dead)
      return Colors.redAccent;
    else if (status == Status.unknown)
      return Colors.yellowAccent;
    else
      return Colors.pink;
  }
}

class Episode {
  String id;
  String name;
  String airDate;
  String episode;
  String egybestEpisodeLink;
  Episode(Map<String, dynamic> map) {
    id = map['id'].toString();
    name = map['name'];
    airDate = map['air_date'];
    episode = map['episode'];
    egybestEpisodeLink =
        'https://riko.egybest.ooo/episode/rick-and-morty-${map['episode']}';
    egybestEpisodeLink=egybestEpisodeLink.replaceAll('S0', 'season-');
    egybestEpisodeLink=egybestEpisodeLink.replaceAll('E', '-ep-');
  }
  String get imagePath {
    int season = int.parse(episode.substring(1, 3));
    String path = '';
    switch (season) {
      case 1:
      path='lib/assets/Season 1.jpg';
        break;
      case 2:
      path='lib/assets/Season 2.jpg';
        break;
      case 3:
      path='lib/assets/Season3.png';
        break;
      case 4:
      path='lib/assets/Season 4.jpg';
        break;  
      default:
      path='lib/assets/Season 4.jpg';
    }
    return path;
  }
}
