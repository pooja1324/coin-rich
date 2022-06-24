import 'package:crypto_app/colors.dart';
import 'package:crypto_app/models/coin.dart';
import 'package:flutter/material.dart';

class CoinsListScreen extends StatefulWidget {
  final List<Coin> coins;

  const CoinsListScreen(this.coins, {Key? key}) : super(key: key);

  @override
  State<CoinsListScreen> createState() => _CoinsListScreenState();
}

class _CoinsListScreenState extends State<CoinsListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'CoinRich',
          style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton.icon(
                  onPressed: onSwitchViewButtonPressed,
                  icon: Image.asset(
                    'images/chart.png',
                    height: 24,
                    color: yellowMaterialColor,
                  ),
                  label: const Text(
                    'Show Chart',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                Text(
                  'Count: ${widget.coins.length}',
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                )
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: widget.coins.length,
                itemBuilder: (context, index) {
                  Coin coin = widget.coins.elementAt(index);
                  return InkWell(
                    child: ListCoinItem(coin),
                    onTap: () => onItemTapped(coin),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onSwitchViewButtonPressed() {}

  void onItemTapped(Coin coin) {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
            ),
            padding: EdgeInsets.all(16),
            margin: EdgeInsets.all(8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    coin.name,
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Text(
                  'Tags',
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 8,
                ),
                SizedBox(
                  height: 24,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    children: coin.tags.map(
                      (e) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4 ),
                        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                        decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(4)),
                        child: Text(e),
                      ),
                    ).toList(),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Text(
                  'Price Last Updated',
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                 coin.lastUpdated,
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.green,
                      fontWeight: FontWeight.w600),
                ), SizedBox(
                  height: 32,
                ),
                ElevatedButton(onPressed: (){
                  Navigator.pop(context);
                }, child: Text('CLOSE'))
              ],
            ),
          );
        });
  }
}

class ListCoinItem extends StatelessWidget {
  final Coin coin;

  const ListCoinItem(this.coin, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    coin.name,
                    style: TextStyle(
                        fontSize: 20,
                        color: yellowMaterialColor,
                        fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(
                    width: 24,
                  ),
                  Icon(
                    coin.percentageChange < 0
                        ? Icons.arrow_downward
                        : Icons.arrow_upward,
                    color:
                        coin.percentageChange < 0 ? Colors.red : Colors.green,
                  ),
                  Text(
                    '${coin.percentageChange.toStringAsPrecision(3)}%',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(5)),
                child: Text(
                  coin.symbol,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
          const SizedBox(
            height: 12,
          ),
          Row(
            children: [
              Flexible(
                child: Text(
                  'Price: \$${coin.price.toStringAsPrecision(3)}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
                flex: 2,
                fit: FlexFit.tight,
              ),
              Flexible(
                child: Text(
                  'Rank: ${coin.rank}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
                flex: 2,
                fit: FlexFit.tight,
              ),
              Flexible(
                child: Align(
                  child: Container(
                    height: 36,
                    width: 36,
                    child: const Icon(
                      Icons.arrow_forward,
                      color: Colors.black,
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        color: yellowMaterialColor),
                  ),
                  alignment: Alignment.centerRight,
                ),
                flex: 2,
                fit: FlexFit.tight,
              )
            ],
          ),
        ],
      ),
    );
  }
}
