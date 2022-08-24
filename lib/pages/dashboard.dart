import 'dart:io';
import 'dart:math';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ml_algo/ml_algo.dart';
import 'package:ml_dataframe/ml_dataframe.dart';
import 'package:sup_dem_simulator/widgets/bar_chart.dart';
import 'package:sup_dem_simulator/widgets/fuel_chart.dart';
import 'package:sup_dem_simulator/widgets/mouse_scrollcontroller.dart';
import '../widgets/pie_chart.dart';

class Dashboard extends StatefulWidget {
  Dashboard(this.model, this.sendData, {Key? key}) : super(key: key);
  final String model;
  final Function sendData;

  @override
  State<Dashboard> createState() => _DashboardState();
  final dynamic data = {
    "Fuel Model": {
      "id": 0,
      "name": "Fuel Model",
      "csv": "price, excise, inflation",
      "csv_desc": "price: Current fuel price\nexcise: Current excise duty\ninflation: Inflation rate",
      "desc":
          "A Linear Regressor trained on fuel data that allows to predict next years' prices based on given fuel prices, the excise duty applied and the inflation rate",
      "file": "assets/models/fuel_model.json",
      "accuracy": 99.37378,
      "samples": 25
    },
    "Construction Model": {
      "id": 1,
      "name": "Construction Model",
      "csv": "demand, damage, inflation",
      "csv_desc": "price: Previous market value\ndamage: Caused damage  \ninflation: Inflation rate",
      "desc":
          "A Linear Regressor trained on real estate market's data that allows to predict the variation that occurs in the market value after the damage caused by a natural disaster",
      "file": "assets/models/construction_model.json",
      "accuracy": 90.6826,
      "samples": 55
    }
  };
}

class _DashboardState extends State<Dashboard> with AutomaticKeepAliveClientMixin<Dashboard> {
  dynamic model;
  final AdjustableScrollController _controller = AdjustableScrollController();
  List<bool> input = [false, false];
  List<List<double>> outcomes = [[], []];
  List<double> secondary = [];
  List<List<String>> list = [];

  @override
  Widget build(BuildContext context) {
    super.build(context);
    model = widget.data[widget.model];
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Scrollbar(
        child: SingleChildScrollView(
          controller: _controller,
          child: Column(
            children: [
              Text(
                model["name"],
                style: TextStyle(color: Theme.of(context).colorScheme.secondary, fontSize: 35, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 20,
              ),
              Wrap(
                children: [
                  Card(
                      elevation: 4,
                      child: Container(
                        padding: const EdgeInsets.all(12.0),
                        height: 400,
                        width: 400,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Statistics",
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            _stats(model["accuracy"])
                          ],
                        ),
                      )),
                  Column(
                    children: [
                      Card(
                          elevation: 4,
                          child: ConstrainedBox(
                              constraints: const BoxConstraints(
                                maxWidth: 400,
                              ),
                              child: Container(
                                padding: const EdgeInsets.all(12.0),
                                height: 200,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Description",
                                      style: Theme.of(context).textTheme.titleLarge,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        model["desc"],
                                        style: const TextStyle(fontSize: 18),
                                      ),
                                    ),
                                  ],
                                ),
                              ))),
                      Card(
                          elevation: 4,
                          child: ConstrainedBox(
                              constraints: const BoxConstraints(
                                maxWidth: 400,
                              ),
                              child: Container(
                                padding: const EdgeInsets.all(12.0),
                                height: 192,
                                width: 400,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "CSV Format",
                                      style: Theme.of(context).textTheme.titleLarge,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        model["csv"],
                                        style: const TextStyle(fontWeight: FontWeight.w200, fontSize: 24),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        model["csv_desc"],
                                        style: const TextStyle(fontSize: 18),
                                      ),
                                    ),
                                  ],
                                ),
                              ))),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: _pickCSV,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Import CSV", style: TextStyle(color: Theme.of(context).colorScheme.background)),
                  )),
              const SizedBox(
                height: 20,
              ),
              if (input[model["id"]]) _generateChart(),
              if (input[model["id"]]) _generateTable(),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  Future<void> _pickCSV() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      initialDirectory: Directory.current.path,
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );

    if (result != null) {
      try {
        final samples = await fromCsv(result.files.single.path!, headerExists: true, columnDelimiter: ',');
        final ml = await rootBundle.loadString(model["file"]);
        final restoredRegressor = LinearRegressor.fromJson(ml);
        final resultml = restoredRegressor.predict(samples);
        outcomes[model["id"]] = [];

        resultml.rows.forEach(((element) => outcomes[model["id"]].add(element.first)));

        for (int i = 0; i < outcomes.length; i++) {
          outcomes[model["id"]][i] = double.parse((outcomes[model["id"]][i]).toStringAsFixed(5));
        }

        if (model["id"] == 1) {
          secondary = [];
          for (var element in samples.rows) {
            secondary.add(element.first);
          }
        }
        list = [];
        List<String> h = samples.header.toList();

        h.add("outcome");
        list.add(h);
        for (int i = 0; i < samples.rows.length; i++) {
          List<String> row = [];
          if (model["id"] == 0) {
            for (int j = 0; j < samples.rows.elementAt(i).length; j++) {
              if (j == 2) {
                row.add((samples.rows.elementAt(i).elementAt(j) * 100).toStringAsFixed(2));
              } else {
                row.add(samples.rows.elementAt(i).elementAt(j).toString());
              }
            }
          } else {
            for (int j = 0; j < samples.rows.elementAt(i).length; j++) {
              if (j == 0 || j == 1) {
                row.add((samples.rows.elementAt(i).elementAt(j) * 10000).toStringAsFixed(2));
              } else {
                row.add(samples.rows.elementAt(i).elementAt(j).toString());
              }
            }
          }

          if (model["id"] == 0) {
            row.add(outcomes[model["id"]][i].toStringAsFixed(5));
          } else {
            row.add((outcomes[model["id"]][i] * 10000).toStringAsFixed(2));
          }
          list.add(row);
        }
        setState(() {
          widget.sendData(list);

          input[model["id"]] = true;
        });
        showDialog(
          context: context,
          builder: (BuildContext context) => _buildPopupDialog(
              context,
              const Text("Check out the generated report and the export section to download the pdf"),
              "Report Generated",
              Theme.of(context).colorScheme.primary),
        );
      } catch (e) {
        setState(() {
          input[model["id"]] = false;
        });

        showDialog(
          context: context,
          builder: (BuildContext context) => _buildPopupDialog(
              context, const Text("Invalid CSV format\nPlease check your file and try again"), "Error", Theme.of(context).colorScheme.error),
        );
      }
    }
  }

  Widget _buildPopupDialog(BuildContext context, Widget body, String title, Color color) {
    return AlertDialog(
      title: Text(title, style: Theme.of(context).textTheme.titleLarge!.merge(TextStyle(color: color))),
      content: body,
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            'Close',
            style: TextStyle(color: color),
          ),
        ),
      ],
    );
  }

  Widget _generateChart() {
    return ConstrainedBox(
        constraints: BoxConstraints(maxWidth: model["id"] == 0 ? 800 : 1000, maxHeight: 800),
        child: Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: model["id"] == 0 ? FuelChart(outcomes[model["id"]]) : BarChartSample2(getRandomString(32), secondary, outcomes[model["id"]]),
            )));
  }

  static const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  final Random _rnd = Random();
  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  Widget _generateTable() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Table(
            defaultColumnWidth: const FixedColumnWidth(120.0),
            border: TableBorder.all(color: Colors.black, style: BorderStyle.solid, width: 2),
            children: [
              TableRow(
                children: List.generate(
                    list.first.length + 1,
                    (index) => Column(children: [
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(index == 0 ? "" : list.first[index - 1], style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
                          )
                        ])),
              ),
              ...List.generate(
                list.length - 1,
                (index) => TableRow(
                    children: List.generate(
                        list.first.length + 1,
                        (index2) => Column(children: [
                              Text(
                                index2 == 0 ? (index + 1).toString() : (list[index + 1][index2 - 1]),
                                style: const TextStyle(
                                  fontSize: 14.0,
                                ),
                              )
                            ]))),
              )
            ]),
      ),
    );
  }

  Widget _stats(double accuracy) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 20,
          ),
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 180,
              ),
              child: AspectRatio(
                aspectRatio: 1,
                child: PieChart(
                  strokeWidth: 15,
                  data: [
                    PieChartData(const Color(0xff31e871), accuracy),
                    if ((100 - accuracy) > 1) PieChartData(const Color.fromARGB(14, 0, 0, 0), (100 - accuracy))
                  ],
                  radius: 60,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "${accuracy.toStringAsFixed(2)}%",
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                      ),
                      Text(
                        "accuracy",
                        style: Theme.of(context).textTheme.subtitle1,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          Text(
            "Accuracy: ${accuracy.toStringAsFixed(2)}",
            style: const TextStyle(fontSize: 18),
          ),
          Text(
            "Training samples: ${model['samples']}",
            style: const TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}
