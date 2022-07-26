import 'package:easy_sidemenu/easy_sidemenu.dart';

// ignore: implementation_imports
import 'package:easy_sidemenu/src/global/global.dart';
import 'package:flutter/material.dart';
import 'package:ml_dataframe/ml_dataframe.dart';
import 'package:sup_dem_simulator/pages/dashboard.dart';
import 'package:sup_dem_simulator/pages/export.dart';

void main() async {
  runApp(const MyApp());
}
/*
void test() async {
  final samples = await fromCsv('assets/train2.csv', headerExists: true, columnDelimiter: ',');

  final regressor = LinearRegressor(
    samples.shuffle(),
    'outcome',
    iterationsLimit: 100,
    learningRateType: LearningRateType.constant,
    initialLearningRate: 1.0,
    fitIntercept: true,
    interceptScale: 3.0,
  );

  const pathToFile = './building.json';

  await regressor.saveAsJson(pathToFile);

  final file = File(pathToFile);
  final json = await file.readAsString();
  final restoredRegressor = LinearRegressor.fromJson(json);

  print(
      'accuracy: ${100 - restoredRegressor.assess((await fromCsv("assets/train3.csv", headerExists: true, columnDelimiter: ',')), MetricType.mape)}');
}*/

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  //https://coolors.co/e83151-eaf8bf-31e871-177e89-001d4a
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData.from(
        colorScheme: const ColorScheme(
          background: Color(0xfffcfff1),
          onBackground: Color(0xff001d4a),
          brightness: Brightness.light,
          error: Color(0xffe83151),
          onError: Color(0xfffcfff1),
          primary: Color(0xff001d4a),
          onPrimary: Color(0xfffcfff1),
          secondary: Color(0xff177e89),
          onSecondary: Color(0xfffcfff1),
          surface: Color(0xfffcfff1),
          onSurface: Color.fromARGB(255, 151, 151, 151),
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
  List<GlobalKey<State<StatefulWidget>>> printKeys = [];

  String dropdownvalue = 'Fuel Model';
  var items = ['Fuel Model', 'Construction Model'];
  DataFrame samples = DataFrame([]);
  List<double> outcomes = [];
  List<List<String>> data = [];

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
                const SizedBox(
                  height: 8,
                ),
                ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxHeight: 150,
                    maxWidth: 150,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      'assets/logo.png',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxHeight: 300,
                      maxWidth: 300,
                    ),
                    child: Container(
                      decoration:
                          BoxDecoration(color: Theme.of(context).colorScheme.primary.withOpacity(0.6), borderRadius: BorderRadius.circular(5)),
                      child: PopupMenuButton<String>(
                          tooltip: "Choose Model",
                          onSelected: (String value) {
                            setState(() => dropdownvalue = value);
                            page.jumpToPage(0);
                          },
                          itemBuilder: (context) => items
                              .map((e) => PopupMenuItem<String>(
                                    value: e,
                                    child: Center(child: Text(e)),
                                  ))
                              .toList(),
                          child: InkWell(
                              highlightColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              splashColor: Colors.transparent,
                              child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 0),
                                  child: Container(
                                      height: 50,
                                      width: double.infinity,
                                      decoration: const BoxDecoration(
                                        color: Colors.transparent,
                                      ),
                                      child: ValueListenableBuilder(
                                          valueListenable: Global.displayModeState,
                                          builder: (context, value, child) => Padding(
                                                padding: EdgeInsets.symmetric(vertical: value == SideMenuDisplayMode.compact ? 0 : 8),
                                                child: Row(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: value == SideMenuDisplayMode.compact
                                                      ? [
                                                          const SizedBox(width: 8),
                                                          Icon(
                                                            Icons.arrow_drop_down_circle_outlined,
                                                            color: Theme.of(context).colorScheme.background,
                                                            size: 24,
                                                          ),
                                                          const SizedBox(
                                                            width: 8.0,
                                                          ),
                                                        ]
                                                      : [
                                                          const SizedBox(width: 8),
                                                          Icon(
                                                            Icons.arrow_drop_down_circle_outlined,
                                                            color: Theme.of(context).colorScheme.background,
                                                            size: 24,
                                                          ),
                                                          const SizedBox(
                                                            width: 8.0,
                                                          ),
                                                          Expanded(
                                                            child: Text(
                                                              dropdownvalue,
                                                              style: TextStyle(fontSize: 17, color: Theme.of(context).colorScheme.background),
                                                            ),
                                                          )
                                                        ],
                                                ),
                                              )))))),
                    ),
                  ),
                ),
                const Divider(
                  indent: 8.0,
                  endIndent: 8.0,
                ),
              ],
            ),
            items: [
              SideMenuItem(
                priority: 2,
                title: 'Home Page',
                onTap: () {
                  page.jumpToPage(0);
                },
                icon: const Icon(Icons.home),
              ),
              SideMenuItem(
                priority: 2,
                title: 'Export',
                onTap: () {
                  page.jumpToPage(1);
                },
                icon: const Icon(Icons.download),
              )
            ],
          ),
          Expanded(
            child: PageView(
              controller: page,
              children: [Dashboard(dropdownvalue, (List<List<String>> list) => setState(() => data = list)), Export(data, dropdownvalue)],
            ),
          ),
        ],
      ),
    );
  }
}
