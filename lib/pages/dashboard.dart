import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  Dashboard(this.model, {Key? key}) : super(key: key);
  final String model;
  @override
  State<Dashboard> createState() => _DashboardState();
  final dynamic data = {
    "Model 1": {
      "name": "model 1",
      "csv": "|col1|col2|col3|",
      "desc": "Cool stuff but ok 00 0 0 0 00000 0 0 0 00 0000 00 0 0 0 0 0 0 0 00 0 0  0 0 0 0 0 00 0 ",
      "file": "m1.json"
    },
    "Model 2": {
      "name": "model 2",
      "csv": "|col1|col2|col3|",
      "desc": "Cool stuff but ok 0 0 0 0 00   0  0000000000 0 0 000 0 00 c           fwfwfwwf0 0 0",
      "file": "m2.json"
    }
  };
}

class _DashboardState extends State<Dashboard> with AutomaticKeepAliveClientMixin<Dashboard> {
  dynamic model;
  final ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    model = widget.data[widget.model];
    super.build(context);
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: SingleChildScrollView(
        controller: _controller,
        child: Column(
          children: [
            Text(model["name"]),
            const SizedBox(
              height: 20,
            ),
            Wrap(
              children: [
                Card(
                    child: Container(
                  padding: const EdgeInsets.all(12.0),
                  height: 400,
                  width: 400,
                  child: Text(model["desc"]),
                )),
                Column(
                  children: [
                    Card(
                        child: ConstrainedBox(
                            constraints: const BoxConstraints(
                              maxWidth: 400,
                            ),
                            child: Container(
                              padding: const EdgeInsets.all(12.0),
                              height: 200,
                              child: Text(model["desc"]),
                            ))),
                    Card(
                        child: ConstrainedBox(
                            constraints: const BoxConstraints(
                              maxWidth: 400,
                            ),
                            child: Container(
                              padding: const EdgeInsets.all(12.0),
                              height: 192,
                              width: 400,
                              child: Text(model["csv"]),
                            ))),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () {},
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Import CSV", style: TextStyle(color: Theme.of(context).colorScheme.background)),
                )),
            const SizedBox(
              height: 20,
            ),
            Text(model["csv"]),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
