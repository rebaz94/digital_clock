import 'package:digital_clock/src/utility/utility.dart';
import 'package:flutter/material.dart';

/// Showing current name of location
class LocationName extends StatelessWidget {
  final String name;

  const LocationName({Key key, this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      name,
      style: TextStyle(fontSize: Utility.textSize11, color: Theme.of(context).primaryColorLight),
    );
  }
}
