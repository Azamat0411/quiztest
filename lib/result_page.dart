import 'package:flutter/material.dart';
import 'package:quiztest/main.dart';

class ResultPage extends StatelessWidget {
  List<Map<String, dynamic>> test;
  List correctIndex;
  List selectIndex;
  ResultPage({Key? key, required this.test, required this.correctIndex, required this.selectIndex}) : super(key: key);

  double result(){
    int count = 0;
    for(int i = 0; i<correctIndex.length;i++){
      if(correctIndex[i]==selectIndex[i]){
        count++;
      }
    }
    return count/correctIndex.length*100;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Natija"),
        automaticallyImplyLeading: true,
        actions: [
          IconButton(onPressed: (){
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => const MyHomePage()));
          }, icon: const Icon(Icons.refresh))
        ],
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text("Natija: ${result().toStringAsFixed(0)}%", style: const TextStyle(fontSize: 20),),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: test.length,
                itemBuilder: (context, index){
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.black)
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("${index+1}. " + test[index]['question'], style: TextStyle(fontWeight: FontWeight.w600),),
                    const SizedBox(height: 5),
                    check(correctIndex[index], selectIndex[index]),
                    correctIndex[index] != selectIndex[index]&&selectIndex[index]!=-1?const SizedBox(height: 5,):const SizedBox(),
                    correctIndex[index] != selectIndex[index]&&selectIndex[index]!=-1?Row(
                      children: [
                        Container(
                          width: 18,
                          height: 18,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(9),
                              border: Border.all(color: Colors.red)
                          ),
                          child: Center(
                            child: Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.red
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 5),
                        Expanded(child: Text(test[index]['answer'][selectIndex[index]]))
                      ],
                    ):const SizedBox(),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Container(
                          width: 18,
                          height: 18,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(9),
                            border: Border.all(color: Colors.green)
                          ),
                          child: Center(
                            child: Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.green
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 5),
                        Expanded(child: Text(test[index]['answer'][correctIndex[index]]))
                      ],
                    )
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Text check(int correct, int select){
    String text = '';
    Color textColor = Colors.black;
    if(select == -1){
      text = "Belgilanmagan";
      textColor = Colors.black;
    }else if(correct != select){
      text = "Noto'g'ri javob";
      textColor = Colors.red;
    }
    if(correct == select){
      text = "To'g'ri javob";
      textColor = Colors.green;
    }
    return Text(text, style: TextStyle(color: textColor),);
  }


}
