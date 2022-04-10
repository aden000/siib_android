import 'package:flutter/material.dart';

class MenuCard extends StatelessWidget {
  final IconData icon;
  final String name;
  final String route;

  const MenuCard({
    Key? key,
    required this.icon,
    required this.name,
    this.route = '',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (route.isNotEmpty) Navigator.pushNamed(context, route);
      },
      child: Card(
        margin: const EdgeInsets.all(5.0),
        child: Row(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.all(15.0),
              child: Icon(
                icon,
                size: 40.0,
              ),
            ),
            Expanded(
              child: Text(
                name,
                overflow: TextOverflow.fade,
                style: const TextStyle(
                  fontSize: 20.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
