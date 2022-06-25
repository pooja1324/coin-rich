import 'package:crypto_app/coin_list/coins_data_screen.dart';
import 'package:equatable/equatable.dart';

class CoinsDataEvent extends Equatable {
  @override
  List<Object> get props => [];
}

///[ChangeViewTypeEvent] is triggered when view is switched between list and chart
class ChangeViewTypeEvent extends CoinsDataEvent{
  final ViewType viewType;
  ChangeViewTypeEvent(this.viewType);
}