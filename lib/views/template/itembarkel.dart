import 'package:flutter/material.dart';

class ItemBarKel extends StatelessWidget {
  final IconData icon;
  final String title;
  final double titleFontSize;
  final String oleh;
  final String unitkerja;
  final String tgl;
  final Color? iconColor;

  const ItemBarKel({
    Key? key,
    required this.icon,
    required this.title,
    this.titleFontSize = 40.0,
    this.iconColor,
    required this.oleh,
    required this.unitkerja,
    required this.tgl,
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: titleFontSize,
                  ),
                  textAlign: TextAlign.left,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width - 170.0,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text("Oleh: "),
                      Expanded(
                        child: Text(
                          oleh,
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                              color: Colors.black54, fontSize: 14.0),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width - 170.0,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text("Unit Kerja: "),
                      Expanded(
                        child: Text(
                          unitkerja,
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                              color: Colors.black54, fontSize: 14.0),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width - 170,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text("Pada tanggal: "),
                      Expanded(
                        child: Text(
                          tgl,
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                              color: Colors.black54, fontSize: 14.0),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
