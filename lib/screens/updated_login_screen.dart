import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'constants.dart';
import 'dashboard_screen.dart';
import 'updated_dashboard_screen.dart';

bool isWrong = false;

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  bool showSpinner = false;
  final email = TextEditingController();
  final password = TextEditingController();

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
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Flexible(
              child: Hero(
                tag: 'logo',
                child: Container(
                  height: 200.0,
                  child: Image.asset('assets/images/weather1.png'),
                ),
              ),
            ),
            SizedBox(
              height: 48.0,
            ),
            TextField(
              keyboardType: TextInputType.emailAddress,
              textAlign: TextAlign.center,
              controller: email,
              decoration: kTextFileDecoration.copyWith(
                hintText: 'Enter your mail',
                errorText: isWrong ? 'invalid mail' : null,
              ),
            ),
            SizedBox(
              height: 8.0,
            ),
            TextField(
              obscureText: true,
              keyboardType: TextInputType.visiblePassword,
              textAlign: TextAlign.center,
              controller: password,
              decoration: kTextFileDecoration.copyWith(
                hintText: 'Enter your password',
              ),
            ),
            SizedBox(
              height: 24.0,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Material(
                elevation: 5.0,
                color: Colors.blue,
                borderRadius: BorderRadius.circular(30.0),
                child: MaterialButton(
                  onPressed: () async {
                    setState(() {
                      showSpinner = true;
                    });
                    try {
                      final user = await _auth.signInWithEmailAndPassword(
                          email: email.text, password: password.text);
                      if (user != null) {
                        //Navigate to dashboard
                        print("Success");
                        setState(() {
                          showSpinner = false;
                        });
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => DashboardScreen()));
                      }
                    } catch (e) {
                      print("Some Error");
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
                  minWidth: 200.0,
                  height: 42.0,
                  child: showSpinner
                      ? CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : Text(
                          'Login',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
