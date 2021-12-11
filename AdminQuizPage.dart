import 'package:flutter/material.dart';
import 'package:labgo_flutter_app/controller/ExperimentsController.dart';
import 'package:labgo_flutter_app/model/Quiz.dart';
import 'package:labgo_flutter_app/widget/AppDrawer.dart';
import 'package:labgo_flutter_app/widget/CustomeAlertDialog.dart';
import 'package:labgo_flutter_app/widget/admin/AdminQuizItem.dart';
import 'package:labgo_flutter_app/widget/admin/QuestionAlertDialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminQuizPage extends StatefulWidget {
  static const routeName = 'adminQuizPage';
  final Map<String, dynamic>? userData;
  final SharedPreferences sharedPreferences;
  AdminQuizPage({required this.userData, required this.sharedPreferences});
  @override
  State<AdminQuizPage> createState() => _AdminQuizPageState();
}

class _AdminQuizPageState extends State<AdminQuizPage> {
  bool _isVisible = true;
  ExperimentsController? experimentsController;
  late String experimentId;
  List<Quiz>? experimentDataQuiz;
  int? experimentDataQuizSize;

  Future<void> loadingExperimentQuiz() async {
    await experimentsController!
        .getExperimentQuizWithChoices(experimentId)
        .then((value) => getQuizResult(value));
  }

  getQuizResult(var response) async {
    if (response?.getListData != null) {
      experimentDataQuiz = response?.getListData as List<Quiz>;
      experimentDataQuizSize = experimentDataQuiz!.length;
    } else {
      await CustomeAlertDialog.showAlertDialog(
              context, 'no experiment questions available now!!!')
          .then((value) {
        setState(() {
          _isVisible = false;
        });
      });
    }
  }

  @override
  void initState() {
    experimentsController = ExperimentsController(experimentsPage: widget);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var experiemntType =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    experimentId = experiemntType['experimentId'];
    final result = loadingExperimentQuiz();
    result.whenComplete(() {
      if (mounted) {
        setState(() {
          _isVisible = false;
        });
      }
    });
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Quiz',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add_circle, color: Colors.black),
            onPressed: () {
              QuestionAlertDialog.showAlertDialog(
                  context, "Question", experimentId);
            },
          )
        ],
      ),
      drawer: AppDrawer(
        userData: widget.userData,
        sharedPreferences: widget.sharedPreferences,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _isVisible
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      physics: ClampingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: experimentDataQuizSize,
                      itemBuilder: (context, index) {
                        return AdminQuizItem(index, experimentDataQuiz);
                      }),
            ],
          ),
        ),
      ),
    );
  }
}
