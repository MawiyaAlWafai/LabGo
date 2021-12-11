import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:labgo_flutter_app/controller/ExperimentsController.dart';
import 'package:labgo_flutter_app/model/Experiment.dart';
import 'package:labgo_flutter_app/widget/CustomeAlertDialog.dart';
import 'package:labgo_flutter_app/widget/ExperimentItem.dart';

import '../ApiResponse.dart';

class ExperimentsPage extends StatefulWidget {
  static const routeName = 'experimentsPage';
  final String userId;
  final String role;
  ExperimentsPage(this.userId, this.role);
  @override
  _ExperimentsPageState createState() => _ExperimentsPageState();
}

class _ExperimentsPageState extends State<ExperimentsPage> {
  ApiResponse? apiResponse;
  late ExperimentsController controller;
  bool _isVisible = true;
  List<Experiment>? experimentData;

  void loadingExperiments() async {
    await controller
        .getExperiments(widget.userId)
        .then((value) => getResult(value));
  }

  showEmptyDialogData() {
    CustomeAlertDialog.showAlertDialog(context, 'Empty Experiments!!!')
        .then((value) {
      setState(() {
        _isVisible = false;
      });
    });
  }

  getResult(var response) async {
    if (response?.getListData != null) {
      experimentData = response?.getListData as List<Experiment>;
    } else {
      await CustomeAlertDialog.showAlertDialog(context, 'Empty Experiments!!!')
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
  void initState() {
    controller = ExperimentsController(experimentsPage: widget);
    loadingExperiments();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _isVisible
        ? Center(child: CircularProgressIndicator())
        : ListView.builder(
            itemCount: experimentData != null ? experimentData!.length : 0,
            itemBuilder: (context, index) {
              return ExperimentItem(
                  experimentData![index], widget.userId, widget.role);
            });
  }
}
