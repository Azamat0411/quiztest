import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quiztest/test_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final _countController = TextEditingController();
  final _timeController = TextEditingController();
  String _select = 'Animatsiya';
  final List _tests = ['Operatsion tizimlar', 'Animatsiya', 'MMB'];
  final List _test = ['operatsion', 'animatsiya', 'mmb'];
  String _selectedTest = 'animatsiya';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // const Spacer(),
            const Text("Test", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),),
            const SizedBox(height: 10),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: .5),
                  borderRadius: BorderRadius.circular(10)
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: DropdownButton<String>(
                  isExpanded: true,
                  underline: Container(
                    height: 0.0,
                    color: Colors.white,
                  ),
                  value: _select,
                  icon: const Icon(Icons.expand_more),
                  style: const TextStyle(color: Colors.white),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedTest = _test[_tests.indexOf(newValue!)];
                      _select = newValue;
                    });
                  },
                  items: _tests
                      .map((item) => DropdownMenuItem<String>(
                    value: item,
                    child: Text(
                      item,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ))
                      .toList(),
                ),
              ),
            ),
            _textField(controller: _countController, hintText: 'Test soni'),
            const SizedBox(height: 10),
            _textField(controller: _timeController, hintText: "Vaqt oralig'i"),
            const SizedBox(height: 10),
            ElevatedButton(onPressed: (){
              int time = int.tryParse(_timeController.text)??5;
              int count = int.tryParse(_countController.text)??5;
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => TestPage(test: _selectedTest, count: count, time: time)));
            }, child: const Text("Boshlash")),
            // const Spacer(),
            // const Text("Created by Saidqulov Azamat", style: TextStyle(fontSize: 15, fontWeight: Font),),
            // const SizedBox(height: 10)
          ],
        ),
      ),
    );
  }

  _textField({required TextEditingController controller, required String hintText}){
    return TextField(
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(2)],
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: Colors.blue,
            width: 0.5,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: Colors.grey,
            width: 0.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 0.5,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            15,
          ),
        ),
      ),
    );
  }
}
