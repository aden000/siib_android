import 'package:flutter/material.dart';

class DashboardMenu extends StatelessWidget {
  final IconData icon;
  final String title;
  final double titleFontSize;
  final String subtitle;
  final double subtitleFontSize;
  final Color? iconColor;

  const DashboardMenu({
    Key? key,
    required this.icon,
    required this.title,
    this.titleFontSize = 40.0,
    required this.subtitle,
    this.subtitleFontSize = 14.0,
    this.iconColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(5.0),
      child: Row(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.all(25.0),
            child: Icon(
              icon,
              color: iconColor ?? Colors.black54,
              size: 40.0,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
            child: SizedBox(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    overflow: TextOverflow.fade,
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: titleFontSize,
                    ),
                  ),
                  Text(
                    subtitle,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: subtitleFontSize,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
