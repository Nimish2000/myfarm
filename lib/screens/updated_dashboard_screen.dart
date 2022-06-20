import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'history_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'updated_login_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool switchController = false;
  final _auth = FirebaseAuth.instance;
  final databaseReference = FirebaseDatabase.instance.ref();
  final _firestore = FirebaseFirestore.instance;

  var ktextStyle = TextStyle(
    fontSize: 30.0,
    color: Colors.white,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/location_background.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.8), BlendMode.dstATop),
          ),
        ),
        constraints: BoxConstraints.expand(),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  FlatButton(
                    onPressed: () async {
                      try {
                        await _auth.signOut();
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => LoginScreen()));
                      } catch (e) {
                        print("Some error occured");
                      }
                    },
                    child: Icon(
                      Icons.logout,
                      color: Colors.white,
                      size: 30.0,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => historyScreen()));
                    },
                    child: Icon(
                      Icons.history,
                      color: Colors.white,
                      size: 40.0,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 40.0,
              ),
              StreamBuilder<QuerySnapshot>(
                stream: _firestore.collection('sensor_data').snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
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
                  var tempVal;
                  var humd;
                  List<Widget> temp = [];
                  for (var message in messages) {
                    tempVal = message['temp'];
                    humd = message['humd'];
                  }
                  final textWidget1 = Padding(
                    padding: EdgeInsets.only(top: 40.0, left: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Temperature : ",
                          style: ktextStyle,
                        ),
                        Text(
                          '$tempVal °',
                          style: ktextStyle,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          '☀️',
                          style: ktextStyle,
                        ),
                      ],
                    ),
                  );
                  final textWidget2 = Padding(
                    padding: EdgeInsets.only(top: 40.0, left: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Humidity : ",
                          style: ktextStyle,
                        ),
                        Text(
                          '$humd %',
                          style: ktextStyle,
                        ),
                      ],
                    ),
                  );
                  temp.add(textWidget1);
                  temp.add(textWidget2);
                  return Column(
                    children: temp,
                  );
                },
              ),
              SizedBox(
                height: 200.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    "Pump status : ",
                    style: ktextStyle,
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
                            .catchError(
                              (_) {
                                print('Not able to do');
                              },
                            );
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
