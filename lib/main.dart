import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter/material.dart';

import 'dart:io';
import 'package:ml_dataframe/ml_dataframe.dart';

import 'package:ml_algo/ml_algo.dart';
import 'package:sup_dem_simulator/pages/dashboard.dart';
import 'package:sup_dem_simulator/pages/models.dart';

void main() async {
  test();
  runApp(const MyApp());
}

void test() async {
  final data = <Iterable>[
    ['feature 1', 'feature 2', 'feature 3', 'outcome'],
    [5.0, 7.0, 6.0, 98.0],
    [1.0, 2.0, 3.0, 10.0],
    [10.0, 12.0, 31.0, -977.0],
    [9.0, 8.0, 5.0, 0.0],
    [4.0, 0.0, 1.0, 6.0],
    [5.0, 7.0, 6.0, 98.0],
    [1.0, 2.0, 3.0, 10.0],
    [10.0, 12.0, 31.0, -977.0],
    [9.0, 8.0, 5.0, 0.0],
    [4.0, 0.0, 1.0, 6.0],
    [5.0, 7.0, 6.0, 98.0],
    [1.0, 2.0, 3.0, 10.0],
    [10.0, 12.0, 31.0, -977.0],
    [9.0, 8.0, 5.0, 0.0],
    [4.0, 0.0, 1.0, 6.0],
    [5.0, 7.0, 6.0, 98.0],
    [1.0, 2.0, 3.0, 10.0],
    [10.0, 12.0, 31.0, -977.0],
    [9.0, 8.0, 5.0, 0.0],
    [4.0, 0.0, 1.0, 6.0],
    [5.0, 7.0, 6.0, 98.0],
    [1.0, 2.0, 3.0, 10.0],
    [10.0, 12.0, 31.0, -977.0],
    [9.0, 8.0, 5.0, 0.0],
    [4.0, 0.0, 1.0, 6.0],
  ];
  final samples = DataFrame(data, headerExists: true);
  final regressor = LinearRegressor(
    samples,
    'outcome',
    iterationsLimit: 100,
    learningRateType: LearningRateType.constant,
    initialLearningRate: 1.0,
    fitIntercept: true,
    interceptScale: 3.0,
  );

  const pathToFile = './classifier.json';

  await regressor.saveAsJson(pathToFile);

  final file = File(pathToFile);
  final json = await file.readAsString();
  final restoredRegressor = LinearRegressor.fromJson(json);

  // print('accuracy: ${restoredRegressor.assess(samples, MetricType.mape)}');
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  //https://coolors.co/e83151-eaf8bf-31e871-177e89-001d4a
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.from(
        colorScheme: const ColorScheme(
          background: Color(0xfffcfff1),
          onBackground: Color(0xff001d4a),
          brightness: Brightness.light,
          error: Color(0xffe83151),
          onError: Color(0xffe83151),
          primary: Color(0xff001d4a),
          onPrimary: Color(0xFFE6F0FF),
          secondary: Color(0xff177e89),
          onSecondary: Color(0xff177e89),
          surface: Color(0xfffcfff1),
          onSurface: Color(0xfffcfff1),
        ),
      ),
      home: const MyHomePage(title: 'Home Page'),
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
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    PageController page = PageController();
    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SideMenu(
            showToggle: false,
            controller: page,
            style: SideMenuStyle(
                displayMode: SideMenuDisplayMode.auto,
                hoverColor: Theme.of(context).colorScheme.primary.withOpacity(0.25),
                selectedColor: Theme.of(context).colorScheme.primary.withOpacity(1),
                selectedTitleTextStyle: const TextStyle(color: Colors.white),
                selectedIconColor: Colors.white,
                unselectedTitleTextStyle: TextStyle(color: Theme.of(context).colorScheme.background),
                unselectedIconColor: Theme.of(context).colorScheme.background,
                backgroundColor: Theme.of(context).colorScheme.secondary),
            title: Column(
              children: [
                ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxHeight: 0,
                      maxWidth: 0,
                    ),
                    child: Container()),
                const Divider(
                  indent: 8.0,
                  endIndent: 8.0,
                ),
              ],
            ),
            items: [
              SideMenuItem(
                priority: 0,
                title: 'Dashboard',
                onTap: () {
                  page.jumpToPage(0);
                },
                icon: const Icon(Icons.home),
              ),
              SideMenuItem(
                priority: 1,
                title: 'Models',
                onTap: () {
                  page.jumpToPage(1);
                },
                icon: const Icon(Icons.file_copy_rounded),
              ),
              SideMenuItem(
                priority: 2,
                title: 'Export',
                onTap: () {
                  page.jumpToPage(2);
                },
                icon: const Icon(Icons.download),
              ),
            ],
          ),
          Expanded(
            child: PageView(
              controller: page,
              children: const [
                Dashboard(),
                Models(),
                Center(
                  child: Text(
                    'Download',
                    style: TextStyle(fontSize: 35),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
