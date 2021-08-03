import 'package:flutter/material.dart';
import 'package:rick_and_morty/Providers/models.dart';
import 'httpsRequests.dart';

enum TypeRM {
  characters,
  episodes,
}

class DataHandler with ChangeNotifier {
  TypeRM _type = TypeRM.episodes;
  int _index = 1;
  Future<Map<String, dynamic>> get characters async {
    final tempMap = await HttpHelper.apiGetter(_index, _type);

    final int pages = tempMap['info']['pages'];
    
    Map<String, dynamic> map;
    if (_type == TypeRM.characters) {
      List<Character> chars =
          (tempMap['results']).map<Character>((e) => Character(e)).toList();
      map = {'pagesNum': pages, 'data': chars};
    }
    else {
      List<Episode> episodes =
          (tempMap['results']).map<Episode>((e) => Episode(e)).toList();
      map = {'pagesNum': pages, 'data': episodes};
    }
    return map;
  }

  bool typeGetter(TypeRM type) => _type == type;
  void typeSetter(bool isCharacters) {
    if ((_type == TypeRM.characters && isCharacters) ||
        (_type == TypeRM.episodes && !isCharacters)) return;
    _type = isCharacters ? TypeRM.characters : TypeRM.episodes;
    _index=1;
    notifyListeners();
  }

  void incrementIndex() {
    _index++;
    notifyListeners();
  }

  void decrementIndex() {
    _index--;
    notifyListeners();
  }

  int get index => _index;
}
