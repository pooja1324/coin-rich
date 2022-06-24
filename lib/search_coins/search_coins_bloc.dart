import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:crypto_app/api_calls.dart';
import 'package:crypto_app/models/coin.dart';
import 'package:crypto_app/search_coins/search_coins_event.dart';
import 'package:crypto_app/search_coins/search_coins_state.dart';

class SearchCoinsBloc extends Bloc<SearchCoinsEvent, SearchCoinsState> {
  SearchCoinsBloc() : super(IdleState()) {
    on<SearchButtonTapEvent>((event, emit) async {
      if(event.coins.isEmpty){
        emit(CoinSearchFailedState('Please enter coins symbols to search'));
        emit(IdleState());
        return;
      }
      emit(CoinsSearchingState());
      try {
        String response = await ApiCalls.searchCoins(event.coins);
        Map<String, dynamic> parsedResponse = json.decode(response);
        if (parsedResponse['status']['error_code'] == 0) {
          Map<String, dynamic> dataMap=parsedResponse['data'];
          List<Coin> coins=[];
          dataMap.forEach((key, value) {
            coins.add(Coin.fromJson(value as Map<String, dynamic>));
          });
          emit(CoinsSearchedState(coins));

        } else {
          emit(
              CoinSearchFailedState(parsedResponse['status']['error_message']));
        }
      } catch (e) {
        emit(CoinSearchFailedState(e.toString()));
      }
      emit(IdleState());

    });
  }
}
