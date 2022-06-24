import 'dart:io';
import 'package:http/http.dart' as http;

class ApiCalls {
  static Future<String> searchCoins(String coins) async {
    try {
      var response = await http.get(
          Uri.parse(
              'https://pro-api.coinmarketcap.com/v1/cryptocurrency/quotes/latest?symbol=$coins'),
          headers: {
            'X-CMC_PRO_API_KEY': '27ab17d1-215f-49e5-9ca4-afd48810c149'
          });
      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw 'Something went wrong';
      }
    } on SocketException catch (e) {
      throw 'No Internet Connection';
    }
  }
}
