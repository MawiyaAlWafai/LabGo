import 'package:flutter/material.dart';
import 'package:labgo_flutter_app/controller/ForgotPasswordController.dart';
import 'package:labgo_flutter_app/model/Activation.dart';
import 'package:labgo_flutter_app/view/ActivationCodePage.dart';
import 'package:labgo_flutter_app/widget/CustomeAlertDialog.dart';

import '../ApiResponse.dart';

class ForgotPasswordPage extends StatefulWidget {
  static const routeName = 'forgorPasswordPage';
  @override
  _ForgotPasswordState createState() => new _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPasswordPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isVisible = false;
  var controller;
  String? username;
  ApiResponse? response;

  void validateAndSendActivationCode() async {
    final FormState? form = _formKey.currentState;
    if (form!.validate()) {
      if (mounted) {
        setState(() {
          _isVisible = true;
        });
        response = await controller
            .forgotPassword(username)
            .then((value) => getResult(value));
      }
    } else {
      await CustomeAlertDialog.showAlertDialog(
              context, 'invalid email address!!!')
          .then((value) {
        setState(() {
          _isVisible = false;
        });
      });
    }
  }

  getResult(var response) async {
    if (response?.getData != null) {
      final userData = response?.getData as Activation;
      Navigator.pushReplacementNamed(context, ActivationCodePage.routeName,
          arguments: {
            "activation_code": userData.getActivationCode,
            "email": username
          });
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

  @override
  Widget build(BuildContext context) {
    controller = ForgotPasswordController();
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
                  image: AssetImage('lib/assets/images/forgotpassword.png'),
                  height: 400,
                  width: 400,
                ),
              ),
              Form(
                key: _formKey,
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 20,
                    right: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 5,
                        ),
                        child: Text(
                          "Forgot your password?",
                          style: TextStyle(
                            fontSize: 28,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 5,
                        ),
                        child: Text(
                          "No worries, just enter your email",
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.normal),
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
                            top: 40,
                          ),
                          child: TextButton(
                            onPressed: () => validateAndSendActivationCode(),
                            child: Text(
                              "Next",
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
