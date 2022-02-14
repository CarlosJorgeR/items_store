import 'package:flutter/material.dart';
import 'package:price_calculator/src/models/item.dart';

class TableWidget extends StatefulWidget {
  final List<Sale> sales;
  final Widget Function(Sale sale) getPurchaseContainerWidget;
  final Widget Function(Sale sale, double opacity, int position)
      getPurchaseInfoWidget;
  final double Function(Sale sale) opcityFunc;
  TableWidget(
    this.sales,
    this.opcityFunc,
    this.getPurchaseContainerWidget,
    this.getPurchaseInfoWidget, {
    Key? key,
  }) : super(key: key);

  @override
  State<TableWidget> createState() => _TableWidgetState();
}

class _TableWidgetState extends State<TableWidget> {
  @override
  Widget build(BuildContext context) {
    return getTable(context, widget.sales);
  }

  TextStyle itemNameStyle(Sale sale) => TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.bold,
        color: Colors.black.withOpacity(widget.opcityFunc(sale)),
      );

  Widget getTable<T extends Sale>(BuildContext context, List<T> _items) {
    List<TableRow> rows = [];
    final rowNumber = (_items.length / 2).ceil();
    for (var i = 0; i < rowNumber; i++) {
      TableRow row = TableRow(
        children: [
          getPurchaseContainer(context, _items[i * 2], i * 2),
          (i * 2 + 1 < _items.length)
              ? getPurchaseContainer(context, _items[i * 2 + 1], i * 2 + 1)
              : Container()
        ],
      );
      rows.add(row);
    }
    // AnimatedT
    return Table(
      children: rows,
    );
  }

  Widget getPurchaseContainer(
      BuildContext context, Sale purchase, int position) {
    final appHeight = MediaQuery.of(context).size.height;
    final purchaseBoxHeight = (appHeight / 4);
    final paddingSize = (purchaseBoxHeight / 15);

    return Container(
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Colors.black26,
              blurRadius: 10.0,
              spreadRadius: 2.0,
              offset: Offset(2.0, 10.0))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: purchaseBoxHeight,
            padding: EdgeInsets.symmetric(
                horizontal: paddingSize, vertical: paddingSize),
            child: getPurchaseInfo(context, purchase, position),
          ),
          widget.getPurchaseContainerWidget(purchase),
        ],
      ),
    );
  }

  Widget getPurchaseInfo(BuildContext context, Sale purchase, int position) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 6,
          child: getPurchaseImage(context, purchase),
        ),
        Expanded(
          flex: 2,
          child: getPurchaseNameText(context, purchase),
        ),
        Expanded(
          flex: 1,
          child: Container(),
        ),
        widget.getPurchaseInfoWidget(
            purchase, widget.opcityFunc(purchase), position),
      ],
    );
  }

  Widget getPurchaseImage(BuildContext context, Sale sale) {
    return Row(
      children: [
        //expando la imagen al másimo en la fila
        Expanded(
          child: Image(
            image: AssetImage(
              'images/not-image.png',
            ),
            fit: BoxFit.fill,
            color: Colors.white.withOpacity(widget.opcityFunc(sale)),
            colorBlendMode: BlendMode.modulate,
          ),
        ),
      ],
    );
  }

  Container getPurchaseNameText(BuildContext context, Sale purchase) {
    return Container(
      child: Text(
        purchase.item.name,
        style: itemNameStyle(purchase),
      ),
    );
  }
}
