import 'package:flutter/material.dart';
import 'package:labgo_flutter_app/controller/SignupController.dart';
import 'package:labgo_flutter_app/model/User.dart';
import 'package:labgo_flutter_app/widget/CustomeAlertDialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../ApiResponse.dart';
import '../DataCacheService.dart';
import 'HomePage.dart';

class SignupPage extends StatefulWidget {
  static const routeName = 'signupPage';
  @override
  _SignupState createState() => new _SignupState();
}

class _SignupState extends State<SignupPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String username;
  late String password;
  late String email;
  ApiResponse? response;
  bool _isVisible = false;
  var controller;

  void validateAndSignup() async {
    final FormState? form = _formKey.currentState;
    if (form!.validate()) {
      setState(() {
        _isVisible = true;
      });
      response = await controller
          .signupUser(username, password, email)
          .then((value) => getResult(value));
    } else {
      await CustomeAlertDialog.showAlertDialog(
              context, 'conflict username or password!!!')
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
    controller = SignupController(signupPage: widget);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          // width: MediaQuery.of(context).size.width,
          // height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.all(10),
          alignment: Alignment.center,
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 10,
                ),
                child: Image(
                  image: AssetImage('lib/assets/images/welcome.png'),
                  height: 400,
                  width: 400,
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
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 5,
                      ),
                      child: Text(
                        "Create an account, it's free",
                        style: TextStyle(
                          fontSize: 17,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 40,
                            ),
                            child: TextFormField(
                              validator: (value) => value!.isEmpty
                                  ? 'enter your username!'
                                  : null,
                              obscureText: false,
                              onChanged: (val) => username = val,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.normal,
                              ),
                              decoration: InputDecoration(
                                  labelText: 'Username',
                                  suffixIcon: Image.asset(
                                    'lib/assets/images/username.png',
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
                              validator: (value) =>
                                  value!.isEmpty ? 'enter your email!' : null,
                              obscureText: false,
                              onChanged: (val) => email = val,
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
                        ],
                      ),
                    ),
                    Visibility(
                      visible: _isVisible,
                      child: CircularProgressIndicator(),
                    ),
                    Container(
                      width: 120,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 10,
                        ),
                        child: TextButton(
                          onPressed: () => validateAndSignup(),
                          child: Text(
                            "Sign up",
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
      await CustomeAlertDialog.showAlertDialog(context, 'conflict user')
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
