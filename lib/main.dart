import 'package:flutter/material.dart';
import 'package:sup_dem_simulator/line_sample9.dart';
import 'package:sup_dem_simulator/model/cliente.dart';

void main() {
  runApp(const MyApp());
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
