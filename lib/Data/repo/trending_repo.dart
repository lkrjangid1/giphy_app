import 'dart:convert';

import 'package:giphy_challange/Constants/strings.dart';
import 'package:giphy_challange/Data/apis.dart';
import 'package:giphy_challange/Data/models/trending_gif_model.dart';
import 'package:http/http.dart' as http;

class TrendingRepo {
  static Future<TrendingGifModel?> getTrendingGif(int limit, int offset) async {
    try {
      http.Response response = await http.get(Uri.parse(
          "${Apis.baseUrl}${Apis.trendingGifsApi}?api_key=$apiKey&limit=$limit&offset=$offset"));
      if (response.statusCode == 200) {
        return TrendingGifModel.fromJson(jsonDecode(response.body));
      } else {
        return null;
      }
    } catch (e) {
      Exception("Exception in getTrendingGif Func ${e.toString()}");
      return null;
    }
  }
}
