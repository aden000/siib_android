import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:siib_android/connection/connection.dart';
import 'package:siib_android/views/component/sidebar.dart';
import 'package:siib_android/views/template/dashboard_card.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      drawer: const Sidebar(),
      appBar: AppBar(
        backgroundColor: Colors.blue[400],
        // leading: const Icon(Icons.home),
        title: const Text('SIIB | Dashboard'),
        // actions: [
        //   IconButton(
        //     onPressed: () {
        //       logoutFunc(context);
        //     },
        //     icon: const Icon(
        //       Icons.logout,
        //       semanticLabel: 'Logout',
        //     ),
        //   )
        // ],
      ),
      body: FutureBuilder(
          future: getDashboardData(context),
          builder: (
            BuildContext bc,
            AsyncSnapshot<Map<String, dynamic>> snapshot,
          ) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData &&
                  snapshot.data!['dashboard_data'] != null) {
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 20.0, right: 20.0, top: 20.0),
                    child: Column(
                      children: [
                        DashboardMenu(
                          icon: FontAwesomeIcons.box,
                          iconColor: Colors.lightBlue[400],
                          title: snapshot.data!['dashboard_data']['countBarang']
                              .toString(),
                          subtitle: 'Banyaknya barang yang tercatat di sistem',
                        ),
                        DashboardMenu(
                          icon: Icons.archive_outlined,
                          iconColor: Colors.green[400],
                          title: snapshot.data!['dashboard_data']
                                  ['countBarangMasuk']
                              .toString(),
                          subtitle: 'Banyaknya terjadi barang masuk',
                        ),
                        DashboardMenu(
                          icon: Icons.unarchive_outlined,
                          iconColor: Colors.red[400],
                          title: snapshot.data!['dashboard_data']
                                  ['countBarangKeluar']
                              .toString(),
                          subtitle: 'Banyaknya terjadi barang keluar',
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                return Column(
                  children: const [
                    DashboardMenu(
                      icon: Icons.list_rounded,
                      title: ':(',
                      subtitle: 'Tidak mendapat data..., mohon login',
                    ),
                  ],
                );
              }
            } else {
              return Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircularProgressIndicator(),
                    Container(
                      margin: const EdgeInsets.only(left: 7.0),
                      child: const Text("Loading..."),
                    ),
                  ],
                ),
              );
            }
          }),
    );
  }
}
