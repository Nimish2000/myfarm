import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'history_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_screen.dart';

class dashboardScreen extends StatefulWidget {
  const dashboardScreen({Key? key}) : super(key: key);

  @override
  State<dashboardScreen> createState() => _dashboardScreenState();
}

class _dashboardScreenState extends State<dashboardScreen> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  final databaseReference = FirebaseDatabase.instance.ref();
  bool switchController = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: [
          IconButton(
              tooltip: "logout",
              icon: Icon(
                Icons.logout,
                color: Colors.white,
              ),
              onPressed: () async {
                try {
                  await _auth.signOut();
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => loginScreen()));
                } catch (e) {
                  print("Some error occured");
                }
              })
        ],
        backgroundColor: Colors.teal,
        title: Text("Dashboard"),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
            child: Center(
              child: Text(
                "Live Data",
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  fontSize: 32.0,
                ),
              ),
            ),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: _firestore.collection('live_data').snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Text("Loading");
              }
              if (!snapshot.hasData) {
                return CircularProgressIndicator();
              }

              final messages = snapshot.data!.docs;
              List<Widget> temp = [];
              for (var message in messages) {
                var tempVal = message['temp'];
                var humd = message['humd'];

                final textWidget1 = Text(
                  "Temperature : $tempVal C",
                  style: TextStyle(
                    fontSize: 26.0,
                  ),
                );
                final textWidget3 = SizedBox(
                  height: 10.0,
                );
                temp.add(textWidget1);
                temp.add(textWidget3);
                final textWidget2 = Text(
                  "Humidity : $humd %",
                  style: TextStyle(
                    fontSize: 26.0,
                  ),
                );
                temp.add(textWidget2);
              }
              return Column(
                children: temp,
              );
            },
          ),
          SizedBox(
            height: 16.0,
          ),
          Container(
            height: 0.8,
            color: Colors.black26,
            width: double.infinity,
          ),
          SizedBox(
            height: 40.0,
          ),
          Text(
            "Pump controller",
            style: TextStyle(
              decoration: TextDecoration.underline,
              fontSize: 30.0,
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                "Pump status : ",
                style: TextStyle(
                  fontSize: 26.0,
                ),
              ),
              Switch(
                value: switchController,
                onChanged: (v) async {
                  setState(() {
                    switchController = !switchController;
                  });
                  if (v) {
                    await FirebaseDatabase.instance
                        .reference()
                        .child('test')
                        .update({
                          "status": 1,
                        })
                        .then((value) => print("Completed"))
                        .catchError((_) {
                          print('Not able to do');
                        });
                  } else {
                    await FirebaseDatabase.instance
                        .reference()
                        .child('test')
                        .update({
                          "status": 0,
                        })
                        .then((value) => print("Completed"))
                        .catchError((_) {
                          print('Not able to do');
                        });
                    ;
                  }
                },
              ),
            ],
          ),
          SizedBox(
            height: 30.0,
          ),
          Container(
            height: 0.8,
            color: Colors.black26,
            width: double.infinity,
          ),
          SizedBox(
            height: 100.0,
          ),
          RaisedButton(
            color: Colors.grey,
            onPressed: () {
              //Go to history page
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => historyScreen()));
            },
            child: Text("History Page"),
          ),
        ],
      ),
    );
  }
}
