import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:iconsax/iconsax.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  int _index = 0;

  List<Widget> body = const [
    Icon(Iconsax.timer),
    Icon(Iconsax.timer4),
    Icon(Iconsax.timer5),
  ];
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
