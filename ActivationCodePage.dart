import 'package:flutter/material.dart';
import 'package:labgo_flutter_app/view/NewPasswordPage.dart';
import 'package:labgo_flutter_app/widget/CustomeAlertDialog.dart';

class ActivationCodePage extends StatefulWidget {
  static const routeName = 'activationCodePage';
  @override
  _ActivationCodeState createState() => _ActivationCodeState();
}

class _ActivationCodeState extends State<ActivationCodePage> {
  String? receivedActivationCode;
  String? userActivationCode;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isVisible = false;
  String? email;
  String? num1;
  String? num2;
  String? num3;
  String? num4;

  void validateReceivedActivationCode() async {
    final FormState? form = _formKey.currentState;
    if (form!.validate()) {
      userActivationCode = num1! + num2! + num3! + num4!;
      setState(() {
        _isVisible = false;
        if (userActivationCode == receivedActivationCode) {
          Navigator.pushReplacementNamed(context, NewPasswordPage.routeName,
              arguments: {'email': email});
        } else {
          CustomeAlertDialog.showAlertDialog(
                  context, 'invalid activation code!!!')
              .then((value) {
            setState(() {
              _isVisible = false;
            });
          });
        }
      });
    } else {
      await CustomeAlertDialog.showAlertDialog(
              context, 'enter activation code!!!')
          .then((value) {
        setState(() {
          _isVisible = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var activationData =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    receivedActivationCode = activationData['activation_code'];
    email = activationData['email'];
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            height: 500,
            width: 330,
            decoration: BoxDecoration(
              border: Border.all(
                width: 3,
                color: Theme.of(context).primaryColor,
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(7),
              ),
            ),
            padding: EdgeInsets.all(5),
            margin: const EdgeInsets.all(15),
            alignment: Alignment.center,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    left: 5,
                    right: 5,
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 15,
                        ),
                        child: Text(
                          "Enter 4-digits",
                          style: TextStyle(
                            fontSize: 28,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Form(
                        key: _formKey,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: 4, right: 4),
                              width: 55,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  top: 50,
                                ),
                                child: TextFormField(
                                  validator: (value) =>
                                      value!.isEmpty ? '_' : null,
                                  obscureText: true,
                                  onChanged: (val) => num1 = val,
                                  decoration: InputDecoration(
                                      fillColor:
                                          Color.fromARGB(246, 246, 246, 246),
                                      filled: true),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(right: 4),
                              width: 55,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  top: 50,
                                ),
                                child: TextFormField(
                                  validator: (value) =>
                                      value!.isEmpty ? '_' : null,
                                  obscureText: true,
                                  onChanged: (val) => num2 = val,
                                  decoration: InputDecoration(
                                      fillColor:
                                          Color.fromARGB(246, 246, 246, 246),
                                      filled: true),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(right: 4),
                              width: 55,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  top: 50,
                                ),
                                child: TextFormField(
                                  validator: (value) =>
                                      value!.isEmpty ? '_' : null,
                                  obscureText: true,
                                  onChanged: (val) => num3 = val,
                                  decoration: InputDecoration(
                                      fillColor:
                                          Color.fromARGB(246, 246, 246, 246),
                                      filled: true),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: 55,
                              margin: EdgeInsets.only(right: 4),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  top: 50,
                                ),
                                child: TextFormField(
                                  validator: (value) =>
                                      value!.isEmpty ? '_' : null,
                                  obscureText: true,
                                  onChanged: (val) => num4 = val,
                                  decoration: InputDecoration(
                                      fillColor:
                                          Color.fromARGB(246, 246, 246, 246),
                                      filled: true),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
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
                            top: 200,
                            bottom: 10,
                          ),
                          child: TextButton(
                            onPressed: () => validateReceivedActivationCode(),
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
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
