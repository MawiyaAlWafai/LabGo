import 'package:labgo_flutter_app/ApiConfig.dart';
import 'package:labgo_flutter_app/controller/ExperimentsController.dart';
import 'package:labgo_flutter_app/model/Lab.dart';
import 'package:labgo_flutter_app/model/Quiz.dart';
import 'package:labgo_flutter_app/model/Video.dart';
import 'package:labgo_flutter_app/widget/AppDrawer.dart';
import 'package:labgo_flutter_app/widget/CustomeAlertDialog.dart';
import 'package:labgo_flutter_app/widget/CustomeNetworkImage.dart';
import 'package:labgo_flutter_app/widget/QuizItem.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../ApiResponse.dart';

class ExperimentDetailsPage extends StatefulWidget {
  static const routeName = 'experimentDetailsPage';
  final Map<String, dynamic>? userData;
  final SharedPreferences sharedPreferences;
  ExperimentDetailsPage(
      {required this.userData, required this.sharedPreferences});

  @override
  _ExperimentDetailsPageState createState() => _ExperimentDetailsPageState();
}

class _ExperimentDetailsPageState extends State<ExperimentDetailsPage> {
  YoutubePlayerController? _controller;
  late String experimentId;
  late String experimentVideo;
  ApiResponse? apiResponse;
  ExperimentsController? experimentsController;
  bool _isVisible = true;
  List<Video>? experimentData;
  List<Lab>? experimentDataTools;
  int experimentSize = 0;
  List<Quiz>? experimentDataQuiz;
  int? experimentDataQuizSize;
  int currentToolOrder = 0;
  int currentStepOrder = 0;
  bool isCorrectDialog = false;
  var stepImage;
  List<String>? stepOrderImages;
  List<String>? toolImages;
  List<String>? toolTitles;

  Future<void> loadingExperimentVideo() async {
    await experimentsController!
        .getExperimentVideo(experimentId)
        .then((value) => getVideoResult(value));
  }

  Future<void> loadingExperimentTools() async {
    try {
      await experimentsController!
          .getExperimentTools(experimentId)
          .then((value) => getToolsResult(value))
          .whenComplete(() {
        if (mounted) {
          setState(() {
            experimentSize++;
            print(experimentSize);
            _isVisible = false;
          });
        }
      });
    } catch (exception) {
      print(exception.toString());
    }
  }

  Future<void> loadingExperimentQuiz() async {
    await experimentsController!
        .getExperimentQuizWithChoices(experimentId)
        .then((value) => getQuizResult(value));
  }

  getVideoResult(var response) async {
    if (response?.getListData != null) {
      experimentData = response?.getListData as List<Video>;
      final videoId = YoutubePlayer.convertUrlToId(experimentData![0].getUrl)!;
      _controller = YoutubePlayerController(
        initialVideoId: videoId, //Add videoID.
        flags: YoutubePlayerFlags(
          hideControls: false,
          controlsVisibleAtStart: true,
          autoPlay: false,
          mute: false,
        ),
      );
      if (_controller!.value.isReady) {
        setState(() {
          _isVisible = false;
        });
      }
    } else {
      await CustomeAlertDialog.showAlertDialog(
              context, 'Empty Experiment Video details!!!')
          .then((value) {
        setState(() {
          _isVisible = false;
        });
      });
    }
  }

  getToolsResult(var response) async {
    if (response?.getListData != null) {
      experimentDataTools = response?.getListData as List<Lab>;

      if (stepOrderImages == null && toolImages == null) {
        stepOrderImages = [];
        toolImages = [];
        toolTitles = [];

        experimentDataTools!.forEach((element) {
          if (element.getIsToolOrStep == '0') {
            stepOrderImages!.add(element.getToolImage);
          } else if (element.getIsToolOrStep == '1') {
            toolImages!.add(element.getToolImage);
            toolTitles!.add(element.getToolTitle);
          }
        });
      }
    } else {
      await CustomeAlertDialog.showAlertDialog(
              context, 'Empty Experiment tools!!!')
          .then((value) {
        setState(() {
          _isVisible = false;
        });
      });
    }
  }

  getQuizResult(var response) async {
    if (response?.getListData != null) {
      experimentDataQuiz = response?.getListData as List<Quiz>;
      experimentDataQuizSize = experimentDataQuiz!.length;
    } else {
      await CustomeAlertDialog.showAlertDialog(
              context, 'Empty Experiment quiz!!!')
          .then((value) {
        setState(() {
          _isVisible = false;
        });
      });
    }
  }

  Future<void> updateProgress(int currentToolOrder) async {
    await experimentsController?.updateExperimentProgress(
        widget.userData!['id'], experimentId, currentToolOrder);
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

    switch (experiemntType['index']) {
      case 0:
        final result = loadingExperimentTools();
        result.whenComplete(() {
          setState(() {
            _isVisible = false;
          });
        });
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Virtual Lab',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            centerTitle: true,
            iconTheme: IconThemeData(color: Colors.white),
          ),
          drawer: AppDrawer(
            userData: widget.userData,
            sharedPreferences: widget.sharedPreferences,
          ),
          body: _isVisible
              ? Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  child: SizedBox(
                    height: 1200,
                    child: Column(
                      children: [
                        Column(
                          children: [
                            Align(
                                alignment: Alignment.topCenter,
                                child: Container(
                                  width: 300,
                                  height: 300,
                                  child: currentToolOrder > 0
                                      ? stepImage
                                      : CustomeNetworkImage(
                                          ApiConfig.domainUrl +
                                              experimentDataTools![0].getImage,
                                          '0'),
                                )),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Container(
                                  width: 120,
                                  height: 35,
                                  child: TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text(
                                      "Exit",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.black,
                                      ),
                                    ),
                                    style: ButtonStyle(
                                        shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(25.0),
                                                side: BorderSide(
                                                    color: Colors.white))),
                                        elevation: MaterialStateProperty.all(3),
                                        shadowColor: MaterialStateProperty.all(
                                            Colors.black),
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                          Theme.of(context).primaryColor,
                                        )),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (toolImages!.lastIndexOf(toolImages!.last) ==
                            toolImages!.length - 1)
                          GridView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            // onReorder: (oldIndex, newIndex) {},
                            // onWillAccept: (oldIndex, newIndex) => false,
                            padding: const EdgeInsets.all(5),
                            physics: ClampingScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              mainAxisSpacing: 4,
                              crossAxisSpacing: 4,
                              childAspectRatio: 3 / 4.5,
                            ),
                            itemCount: toolImages!.length,
                            itemBuilder: (_, index) => GestureDetector(
                              onTapCancel: () {},
                              child: Draggable(
                                onDragEnd: (_) {
                                  if (currentToolOrder >=
                                          (stepOrderImages!.length) - 1 &&
                                      isCorrectDialog &&
                                      currentToolOrder == index) {
                                    setState(() {
                                      isCorrectDialog = false;
                                      stepImage = CustomeNetworkImage(
                                          ApiConfig.domainUrl +
                                              stepOrderImages![
                                                  stepOrderImages!.length - 1],
                                          '0');
                                    });

                                    updateProgress(stepOrderImages!.length);
                                    CustomeAlertDialog.showAlertDialog(
                                        context, 'Good job');
                                  } else if (currentToolOrder <
                                      (stepOrderImages!.length) - 1) {
                                    if (currentToolOrder >= 0 &&
                                        currentToolOrder == index) {
                                      if (mounted) {
                                        {
                                          setState(() {
                                            currentToolOrder++;
                                            isCorrectDialog = true;
                                          });
                                        }
                                      }
                                    } else if (currentToolOrder != index) {
                                      if (mounted) {
                                        setState(() {
                                          isCorrectDialog = false;
                                        });
                                      }
                                    } else if (currentToolOrder ==
                                        stepOrderImages!.length - 1) {
                                      if (mounted) {
                                        setState(() {
                                          currentToolOrder++;
                                          isCorrectDialog = false;
                                        });
                                      }
                                    }
                                    setState(() {
                                      if (stepOrderImages != null &&
                                          currentToolOrder >= 0 &&
                                          isCorrectDialog) {
                                        PaintingBinding.instance?.imageCache
                                            ?.clear();
                                        stepImage = CustomeNetworkImage(
                                            ApiConfig.domainUrl +
                                                stepOrderImages![
                                                    currentToolOrder - 1 >= 0
                                                        ? currentToolOrder - 1
                                                        : 0],
                                            '0');
                                        updateProgress(currentToolOrder);
                                        CustomeAlertDialog.showAlertDialog(
                                            context, 'Thats correct');
                                      } else if (!isCorrectDialog) {
                                        CustomeAlertDialog.showAlertDialog(
                                            context, 'ops! wrong tool!');
                                      }
                                    });
                                  } else if (isCorrectDialog) {
                                    CustomeAlertDialog.showAlertDialog(
                                        context, 'ops! wrong tool!');
                                  }
                                },
                                feedback: Column(
                                  children: [
                                    Container(
                                      width: 70,
                                      height: 70,
                                      child: CustomeNetworkImage(
                                        ApiConfig.domainUrl +
                                            toolImages![index],
                                        '1',
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Container(
                                        width: 90,
                                        height: 15,
                                        child: Text(
                                          toolTitles![index],
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      width: 70,
                                      height: 70,
                                      child: CustomeNetworkImage(
                                        ApiConfig.domainUrl +
                                            toolImages![index],
                                        '1',
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Container(
                                        width: 90,
                                        height: 15,
                                        child: Text(
                                          toolTitles![index],
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
        );
      case 1:
        final result = loadingExperimentVideo();
        result.whenComplete(() {
          setState(() {
            _isVisible = false;
          });
        });
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Video',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            centerTitle: true,
            iconTheme: IconThemeData(color: Colors.white),
          ),
          drawer: AppDrawer(
            userData: widget.userData,
            sharedPreferences: widget.sharedPreferences,
          ),
          body: _isVisible
              ? Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Center(
                          child: _controller!.initialVideoId.isNotEmpty
                              ? YoutubePlayer(
                                  controller: _controller!,
                                  showVideoProgressIndicator: true,
                                  progressIndicatorColor: Colors.red,
                                )
                              : Container(),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text(
                            experimentData![0].getDescription,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Container(
                              width: 120,
                              height: 35,
                              child: TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text(
                                  "Exit",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                ),
                                style: ButtonStyle(
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(25.0),
                                            side: BorderSide(
                                                color: Colors.white))),
                                    elevation: MaterialStateProperty.all(3),
                                    shadowColor:
                                        MaterialStateProperty.all(Colors.black),
                                    backgroundColor: MaterialStateProperty.all(
                                      Theme.of(context).primaryColor,
                                    )),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        );
      case 2:
        final result = loadingExperimentQuiz();
        result.whenComplete(() {
          if (mounted) {
            setState(() {
              _isVisible = false;
            });
          }
        });
        var newxtIndex = experiemntType['nextIndex'] != null
            ? {"nextIndex": experiemntType['nextIndex']}
            : {'nextIndex': 0};
        return QuizItem(
          experimentDataQuiz: experimentDataQuiz,
          experiemntType: experiemntType,
          experimentDataQuizSize: experimentDataQuizSize,
          userData: widget.userData,
          sharedPreferences: widget.sharedPreferences,
          newxtIndex: newxtIndex,
        );

      default:
        return Center(
          child: Text('Not available experiment'),
        );
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (mounted) {
      if (_controller != null) {
        _controller!.dispose();
      }
    }
  }
}
