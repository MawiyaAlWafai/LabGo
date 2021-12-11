import 'package:flutter/material.dart';
import 'package:labgo_flutter_app/controller/ForgotPasswordController.dart';
import 'package:labgo_flutter_app/model/Activation.dart';
import 'package:labgo_flutter_app/view/LoginPage.dart';
import 'package:labgo_flutter_app/widget/CustomeAlertDialog.dart';

import '../ApiResponse.dart';

class NewPasswordPage extends StatefulWidget {
  static const routeName = 'newPasswordPage';
  @override
  _NewPasswordState createState() => _NewPasswordState();
}

class _NewPasswordState extends State<NewPasswordPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isVisible = false;
  var controller;
  String? username;
  String? newPassword;
  String? repeatPassword;
  ApiResponse? response;

  void validateAndUpdatePassword() async {
    final FormState? form = _formKey.currentState;
    if (form!.validate()) {
      setState(() {
        _isVisible = true;
      });
      if (newPassword == repeatPassword) {
        response = await controller
            .updatePassword(username, newPassword)
            .then((value) => getResult(value));
      } else {
        CustomeAlertDialog.showAlertDialog(context, 'password mismatch!!!')
            .then((value) {
          setState(() {
            _isVisible = false;
          });
        });
      }
    } else {
      await CustomeAlertDialog.showAlertDialog(
              context, 'password update fail try again!!!')
          .then((value) {
        setState(() {
          _isVisible = false;
        });
      });
    }
  }

  getResult(var response) async {
    if (response?.getData == 200) {
      await CustomeAlertDialog.showAlertDialog(
              context, 'update password success.')
          .then((value) {
        setState(() {
          _isVisible = false;
          Future.delayed(Duration(milliseconds: 500)).then((value) =>
              Navigator.pushReplacementNamed(context, LoginPage.routeName));
        });
      });
    } else {
      await CustomeAlertDialog.showAlertDialog(
              context, 'update password fail try again!')
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

  @override
  Widget build(BuildContext context) {
    controller = ForgotPasswordController();
    var activationData =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    username = activationData['email'];
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
                  image: AssetImage('lib/assets/images/newpassword.png'),
                  height: 400,
                  width: 400,
                ),
              ),
              Form(
                key: _formKey,
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 10,
                    right: 10,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 15,
                        ),
                        child: Text(
                          "Enter your new password",
                          style: TextStyle(
                            fontSize: 22,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 20,
                        ),
                        child: TextFormField(
                          validator: (value) => value!.isEmpty
                              ? 'enter your new password!'
                              : null,
                          obscureText: true,
                          onChanged: (val) => newPassword = val,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.normal,
                          ),
                          decoration: InputDecoration(
                              labelText: 'New Password',
                              suffixIcon: Image.asset(
                                'lib/assets/images/password.png',
                                width: 5,
                                height: 5,
                              ),
                              border: OutlineInputBorder(),
                              errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.grey, width: 5))),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 20,
                        ),
                        child: TextFormField(
                          validator: (value) => value!.isEmpty
                              ? 'enter your new password again!'
                              : null,
                          obscureText: true,
                          onChanged: (val) => repeatPassword = val,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.normal,
                          ),
                          decoration: InputDecoration(
                              labelText: 'Repeat Password',
                              suffixIcon: Image.asset(
                                'lib/assets/images/password.png',
                                width: 5,
                                height: 5,
                              ),
                              border: OutlineInputBorder(),
                              errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.grey, width: 5))),
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
                            top: 25,
                          ),
                          child: TextButton(
                            onPressed: () {
                              validateAndUpdatePassword();
                            },
                            child: Text(
                              "Submit",
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
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
