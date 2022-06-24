import 'package:crypto_app/coin_list/coins_list_screen.dart';
import 'package:crypto_app/colors.dart';
import 'package:crypto_app/search_coins/search_coins_bloc.dart';
import 'package:crypto_app/search_coins/search_coins_event.dart';
import 'package:crypto_app/search_coins/search_coins_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchCoinsScreen extends StatefulWidget {
  const SearchCoinsScreen({Key? key}) : super(key: key);

  @override
  State<SearchCoinsScreen> createState() => _SearchCoinsState();
}

class _SearchCoinsState extends State<SearchCoinsScreen> {
  final TextEditingController _searchController = TextEditingController();
  SearchCoinsBloc? _bloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _bloc = BlocProvider.of<SearchCoinsBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SearchCoinsBloc, SearchCoinsState>(
      listener: (context, state) {
        if (state is CoinsSearchedState) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CoinsListScreen(state.coins)));
        } else if (state is CoinSearchFailedState) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(state.reason),
            backgroundColor: Colors.black,
          ));
        }
      },
      child: Scaffold(
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
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _searchController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.black,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Colors.grey,
                  ),
                  hintText: 'Enter Coin Symbol',
                  hintStyle: const TextStyle(color: Colors.grey),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: onSearchButtonTapped,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Expanded(
                        child: Center(
                          child: Text(
                            'SEARCH',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      BlocBuilder<SearchCoinsBloc, SearchCoinsState>(
                          buildWhen: (prevState, currentState) =>
                              currentState is CoinsSearchingState ||
                              currentState is CoinsSearchedState ||
                              currentState is CoinSearchFailedState,
                          builder: (context, state) {
                            if (state is CoinsSearchingState) {
                              return const SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.black,
                                    strokeWidth: 2,
                                  ));
                            }
                            return const Icon(
                              Icons.arrow_circle_right_outlined,
                              size: 30,
                            );
                          }),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onSearchButtonTapped() {
    _bloc?.add(SearchButtonTapEvent(_searchController.text));
  }
}
