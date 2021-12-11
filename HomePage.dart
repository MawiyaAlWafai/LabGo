import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:labgo_flutter_app/view/ExperimentsPage.dart';
import 'package:labgo_flutter_app/view/admin/ExperimentsAdminPage.dart';
import 'package:labgo_flutter_app/widget/AppDrawer.dart';

class HomePage extends StatefulWidget {
  static const routeName = 'homePage';
  final Map<String, dynamic>? userData;
  final SharedPreferences sharedPreferences;
  HomePage({required this.userData, required this.sharedPreferences});

  @override
  _ExperimentsPage createState() => _ExperimentsPage();
}

class _ExperimentsPage extends State<HomePage> {
  var role;
  var user_id;

  getUserRole() {
    role = widget.userData?['role'];
  }

  getUserId() {
    user_id = widget.userData?['id'];
  }

  @override
  void initState() {
    super.initState();
    getUserRole();
    getUserId();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Experiments Menu',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      drawer: AppDrawer(
        userData: widget.userData,
        sharedPreferences: widget.sharedPreferences,
      ),
      body: role == '1'
          ? ExperimentsAdminPage(user_id, role)
          : ExperimentsPage(user_id, role),
    );
  }
}
