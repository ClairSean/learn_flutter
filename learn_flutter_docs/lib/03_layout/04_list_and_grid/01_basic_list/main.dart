import 'package:flutter/material.dart';

void main(List<String> args) {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const String title = 'Basic List';

    return MaterialApp(
      title: title,
      home: Scaffold(
        appBar: AppBar(title: const Text(title)),
        //简单的列表
        body: ListView(
          children: const <Widget>[
            //用ListTile构建列表项
            ListTile(leading: Icon(Icons.map), title: Text("Map")),
            ListTile(leading: Icon(Icons.photo_album), title: Text("Album")),
            ListTile(leading: Icon(Icons.phone), title: Text("Phone")),
            ListTile(leading: Icon(Icons.alarm), title: Text("Alarm")),
            ListTile(
              leading: Icon(Icons.add_home_work),
              title: Text("Homework"),
            ),
            ListTile(
              leading: Icon(Icons.airplanemode_on),
              title: Text("Airplane"),
            ),
            ListTile(leading: Icon(Icons.contact_page), title: Text("Contact")),
            ListTile(leading: Icon(Icons.gps_fixed), title: Text("GPS")),
            ListTile(leading: Icon(Icons.join_full), title: Text("Join")),
            ListTile(leading: Icon(Icons.mic), title: Text("Mic")),
            ListTile(leading: Icon(Icons.zoom_in), title: Text("Zoom")),
            ListTile(leading: Icon(Icons.tiktok), title: Text("TikTok")),
            ListTile(leading: Icon(Icons.map), title: Text("Map")),
            ListTile(leading: Icon(Icons.photo_album), title: Text("Album")),
            ListTile(leading: Icon(Icons.phone), title: Text("Phone")),
            ListTile(leading: Icon(Icons.alarm), title: Text("Alarm")),
            ListTile(
              leading: Icon(Icons.add_home_work),
              title: Text("Homework"),
            ),
            ListTile(
              leading: Icon(Icons.airplanemode_on),
              title: Text("Airplane"),
            ),
            ListTile(leading: Icon(Icons.contact_page), title: Text("Contact")),
            ListTile(leading: Icon(Icons.gps_fixed), title: Text("GPS")),
            ListTile(leading: Icon(Icons.join_full), title: Text("Join")),
            ListTile(leading: Icon(Icons.mic), title: Text("Mic")),
            ListTile(leading: Icon(Icons.zoom_in), title: Text("Zoom")),
            ListTile(leading: Icon(Icons.tiktok), title: Text("TikTok")),
          ],
        ),
      ),
    );
  }
}
