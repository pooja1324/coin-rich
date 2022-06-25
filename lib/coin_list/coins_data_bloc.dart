import 'package:bloc/bloc.dart';
import 'package:crypto_app/coin_list/coins_data_event.dart';
import 'package:crypto_app/coin_list/coins_data_screen.dart';
import 'package:crypto_app/coin_list/coins_data_state.dart';

class CoinsDataBloc extends Bloc<CoinsDataEvent, CoinsDataState> {
  CoinsDataBloc() : super(ViewTypeChangedState(ViewType.list)) {
    on<ChangeViewTypeEvent>((event, emit) {
      emit(ViewTypeChangedState(event.viewType==ViewType.chart?ViewType.list:ViewType.chart));
      emit(IdleState());
    });
  }
}
