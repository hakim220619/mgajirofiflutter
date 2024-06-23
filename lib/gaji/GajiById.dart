import 'package:flutmgaji/gaji/ListUserGaji.dart';
import 'package:flutmgaji/home/HomePage.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:url_launcher/url_launcher.dart';

class GajiById extends StatefulWidget {
  final String id;
  const GajiById({
    required this.id,
    Key? key,
  }) : super(key: key);

  @override
  State<GajiById> createState() => _GajiByIdState();
}

List _listsData = [];

class _GajiByIdState extends State<GajiById> {
  Future<dynamic> listKeluhan() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      var token = preferences.getString('token');
      var url = Uri.parse('${dotenv.env['url']}/ListGajiById/${widget.id}');
      final response = await http.get(url, headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      });
      // print(response.body);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // print(data);
        setState(() {
          _listsData = data['data'];
          print(_listsData);
        });
      }
    } catch (e) {
      // print(e);
    }
  }

  // Sample data for three lists
  @override
  void initState() {
    super.initState();
    listKeluhan();
  }

  Future refresh() async {
    setState(() {
      listKeluhan();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'List Gaji',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        leading: InkWell(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const ListUserGaji()));
          },
          child: const Icon(
            Icons.arrow_back_ios,
            color: Color.fromARGB(253, 255, 252, 252),
          ),
        ),
        backgroundColor: Colors.blue[300],
      ),
      body: RefreshIndicator(
        onRefresh: refresh,
        child: ListView.builder(
          itemCount: _listsData.length,
          itemBuilder: (context, index) => Card(
            margin: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                ListTile(
                  title: Text(
                    "Nama : ${_listsData[index]['nama']}",
                    style: const TextStyle(
                        fontSize: 15.0, fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                          "Tahun : ${_listsData[index]['tahun']}\nBulan: ${_listsData[index]['bulan']}",
                          style: const TextStyle(fontSize: 14)),
                      Text(
                          "Jumlah absen: ${_listsData[index]['totalAbsen']}\nTotal Gaji: ${_listsData[index]['totalGaji']}",
                          style: const TextStyle(fontSize: 14))
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () async {
      //     // print('asd');
      //     SharedPreferences preferences = await SharedPreferences.getInstance();
      //     var token = preferences.getString('token');
      //     var url = Uri.parse('${dotenv.env['url']}/getGajiById');
      //     final response = await http.get(url, headers: {
      //       "Accept": "application/json",
      //       "Authorization": "Bearer $token",
      //     });
      //     // print(response.body);
      //     if (response.statusCode == 200) {
      //       final data = jsonDecode(response.body);
      //       // print(data);
      //       setState(() async {
      //         String url = data['file'];
      //         var urllaunchable =
      //             await canLaunch(url); //canLaunch is from url_launcher package
      //         if (urllaunchable) {
      //           await launch(
      //               url); //launch is from url_launcher package to launch URL
      //         } else {
      //           print("URL can't be launched.");
      //         }
      //       });
      //     }
      //   },
      //   tooltip: 'Increment',
      //   child: Icon(Icons.download_for_offline_outlined),
      // ), // This tra
    );
  }
}
