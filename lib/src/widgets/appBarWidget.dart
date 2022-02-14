import 'package:flutter/material.dart';
import 'package:price_calculator/src/bloc/purchaseBloc.dart';
import 'package:price_calculator/src/models/item.dart';
import 'package:price_calculator/src/search/search_delegate.dart';
import 'package:price_calculator/src/theme/style.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  final String titleText;
  List<Widget>? actions;
  IconThemeData? iconThemeData;
  Widget Function(List<Sale>) func;
  @override
  final Size preferredSize;
  CustomAppBar(this.titleText, this.func,
      {Key? key, this.actions, this.iconThemeData})
      : preferredSize = Size.fromHeight(50.0),
        super(key: key);
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(titleText),
      centerTitle: true,
      backgroundColor: appBarbackgroundColor,
      actions: (actions ?? <Widget>[]) + [getSearch(context)],
      actionsIconTheme: iconThemeData,
    );
  }

  Widget getSearch(BuildContext context) {
    return IconButton(
      autofocus: true,
      onPressed: () {
        showSearch(context: context, delegate: DataSearch(func));
      },
      icon: Icon(Icons.search),
    );
  }
}
