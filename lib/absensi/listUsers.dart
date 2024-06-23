import 'package:flutmgaji/absensi/AbsensiById.dart';
import 'package:flutmgaji/absensi/absensiPage.dart';
import 'package:flutmgaji/home/HomePage.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:flutter_dotenv/flutter_dotenv.dart';


class ListUserPegawai extends StatefulWidget {
  const ListUserPegawai({
    Key? key,
  }) : super(key: key);

  @override
  State<ListUserPegawai> createState() => _ListUserPegawaiState();
}

List _listsData = [];

class _ListUserPegawaiState extends State<ListUserPegawai> {
  Future<dynamic> listKeluhan() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      var token = preferences.getString('token');
      var url = Uri.parse('${dotenv.env['url']}/listPegawai');
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
          // print(_listsData);
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
          'List Pegawai',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
            leading: InkWell(
              onTap: () {
                Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Homepage()));
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
                  onTap: (){
                    Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AbsensiByIdPage(id: _listsData[index]['id'].toString())));
                  },
                title: Text(
                        "Nama : ${_listsData[index]['name']}\nEmail: ${_listsData[index]['email']}",
                        style: const TextStyle(
                            fontSize: 15.0, fontWeight: FontWeight.bold),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: const Text(
                        "Role: Pegawai",
                        maxLines: 3,
                        style: TextStyle(fontSize: 14.0),
                        overflow: TextOverflow.ellipsis,
                      ),
                )

              ],
            ),
          ),
        ),
      ),
    );
  }
}
