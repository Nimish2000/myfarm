import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class historyScreen extends StatefulWidget {
  const historyScreen({Key? key}) : super(key: key);

  @override
  State<historyScreen> createState() => _historyScreenState();
}

class _historyScreenState extends State<historyScreen> {
  final _firestore = FirebaseFirestore.instance;

  Widget historyData(var temp, var hum, var size, var date) {
    var x = temp.toString().substring(0, 4);
    var d = date.toString().substring(9, date.toString().length);
    var t = date.toString().substring(0, 5);
    return Card(
      child: ListTile(
        leading: Icon(Icons.list),
        title: Text("Time : $t , Date : $d"),
        subtitle: Text("Temp : $x °C, humidity : $hum %"),
        trailing: Icon(Icons.info),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text("History"),
      ),
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
            stream: _firestore.collection('sensor_data').snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return CircularProgressIndicator();
              }
              final messages = snapshot.data!.docs;
              List<Widget> temp = [];
              for (var message in messages) {
                var tempVal = message['temp'];
                var humd = message['humd'];
                var date = message['timestamp'];

                final d1 = historyData(tempVal, humd, size, date);
                temp.add(d1);
              }
              return ListView(
                children: temp,
              );
            }),
      ),
    );
  }
}
