import 'package:crypto_app/coin_list/coins_data_bloc.dart';
import 'package:crypto_app/coin_list/coins_data_event.dart';
import 'package:crypto_app/coin_list/coins_data_state.dart';
import 'package:crypto_app/colors.dart';
import 'package:crypto_app/models/coin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:charts_painter/chart.dart';

///[CoinsDataScreen] to show data of searched coins in list or chart
class CoinsDataScreen extends StatefulWidget {
  final List<Coin> coins;

  const CoinsDataScreen(this.coins, {Key? key}) : super(key: key);

  @override
  State<CoinsDataScreen> createState() => _CoinsDataScreenState();
}

class _CoinsDataScreenState extends State<CoinsDataScreen> {
  CoinsDataBloc? _bloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _bloc = BlocProvider.of<CoinsDataBloc>(context);
  }

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
                BlocBuilder<CoinsDataBloc, CoinsDataState>(
                    buildWhen: (prevState, currentState) =>
                        currentState is ViewTypeChangedState,
                    builder: (context, state) {
                      ViewType currentViewType = ViewType.list;
                      if (state is ViewTypeChangedState) {
                        currentViewType = state.viewType;
                      }
                      return TextButton.icon(
                        onPressed: () =>
                            onSwitchViewButtonPressed(currentViewType),
                        icon: Image.asset(
                          currentViewType == ViewType.chart
                              ? 'images/list.png'
                              : 'images/chart.png',
                          height: 24,
                          color: yellowMaterialColor,
                        ),
                        label: Text(
                          currentViewType == ViewType.chart
                              ? 'Show List'
                              : 'Show Chart',
                          style: const TextStyle(fontSize: 16),
                        ),
                      );
                    }),
                Text(
                  'Count: ${widget.coins.length}',
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                )
              ],
            ),
            Expanded(
              child: BlocBuilder<CoinsDataBloc, CoinsDataState>(
                  buildWhen: (prevState, currentState) =>
                      currentState is ViewTypeChangedState,
                  builder: (context, state) {
                    if (state is ViewTypeChangedState) {
                      if (state.viewType == ViewType.chart) {
                        return Center(
                          child: SizedBox(
                            height: 300,
                            child: Chart(
                              state: ChartState(
                                ChartData.fromList(widget.coins
                                    .map((e) => BarValue(e.price))
                                    .toList()),
                                itemOptions: BarItemOptions(
                                    minBarWidth: 40,
                                    maxBarWidth: 60,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    radius: const BorderRadius.vertical(
                                        top: Radius.circular(8.0)),
                                    colorForValue: (color, value, [v]) {
                                      if (value! < 200) {
                                        return Colors.blue;
                                      } else if (value < 500) {
                                        return Colors.purple;
                                      } else if (value < 800) {
                                        return Colors.pink;
                                      } else if (value < 1000) {
                                        return Colors.tealAccent;
                                      } else if (value < 1300) {
                                        return Colors.yellow;
                                      } else if (value < 1500) {
                                        return Colors.blueGrey;
                                      } else if (value < 2000) {
                                        return Colors.purpleAccent;
                                      } else if (value < 2500) {
                                        return Colors.orange;
                                      } else {
                                        return Colors.deepOrange;
                                      }
                                    }),
                                backgroundDecorations: [
                                  VerticalAxisDecoration(
                                      valuesAlign: TextAlign.center,
                                      showValues: true,
                                      showLines: false,
                                      legendFontStyle: const TextStyle(
                                          color: Colors.white, fontSize: 10),
                                      valueFromIndex: (index) {
                                        return widget.coins
                                            .elementAt(index)
                                            .symbol;
                                      }),
                                  GridDecoration(
                                    showHorizontalGrid: false,
                                    showVerticalGrid: false,
                                    textStyle:
                                        const TextStyle(color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      } else {
                        return ListView.builder(
                          itemCount: widget.coins.length,
                          itemBuilder: (context, index) {
                            Coin coin = widget.coins.elementAt(index);
                            return InkWell(
                              child: ListCoinItem(coin),
                              onTap: () => onItemTapped(coin),
                            );
                          },
                        );
                      }
                    }
                    return Container();
                  }),
            ),
          ],
        ),
      ),
    );
  }

  void onSwitchViewButtonPressed(ViewType currentViewType) {
    _bloc?.add(ChangeViewTypeEvent(currentViewType));
  }

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
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.all(8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    coin.name,
                    style: const TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                const Text(
                  'Tags',
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 8,
                ),
                SizedBox(
                  height: 24,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    children: coin.tags
                        .map(
                          (e) => Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            padding: const EdgeInsets.symmetric(
                                vertical: 4, horizontal: 16),
                            decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(4)),
                            child: Text(e),
                          ),
                        )
                        .toList(),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                const Text(
                  'Price Last Updated',
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  coin.lastUpdated,
                  style: const TextStyle(
                      fontSize: 16,
                      color: Colors.green,
                      fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 32,
                ),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('CLOSE'))
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
                    '${coin.percentageChange.abs().toStringAsFixed(2)}%',
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
                  'Price: \$${coin.price.toStringAsFixed(2)}',
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

///Constants for view type
enum ViewType { list, chart }
