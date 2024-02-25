import 'package:flutter/material.dart';
import 'package:flutterapp/models/api_response.dart';
import 'package:flutterapp/models/user.dart';
import 'package:flutterapp/screens/home.dart';
import 'package:flutterapp/services/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constant.dart';
import 'login.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool loading = false;
  TextEditingController nameController = TextEditingController(),
      emailController = TextEditingController(),
      passwordController = TextEditingController(),
      passwordConfirmController = TextEditingController();

  void _registerUser() async {
    ApiResponse response = await register(
        nameController.text, emailController.text, passwordController.text);
    if (response.error == null) {
      _saveAndRedirectToHome(response.data as User);
    } else {
      setState(() {
        loading = !loading;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${response.error}')));
    }
  }

  // Save and redirect to home
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
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 32),
          children: [
            Center(
              child: Image.asset(
                'assets/images/Sflow_1.png',
                width: 180,
                height: 180,
                // Adjust width and height as needed
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
            controller: nameController,
            validator: (val) => val!.isEmpty ? 'Invalid name' : null,
            decoration: InputDecoration(
              labelText: 'Name',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15), // make the form more circular
              ),
            ),
          ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              validator: (val) => val!.isEmpty ? 'Invalid email address' : null,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15), // make the form more circular
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
            controller: passwordController,
            obscureText: true,
            validator: (val) => val!.length < 6 ? 'Required at least 6 chars' : null,
            decoration: InputDecoration(
              labelText: 'Password',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15), // make the form more circular
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          TextFormField(
            controller: passwordConfirmController,
            obscureText: true,
            validator: (val) => val != passwordController.text ? 'Confirm password does not match' : null,
            decoration: InputDecoration(
              labelText: 'Confirm password',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15), // make the form more circular
              ),
            ),
          ),
            SizedBox(
              height: 20,
            ),
            loading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : ElevatedButton(
                    child: Text(
                      'Register',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, // make the text bold
                        color: Colors.black, // change the text color to black
                      ),
                    ),
                      style: TextButton.styleFrom(
                    backgroundColor: Colors.grey, // change the button color to grey
                  ),
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        setState(() {
                          loading = !loading;
                          _registerUser();
                        });
                      }
                    },
                  ),
            SizedBox(
              height: 20,
            ),
            kLoginRegisterHint('Already have an account? ', 'Login', () {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => Login()),
                  (route) => false);
            })
          ],
        ),
      ),
    );
  }
}
