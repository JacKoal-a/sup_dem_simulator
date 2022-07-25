import 'package:flutter/material.dart';
import 'package:sup_dem_simulator/line_sample9.dart';
import 'package:sup_dem_simulator/model/cliente.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[LineChartSample9()],
        ),
      ),
    );
  }
}
