import 'package:flutter/material.dart';

class DividerWithNamed extends StatelessWidget {
  final String name;
  final double paddingLeft;
  final double paddingRight;
  const DividerWithNamed({
    Key? key,
    required this.name,
    this.paddingLeft = 20.0,
    this.paddingRight = 20.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: paddingLeft,
        right: paddingRight,
      ),
      child: Row(
        children: [
          Text(
            name,
            style: const TextStyle(fontSize: 13.0, color: Colors.black45),
          ),
          const Expanded(
              child: Divider(
            color: Colors.black45,
          ))
        ],
      ),
    );
  }
}
