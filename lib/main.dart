import 'package:flutter/material.dart';
import 'package:sup_dem_simulator/line_sample9.dart';
import 'package:sup_dem_simulator/model/cliente.dart';

import 'dart:io';
import 'package:ml_dataframe/ml_dataframe.dart';

import 'package:ml_algo/ml_algo.dart';

void main() {
  test();
  runApp(const MyApp());
}

void test() async {
  final data = <Iterable>[
    ['feature 1', 'feature 2', 'feature 3', 'outcome 1', 'outcome 2'],
    [5.0, 7.0, 6.0, 1.0, 0.0],
    [1.0, 2.0, 3.0, 0.0, 1.0],
  ];
  final targetNames = ['outcome 1', 'outcome 2'];
  final samples = DataFrame(data, headerExists: true);
  final classifier = SoftmaxRegressor(
    samples,
    targetNames,
    iterationsLimit: 100,
    initialLearningRate: 1.0,
    batchSize: 2,
    fitIntercept: true,
    interceptScale: 3.0,
  );

  const pathToFile = './classifier.json';

  await classifier.saveAsJson(pathToFile);

  final file = File(pathToFile);
  final json = await file.readAsString();
  final restoredClassifier = SoftmaxRegressor.fromJson(json);
  var result = restoredClassifier.predict(DataFrame(
    <Iterable>[
      ['feature 1', 'feature 2', 'feature 3'],
      [5.0, 7.0, 6.0]
    ],
  ));
  print(result);
  // here you can use previously fitted restored classifier to make
  // some prediction, e.g. via `restoredClassifier.predict(...)`;
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  //https://coolors.co/e83151-eaf8bf-31e871-177e89-001d4a
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.from(
        colorScheme: const ColorScheme(
          background: Color(0xffeaf8bf),
          onBackground: Color(0xff001d4a),
          brightness: Brightness.light,
          error: Color(0xffe83151),
          onError: Color(0xffe83151),
          primary: Color(0xff001d4a),
          onPrimary: Color.fromARGB(255, 230, 240, 255),
          secondary: Color(0xff177e89),
          onSecondary: Color(0xff177e89),
          surface: Color(0xffeaf8bf),
          onSurface: Color(0xffeaf8bf),
        ),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Cliente> domanda = [];

  @override
  void initState() {
    super.initState();
    domanda = List<Cliente>.generate(100, (index) => Cliente(1 / (index + 1), index + 1));
    //domanda.forEach((element) {
    //print(element.q.toString() + " -> " + element.c.toString());
    //});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: <Widget>[ElevatedButton(onPressed: () {}, child: const Text("Import CSV"))],
        ),
      ),
    );
  }
}
