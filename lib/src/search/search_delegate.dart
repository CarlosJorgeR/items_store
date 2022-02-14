import 'package:flutter/material.dart';
import 'package:price_calculator/src/bloc/purchaseBloc.dart';
import 'package:price_calculator/src/models/item.dart';

class DataSearch extends SearchDelegate {
  String selection = '';
  Widget Function(List<Sale>) func;
  DataSearch(this.func);

  final purchaseBloc = PurchaseBloc();
  @override
  List<Widget> buildActions(BuildContext context) {
    // TODO: actions of appbar
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: Icon(Icons.clear),
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // TODO: left widget od appbar
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: results of search
    return Text(selection);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    purchaseBloc.getAllItems();
    return StreamBuilder<SaleState>(
        stream: purchaseBloc.purchaseStream,
        builder: (context, snapshot) {
          final sugestedList = (snapshot.data?.items ?? [])
              .where((item) =>
                  item.name.toLowerCase().startsWith(query.toLowerCase()))
              .toList();
          return func(sugestedList);
        });
  }
}
