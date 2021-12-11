import 'package:flutter/material.dart';
import 'package:labgo_flutter_app/widget/AppDrawer.dart';
import 'package:labgo_flutter_app/widget/ExperimentTypeItem.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExperimentTypesPage extends StatefulWidget {
  static const routeName = 'experimentTypesPage';
  final Map<String, dynamic>? userData;
  final SharedPreferences sharedPreferences;
  ExperimentTypesPage(
      {required this.userData, required this.sharedPreferences});
  @override
  _ExperimentTypesPageState createState() => _ExperimentTypesPageState();
}

class _ExperimentTypesPageState extends State<ExperimentTypesPage> {
  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final experiemntId = arguments["experiment_id"];
    final experiemntTitle = arguments["experiment_title"];
    return Scaffold(
      appBar: AppBar(
        title: Text(
          experiemntTitle,
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      drawer: AppDrawer(
        userData: widget.userData,
        sharedPreferences: widget.sharedPreferences,
      ),
      body: ListView.builder(
          itemCount: 3,
          itemBuilder: (context, index) {
            List<Map<String, dynamic>> listTypes = [
              {'title': 'Virtual Lab'},
              {'title': 'Video'},
              {'title': 'Quiz'},
            ];
            return ExperimentTypeItem(listTypes, index, widget.userData!['id'],
                widget.userData!['role'], experiemntId);
          }),
    );
  }
}
