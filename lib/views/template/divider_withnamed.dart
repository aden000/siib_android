import 'package:flutter/material.dart';

class DividerWithNamed extends StatelessWidget {
  final String name;
  const DividerWithNamed({Key? key, required this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
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
