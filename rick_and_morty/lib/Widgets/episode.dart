import 'package:flutter/material.dart';
import 'package:rick_and_morty/Providers/models.dart';
import 'package:url_launcher/url_launcher.dart';

class EpisodeWidget extends StatelessWidget {
  final Episode episode;
  EpisodeWidget(this.episode);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: ()=>launch(episode.egybestEpisodeLink),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
        child: GridTile(
          child: Image.asset(
            episode.imagePath,
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
          ),
          footer: Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Theme.of(context).accentColor.withOpacity(.8),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: FittedBox(
                    child: Text(
                      episode.name,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(episode.airDate),
                    Text(
                      episode.episode,
                      style: TextStyle(color: Colors.white70, fontSize: 10),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
