import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
// ignore: depend_on_referenced_packages
import 'package:iconsax/iconsax.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
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
