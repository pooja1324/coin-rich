import 'package:equatable/equatable.dart';

abstract class SearchCoinsEvent extends Equatable {
  @override
  List<Object> get props => [];
}

///[SearchButtonTapEvent] is triggered when search button is tapped
///[coins] is passed which is entered by user
class SearchButtonTapEvent extends SearchCoinsEvent{
  final String coins;
  SearchButtonTapEvent(this.coins);
}