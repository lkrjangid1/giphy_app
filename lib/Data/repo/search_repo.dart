import 'dart:convert';

import 'package:giphy_challange/Constants/strings.dart';
import 'package:giphy_challange/Data/apis.dart';
import 'package:giphy_challange/Data/models/search_gif_model.dart';
import 'package:http/http.dart' as http;

class SearchRepo {
  static Future<SearchGifModel?> searchGif(
      String q, int limit, int offset) async {
    try {
      http.Response response = await http.get(Uri.parse(
          "${Apis.baseUrl}${Apis.searchGifsApi}?api_key=$apiKey&q=$q&limit=$limit&offset=$offset"));
      if (response.statusCode == 200) {
        return SearchGifModel.fromJson(jsonDecode(response.body));
      } else {
        return null;
      }
    } catch (e) {
      Exception("Exception in searchGif Func ${e.toString()}");
      return null;
    }
  }
}
