import 'package:intl/intl.dart';

class Coin {
  List<String> tags;
  String name;
  String lastUpdated;
  int rank;
  double percentageChange;
  double price;
  String symbol;

  Coin(this.name, this.price, this.lastUpdated, this.percentageChange,
      this.rank, this.symbol, this.tags);

  factory Coin.fromJson(Map<String, dynamic> json) {
    List<String> tags = [];
    for (var element in (json['tags'] as List)) {
      tags.add(element);
    }
    Map<String, dynamic> usdMap = json['quote']['USD'] as Map<String, dynamic>;
    DateFormat inputFormat = DateFormat('yyyy-MM-ddTHH:mm:ss.000Z');
    DateFormat outputFormat = DateFormat('dd-MM-yyyy hh:mm a');
    return Coin(
        json['name'],
        usdMap['price'] as double,
        outputFormat
            .format(inputFormat.parse(usdMap['last_updated'] as String)),
        usdMap['percent_change_24h'],
        json['cmc_rank'],
        json['symbol'],
        tags);
  }
}
