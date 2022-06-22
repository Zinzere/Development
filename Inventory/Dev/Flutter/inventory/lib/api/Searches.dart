import 'package:flutter/material.dart';
import '../ui/Search.dart';
import 'Calls.dart';

class ClientSearch extends StatelessWidget {
  ClientSearch(this.control,{@required this.onSelected});
  final TextEditingController control;
  final Function(dynamic) onSelected;

  @override
  Widget build(BuildContext context) {
    return Search(
      displayList: ["ITEM_NM"],
      futureOrList: (pattern) async {
        List retunList = [];
        List result = await Calls.getProducts({"ITEM_NM": pattern});
        for (int i = 0; i < result.length; i++) {
            retunList.add(result[i]);
        }
        return retunList;
      },
      controller: control,
      hintText: "Products",
      onChanged: onSelected,
    );
  }
}
