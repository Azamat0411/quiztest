import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:quiztest/result_page.dart';

class TestPage extends StatefulWidget {
  final String test;
  final int count;
  final int time;

  const TestPage(
      {Key? key, required this.test, required this.count, required this.time})
      : super(key: key);

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> with TickerProviderStateMixin {
  late AnimationController controller;
  int val = -1;
  List<Map<String, dynamic>> test = [];
  List correctIndex = [];
  List selectIndex = [];
  List<int> random = [];
  int currentIndex = 0;
  int time = 5;
  int count = 5;
  int second = 5;
  Timer? _timer;
  bool first = true;

  Future<List<Map<String, dynamic>>> readJson() async {
    String data = await DefaultAssetBundle.of(context)
        .loadString("assets/${widget.test}.json");
    Map<String, dynamic> jsonResult = jsonDecode(data);
    List test = jsonResult['test'];
    List<Map<String, dynamic>> _test = await createTest(test);
    return _test;
  }

  Future<List<Map<String, dynamic>>> createTest(List test) async {
    List<Map<String, dynamic>> randomTest = [];
    for (int i = 0; i < count; i++) {
      int index = Random().nextInt(test.length);
      if(count < test.length){
        while (random.contains(index)) {
          index = Random().nextInt(test.length);
        }
        random.add(index);
      }
      randomTest.add({"question": "", "answer": []});
      randomTest[i]['question'] = test[index]['question'];
      List randomAnswer = [];
      randomAnswer.add(Random().nextInt(4));
      for (int j = 0; j < 3; j++) {
        int correct = Random().nextInt(4);
        while (randomAnswer.contains(correct) && randomAnswer.length != 4) {
          correct = Random().nextInt(4);
        }
        randomAnswer.add(correct);
      }
      for (int k = 0; k < 4; k++) {
        randomTest[i]['answer'].add(test[index]['answer'][randomAnswer[k]]);
      }
      correctIndex.add(randomAnswer.indexOf(0));
    }
    return randomTest;
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(milliseconds: 1000), (_) {
      setState(() {
        second--;
        if (second == 0) {
          _timer!.cancel();
          if (currentIndex != count - 1) {
            selectIndex[currentIndex] = val;
            val = -1;
            currentIndex++;
            second = time;
            startTimer();
          } else {
            balance(test, correctIndex, selectIndex);
          }
        }
      });
    });
  }

  init() {
    startTimer();
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: time),
    )..addListener(() {
        setState(() {});
      });
    controller.repeat(reverse: false);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.time > 5) {
      time = widget.time;
      second = time;
    }
    if (widget.count > 5) {
      count = widget.count;
    }
    selectIndex = List.filled(count, -1);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _timer!.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Test"),
      ),
      body: Center(
        child: test.isEmpty
            ? FutureBuilder(
                future: readJson(),
                builder:
                    (context, AsyncSnapshot<List<Map<String, dynamic>>> t) {
                  if (!t.hasData) {
                    return const CircularProgressIndicator();
                  }
                  if (t.hasData) {
                    test = t.data!;
                    init();
                    return questions();
                  }
                  return Container();
                },
              )
            : questions(),
      ),
    );
  }

  questions() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    "${currentIndex + 1}. " + test[currentIndex]['question'],
                    style: const TextStyle(
                        fontWeight: FontWeight.w500, fontSize: 16),
                  ),
                ),
                SizedBox(width: 20, child: Text(second.toString())),
                CircularProgressIndicator(
                  color: Colors.blue,
                  value: controller.value,
                ),
              ],
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              action(test[currentIndex]['answer'][0], val, 0,
                  correctIndex[currentIndex], () {
                setState(() {
                  val = 0;
                });
              }),
              action(test[currentIndex]['answer'][1], val, 1,
                  correctIndex[currentIndex], () {
                setState(() {
                  val = 1;
                });
              }),
              action(test[currentIndex]['answer'][2], val, 2,
                  correctIndex[currentIndex], () {
                setState(() {
                  val = 2;
                });
              }),
              action(test[currentIndex]['answer'][3], val, 3,
                  correctIndex[currentIndex], () {
                setState(() {
                  val = 3;
                });
              }),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // ElevatedButton(
                  //     onPressed: () {
                  //       if (currentIndex > 0) {
                  //         setState(() {
                  //           currentIndex--;
                  //           val = selectIndex[currentIndex];
                  //         });
                  //       }
                  //     },
                  //     child: const Text("Avvalgi")),
                  // const SizedBox(width: 15),
                  ElevatedButton(
                      onPressed: () {
                        controller.reset();
                        controller.repeat();
                        _timer!.cancel();
                        second = time;
                        startTimer();
                        selectIndex[currentIndex] = val;
                        if (currentIndex < test.length - 1) {
                          setState(() {
                            currentIndex++;
                            val = -1;
                          });
                        } else {
                          balance(test, correctIndex, selectIndex);
                        }
                      },
                      child: const Text("Keyingi")),
                ],
              )
            ],
          )
        ],
      ),
    );
  }

  balance(List<Map<String, dynamic>> test, List correct, List select) {
    _timer!.cancel();
    controller.dispose();
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => ResultPage(
              test: test,
              correctIndex: correct,
              selectIndex: select,
            )));
    // return showDialog(
    //   context: context,
    //   builder: (context) {
    //     return AlertDialog(
    //       contentPadding:
    //       const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
    //       title: const Text(
    //         "Tugatishni xohlaysizmi?",
    //         style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
    //       ),
    //       content: Row(
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         children: [
    //           ElevatedButton(
    //               onPressed: () {
    //                 Navigator.of(context).pop();
    //               },
    //               child: const Text("Yo'q")),
    //           const SizedBox(
    //             width: 10,
    //           ),
    //           ElevatedButton(
    //               onPressed: () {
    //                 Navigator.of(context).pop();
    //                 Navigator.of(context).pushReplacement(MaterialPageRoute(
    //                     builder: (context) => ResultPage(
    //                       test: test,
    //                       correctIndex: correct,
    //                       selectIndex: select,
    //                     )));
    //               },
    //               child: const Text("Ha"))
    //         ],
    //       ),
    //     );
    //   },
    // );
  }

  action(String title, int val, int v, int correct, Function() onChange) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
          color: color(val, v, correct).withOpacity(.3),
          border: Border.all(color: color(val, v, correct)==Colors.white?Colors.black:color(val, v, correct)),
          borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () {
          if (val == -1) {
            onChange();
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              customRadioButton(val, v, correct),
              const SizedBox(width: 5),
              Expanded(
                  child: Text(
                title,
                overflow: TextOverflow.clip,
              )),
            ],
          ),
        ),
      ),
    );
  }

  customRadioButton(int val, int v, int correct) {
    if (val == -1) {
      return const SizedBox();
    }
    if (val == correct && val == v) {
      return icon(Colors.green);
    } else {
      if (v == correct) {
        return icon(Colors.green);
      } else if (v == val) {
        return icon(Colors.red);
      }
    }
    return const SizedBox();
  }

  icon(Color color) {
    return Container(
      width: 18,
      height: 18,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(9),
          border: Border.all(color: color)),
      child: Center(
        child: Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5), color: color),
        ),
      ),
    );
  }

  Color color(int val, int v, int correct) {
    if (val == -1) {
      return Colors.white;
    }
    if (val == correct && val == v) {
      return Colors.green;
    } else {
      if (v == correct) {
        return Colors.green;
      } else if (v == val) {
        return Colors.red;
      }
    }
    return Colors.white;
  }
}
