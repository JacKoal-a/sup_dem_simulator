import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ml_algo/ml_algo.dart';
import 'package:ml_dataframe/ml_dataframe.dart';
import 'package:sup_dem_simulator/widgets/fuel_chart.dart';
import '../widgets/pie_chart.dart';

class Dashboard extends StatefulWidget {
  Dashboard(this.model, this.sendData, {Key? key}) : super(key: key);
  final String model;
  final Function sendData;

  @override
  State<Dashboard> createState() => _DashboardState();
  final dynamic data = {
    "Fuel Model": {
      "id": 1,
      "name": "Fuel Model",
      "csv": "| price | excise | inflation |",
      "csv_desc": "price: Current fuel price\nexcise: Current excise duty\ninflation: Inflation rate",
      "desc":
          "A Linear Regresson trained on fuel data that allows to predict a series of future prices based on given fuel prices, the excise duty applied and the inflation rate",
      "file": "assets/models/fuel_model.json",
      "accuracy": 99.37378,
      "samples": 25
    },
    "Model 2": {
      "id": 2,
      "name": "model 2",
      "csv": "| price | excise | inflation |",
      "csv_desc": "price: Current fuel price\nexcise: Current excise duty\ninflation: Inflation rate",
      "desc":
          "A Linear Regresson trained on fuel data that allows to predict a series of future prices based on given fuel prices, the excise duty applied and the inflation rate",
      "file": "assets/models/fuel_model.json",
      "accuracy": 89.6826
    }
  };
}

class _DashboardState extends State<Dashboard> with AutomaticKeepAliveClientMixin<Dashboard> {
  dynamic model;
  final ScrollController _controller = ScrollController();
  bool input = false;
  List<double> outcomes = [], secondary = [];
  List<List<String>> list = [];
  @override
  Widget build(BuildContext context) {
    model = widget.data[widget.model];
    super.build(context);
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
              if (input) _generateChart(),
              if (input) _generateTable(),
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
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );

    if (result != null) {
      try {
        final samples = await fromCsv(result.files.single.path!, headerExists: true, columnDelimiter: ',');
        final ml = await rootBundle.loadString(model["file"]);
        final restoredRegressor = LinearRegressor.fromJson(ml);
        final resultml = restoredRegressor.predict(samples);

        outcomes = [];
        secondary = [];
        resultml.rows.forEach(((element) => outcomes.add(element.first)));
        samples.rows.forEach(((element) => secondary.add(element.first)));
        for (int i = 0; i < outcomes.length; i++) {
          outcomes[i] = double.parse(outcomes[i].toStringAsFixed(5));
        }
        list = [];
        List<String> h = samples.header.toList();
        h.add("outcome");
        list.add(h);
        for (int i = 0; i < samples.rows.length; i++) {
          List<String> row = [];

          samples.rows.elementAt(i).toList().forEach((element) {
            row.add(element.toString());
          });
          row.add(outcomes[i].toStringAsFixed(5));
          list.add(row);
        }
        setState(() {
          widget.sendData(list);
        });
      } catch (e) {
        setState(() {
          input = false;
        });

        showDialog(
          context: context,
          builder: (BuildContext context) => _buildPopupDialog(
              context, const Text("Invalid CSV format\nPlease check your file and try again"), "Error", Theme.of(context).colorScheme.error),
        );
      }

      setState(() {
        input = true;
      });

      showDialog(
        context: context,
        builder: (BuildContext context) => _buildPopupDialog(context, const Text("Done dude CSV"), "Done", Theme.of(context).colorScheme.primary),
      );
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
        constraints: const BoxConstraints(maxWidth: 800, maxHeight: 800),
        child: Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: FuelChart(secondary, outcomes),
            )));
  }

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
                    list.first.length,
                    (index) => Column(children: [
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(list.first[index], style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
                          )
                        ])),
              ),
              ...List.generate(
                list.length - 1,
                (index) => TableRow(
                    children: List.generate(
                        list.first.length,
                        (index2) => Column(children: [
                              Text(
                                list[index + 1][index2],
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
          const Text(
            "Learning Rate: 1.0 constant",
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}
