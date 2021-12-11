import 'package:flutter/material.dart';
import 'package:labgo_flutter_app/ApiResponse.dart';
import 'package:labgo_flutter_app/view/ExperimentDetailsPage.dart';
import 'package:labgo_flutter_app/view/ForogtPasswordPage.dart';
import 'package:labgo_flutter_app/view/HomePage.dart';
import 'package:labgo_flutter_app/view/admin/AdminQuizPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'DataCacheService.dart';
import 'view/ActivationCodePage.dart';
import 'view/ExperimentTypesPage.dart';
import 'view/LoginPage.dart';
import 'view/NewPasswordPage.dart';
import 'view/SignupPage.dart';
import 'view/admin/ExperimentTypesAdminPage.dart';
import 'package:provider/provider.dart';

import 'widget/QuizItem.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sharedPreferences = await SharedPreferences.getInstance();
  runApp(MyApp(sharedPreferences: sharedPreferences));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key, required this.sharedPreferences}) : super(key: key);
  final SharedPreferences sharedPreferences;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final dataCache = DataCacheService(sharedPrefrences: sharedPreferences);
    MaterialColor orange = MaterialColor(
      0xFFfaae57,
      <int, Color>{
        50: Color(0xFFFFF3E0),
        100: Color(0xFFFFE0B2),
        200: Color(0xFFFFCC80),
        300: Color(0xFFFFB74D),
        400: Color(0xFFFCE9D4),
        500: Color(0xFFfaae57),
        600: Color(0xFFFB8C00),
        700: Color(0xFFF57C00),
        800: Color(0xFFEF6C00),
        900: Color(0xFFE65100),
      },
    );

    MaterialColor blue = MaterialColor(
      0xFF61b4b8,
      <int, Color>{
        50: Color(0xFFE3F2FD),
        100: Color(0xFFBBDEFB),
        200: Color(0xFF90CAF9),
        300: Color(0xFF64B5F6),
        400: Color(0xFFD8EDF3),
        500: Color(0xFF61b4b8),
        600: Color(0xFF1E88E5),
        700: Color(0xFF1976D2),
        800: Color(0xFF1565C0),
        900: Color(0xFF0D47A1),
      },
    );
    return Provider<ApiResponse>(
      create: (_) => ApiResponse(),
      child: MaterialApp(
        title: 'LabGo+',
        theme: ThemeData(
          primarySwatch: blue,
          accentColor: orange,
          buttonColor: orange,
          cardColor: blue.shade400,
          primaryColorLight: orange.shade400,
        ),
        home: dataCache.getData().isNotEmpty
            ? HomePage(
                userData: dataCache.getData(),
                sharedPreferences: sharedPreferences,
              )
            : SplashPage(title: 'Home Page'),
        routes: {
          LoginPage.routeName: (ctx) => LoginPage(),
          ForgotPasswordPage.routeName: (ctx) => ForgotPasswordPage(),
          SignupPage.routeName: (ctx) => SignupPage(),
          ActivationCodePage.routeName: (ctx) => ActivationCodePage(),
          NewPasswordPage.routeName: (ctx) => NewPasswordPage(),
          HomePage.routeName: (ctx) => HomePage(
                userData: dataCache.getData(),
                sharedPreferences: sharedPreferences,
              ),
          ExperimentTypesPage.routeName: (ctx) => ExperimentTypesPage(
                userData: dataCache.getData(),
                sharedPreferences: sharedPreferences,
              ),
          ExperimentTypesAdminPage.routeName: (ctx) => ExperimentTypesAdminPage(
                userData: dataCache.getData(),
                sharedPreferences: sharedPreferences,
              ),
          ExperimentDetailsPage.routeName: (ctx) => ExperimentDetailsPage(
                userData: dataCache.getData(),
                sharedPreferences: sharedPreferences,
              ),
          QuizItem.routeName: (ctx) => QuizItem(
                userData: dataCache.getData(),
                sharedPreferences: sharedPreferences,
              ),
          AdminQuizPage.routeName: (ctx) => AdminQuizPage(
                userData: dataCache.getData(),
                sharedPreferences: sharedPreferences,
              ),
        },
      ),
    );
  }
}

class SplashPage extends StatefulWidget {
  SplashPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.all(10),
          alignment: Alignment.center,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 2,
                  ),
                  child: Image(
                    image: AssetImage('lib/assets/images/logo.jpeg'),
                    height: 250,
                    width: 250,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: 100,
                    right: 100,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 30,
                        ),
                        child: TextButton(
                          onPressed: () => Navigator.of(context)
                              .pushReplacementNamed(LoginPage.routeName),
                          child: Text(
                            "Let's get started!",
                            style: TextStyle(
                              fontSize: 17,
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
