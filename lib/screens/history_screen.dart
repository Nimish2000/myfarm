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
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        height: size.height * 0.15,
        width: size.width,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Colors.black,
            style: BorderStyle.solid,
            width: 3.0,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(12.0),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Temprature : $temp °C",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                  Text(
                    "Humidity : $hum %",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                  Text(
                    "Timestamp : $date",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(right: 25.0),
                child: Icon(
                  Icons.health_and_safety,
                  size: 40.0,
                ),
              ),
            ],
          ),
        ),
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

                final d1 = historyData(tempVal, humd, size,date);
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
