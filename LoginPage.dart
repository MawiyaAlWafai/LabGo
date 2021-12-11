import 'package:flutter/material.dart';
import 'package:labgo_flutter_app/controller/LoginController.dart';
import 'package:labgo_flutter_app/model/User.dart';
import 'package:labgo_flutter_app/view/HomePage.dart';
import 'package:labgo_flutter_app/view/SignupPage.dart';
import 'package:labgo_flutter_app/widget/CustomeAlertDialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../ApiResponse.dart';
import '../DataCacheService.dart';
import 'ForogtPasswordPage.dart';

class LoginPage extends StatefulWidget {
  static const routeName = 'loginPage';
  @override
  _LoginState createState() => new _LoginState();
}

class _LoginState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String username;
  late String password;
  ApiResponse? response;
  bool _isVisible = false;
  var controller;

  void validateAndLogin() async {
    final FormState? form = _formKey.currentState;
    if (form!.validate()) {
      setState(() {
        _isVisible = true;
      });
      response = await controller
          .authenticateUser(username, password)
          .then((value) => getResult(value));
    } else {
      await CustomeAlertDialog.showAlertDialog(
              context, 'invalid username or password!!!')
          .then((value) {
        setState(() {
          _isVisible = false;
        });
      });
    }
  }

  var _data;
  fillViews(User data) async {
    _data = data;
    setState(() async {
      if (_data != null) {
        final sharedPreferences = await SharedPreferences.getInstance();
        final dataCache = DataCacheService(sharedPrefrences: sharedPreferences);
        await dataCache
            .setData(_data)
            .then((value) =>
                Navigator.of(context).pushReplacementNamed(HomePage.routeName))
            .then((value) => _isVisible = false);
      }
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    controller = LoginController(loginPage: widget);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(10),
          alignment: Alignment.center,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 10,
                ),
                child: Image(
                  image: AssetImage('lib/assets/images/hello.jpg'),
                  height: 300,
                  width: 300,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: 10,
                  right: 10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 5,
                            ),
                            child: Text(
                              "Welcome back! Login with your credentials!",
                              style: TextStyle(
                                fontSize: 17,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 40,
                            ),
                            child: TextFormField(
                              validator: (value) =>
                                  value!.isEmpty ? 'enter your email!' : null,
                              obscureText: false,
                              onChanged: (val) => username = val,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.normal,
                              ),
                              decoration: InputDecoration(
                                  labelText: 'Email',
                                  suffixIcon: Image.asset(
                                    'lib/assets/images/email.png',
                                    width: 5,
                                    height: 5,
                                  ),
                                  border: OutlineInputBorder(),
                                  errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.grey, width: 1))),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 20,
                            ),
                            child: TextFormField(
                              validator: (value) => value!.isEmpty
                                  ? 'enter your password!'
                                  : null,
                              obscureText: true,
                              onChanged: (val) => password = val,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.normal,
                              ),
                              decoration: InputDecoration(
                                  labelText: 'Password',
                                  suffixIcon: Image.asset(
                                    'lib/assets/images/password.png',
                                    width: 5,
                                    height: 5,
                                  ),
                                  border: OutlineInputBorder(),
                                  errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.grey, width: 1))),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                top: 5,
                              ),
                              child: TextButton(
                                onPressed: () => Navigator.of(context)
                                    .pushNamed(ForgotPasswordPage.routeName),
                                child: Text(
                                  "Forgot password?",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                ),
                                style: ButtonStyle(
                                  elevation: MaterialStateProperty.all(0),
                                  shadowColor:
                                      MaterialStateProperty.all(Colors.black),
                                  backgroundColor: MaterialStateProperty.all(
                                    Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: 100,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                top: 2,
                              ),
                              child: TextButton(
                                onPressed: () => validateAndLogin(),
                                child: Text(
                                  "Login",
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                  ),
                                ),
                                style: ButtonStyle(
                                    elevation: MaterialStateProperty.all(3),
                                    shadowColor:
                                        MaterialStateProperty.all(Colors.black),
                                    backgroundColor: MaterialStateProperty.all(
                                      Theme.of(context).buttonColor,
                                    )),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: _isVisible,
                            child: CircularProgressIndicator(),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 0,
                            ),
                            child: TextButton(
                              onPressed: () => Navigator.of(context)
                                  .pushNamed(SignupPage.routeName),
                              child: Text(
                                "Join now!!",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              style: ButtonStyle(
                                  elevation: MaterialStateProperty.all(0),
                                  shadowColor:
                                      MaterialStateProperty.all(Colors.black),
                                  backgroundColor: MaterialStateProperty.all(
                                    Colors.white,
                                  )),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  getResult(var response) async {
    if (response?.getData != null) {
      final userData = response?.getData as User;
      fillViews(User(userData.getId, userData.getUsername, userData.getEmail,
          userData.getRole, userData.getImage));
    } else {
      await CustomeAlertDialog.showAlertDialog(context, 'invalid user')
          .then((value) {
        setState(() {
          _isVisible = false;
        });
      });
    }
    setState(() {
      _isVisible = false;
    });
  }
}
