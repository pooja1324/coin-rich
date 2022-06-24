import 'package:crypto_app/models/coin.dart';
import 'package:equatable/equatable.dart';

abstract class SearchCoinsState extends Equatable {
  @override
  List<Object> get props => [];
}

class IdleState extends SearchCoinsState {}

///[CoinSearchFailedState] is generated when API data fetch fails with any reason
///[reason] describes the reason of failure
class CoinSearchFailedState extends SearchCoinsState {
  final String reason;
  CoinSearchFailedState(this.reason);
}

///[CoinsSearchedState] is generated when API data returns and parsed successfully
///[coins] is list of searched coins
class CoinsSearchedState extends SearchCoinsState {
  final List<Coin> coins;
  CoinsSearchedState(this.coins);
}

///[CoinsSearchingState] generated when [SearchButtonTapEvent] is triggered
///and API data starts fetching
class CoinsSearchingState extends SearchCoinsState{}