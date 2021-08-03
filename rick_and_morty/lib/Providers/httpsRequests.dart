import 'dart:convert' show jsonDecode;

import 'package:http/http.dart' as http show get;
import 'package:rick_and_morty/Providers/handling_data.dart';

class HttpHelper {
  static Future<Map<String, dynamic>> apiGetter(
      int pageNum, TypeRM type) async {
    final data = await http.get(
      Uri.parse(
          'https://rickandmortyapi.com/api/${type == TypeRM.characters ? 'character' : 'episode'}/?page=$pageNum'),
    );

    return (jsonDecode(data.body) as Map<String, dynamic>);
  }
}
