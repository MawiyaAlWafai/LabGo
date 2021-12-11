import 'package:flutter/material.dart';
import 'package:labgo_flutter_app/widget/AppDrawer.dart';
import 'package:labgo_flutter_app/widget/admin/ExperimentAdminItem.dart';
import 'package:labgo_flutter_app/widget/admin/ExperimentTypeAdminItem.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExperimentTypesAdminPage extends StatefulWidget {
  static const routeName = 'experimentTypesAdminPage';
  final Map<String, dynamic>? userData;
  final SharedPreferences sharedPreferences;
  ExperimentTypesAdminPage(
      {required this.userData, required this.sharedPreferences});
  @override
  _ExperimentTypesAdminPageState createState() =>
      _ExperimentTypesAdminPageState();
}

class _ExperimentTypesAdminPageState extends State<ExperimentTypesAdminPage> {
  String? experimentId;
  @override
  Widget build(BuildContext context) {
    var arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    experimentId = arguments['experiment_id'];
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Experiment Types Admin',
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
            return ExperimentTypeAdminItem(
                listTypes,
                index,
                widget.userData!['id'],
                widget.userData!['role'],
                experimentId!);
          }),
    );
  }
}
