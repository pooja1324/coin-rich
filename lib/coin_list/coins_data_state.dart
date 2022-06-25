import 'package:crypto_app/coin_list/coins_data_event.dart';
import 'package:crypto_app/coin_list/coins_data_screen.dart';
import 'package:equatable/equatable.dart';

abstract class CoinsDataState extends Equatable {
  @override
  List<Object> get props => [];
}
class IdleState extends CoinsDataState {}

///[ViewTypeChangedState] is generated when [ChangeViewTypeEvent] is triggered
/// [viewType] gives new view.
class ViewTypeChangedState extends CoinsDataState{
  final ViewType viewType;
  ViewTypeChangedState(this.viewType);
}
