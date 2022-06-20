import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myfarm/screens/dashboard_screen.dart';

class loginScreen extends StatefulWidget {
  const loginScreen({Key? key}) : super(key: key);

  @override
  State<loginScreen> createState() => _loginScreenState();
}

class _loginScreenState extends State<loginScreen> {
  final _auth = FirebaseAuth.instance;
  final email = TextEditingController();
  final password = TextEditingController();
  bool showSpinner = false;
  @override
  void dispose() {
    // TODO: implement dispose
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal,
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25.0),
          ),
          height: MediaQuery.of(context).size.height * 0.5,
          width: MediaQuery.of(context).size.width * 0.8,
          child: Padding(
            padding: const EdgeInsets.only(top: 35.0),
            child: Column(
              children: [
                Text(
                  "Login",
                  style: TextStyle(fontSize: 35.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.08,
                ),
                ListTile(
                  leading: Icon(Icons.email),
                  title: TextField(
                    controller: email,
                    decoration: InputDecoration(
                      hintText: "Enter Email",
                    ),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.password),
                  title: TextField(
                    controller: password,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: "Enter password",
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.04,
                ),
                RaisedButton(
                  color: Colors.blueGrey,
                  onPressed: () async {
                    setState(() {
                      showSpinner = true;
                    });
                    try {
                      final user = await _auth.signInWithEmailAndPassword(
                          email: email.text, password: password.text);
                      if (user != null) {
                        //Navigate to dashboard
                        setState(() {
                          showSpinner = false;
                        });

                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => dashboardScreen()));
                      }
                    } catch (e) {
                      setState(() {
                        showSpinner = false;
                      });

                      var snackBar =
                          SnackBar(content: Text('Invalid Crdentials!!'));
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                    email.clear();
                    password.clear();
                  },
                  child: showSpinner
                      ? CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : Text("Submit"),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.04,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
