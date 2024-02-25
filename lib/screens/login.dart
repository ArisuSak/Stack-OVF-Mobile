import 'package:flutter/material.dart';
import 'package:flutterapp/models/api_response.dart';
import 'package:flutterapp/models/user.dart';
import 'package:flutterapp/screens/home.dart';
import 'package:flutterapp/services/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constant.dart';
import 'register.dart';


class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPassword = TextEditingController();
  bool loading = false;

  void _loginUser() async {
    ApiResponse response = await login(txtEmail.text, txtPassword.text);
    if (response.error == null) {
      _saveAndRedirectToHome(response.data as User);
    } else {
      setState(() {
        loading = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${response.error}')));
    }
  }

  void _saveAndRedirectToHome(User user) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString('token', user.token ?? '');
    await pref.setInt('userId', user.id ?? 0);
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => Home()), (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: formkey,
        child: ListView(
          padding: EdgeInsets.all(32),
          children: [
            Center(
              child: Image.asset(
                'assets/images/Sflow_1.png',
                width: 180,
                height: 180,
                // Adjust width and height as needed
              ),
            ),
            // SizedBox(height: 20),
            SizedBox(height: 25),
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              controller: txtEmail,
              validator: (val) => val!.isEmpty ? 'Invalid email address' : null,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15), // make the form more circular
                ),
                hoverColor: Color(0xFFF48024), // change the color when hovering to orange
              ),
            ),
            SizedBox(
              height: 16,
            ),
            TextFormField(
                controller: txtPassword,
                obscureText: true,
                validator: (val) => val!.length < 6 ? 'Required at least 6 chars' : null,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15), // make the form more circular
                  ),
                  hoverColor: Color(0xFFF48024), // change the color when hovering to orange
                ),
              ),
            SizedBox(
              height: 10,
            ),
        loading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ElevatedButton(
               child: Text(
                  'Login',
                  style: TextStyle(
                    fontWeight: FontWeight.bold, // make the text bold
                    color: Colors.black, // change the text color to black
                  ),
                ),
                style: TextButton.styleFrom(
                    backgroundColor: Colors.grey, // change the button color to grey
                  ),
                onPressed: () {
                  if (formkey.currentState!.validate()) {
                    setState(() {
                      loading = true;
                      _loginUser();
                    });
                  }
                },
              ),
            SizedBox(
              height: 10,
            ),
            kLoginRegisterHint('Dont have an acount? ', 'Register', () {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => Register()),
                  (route) => false);
            })
          ],
        ),
      ),
    );
  }
}
