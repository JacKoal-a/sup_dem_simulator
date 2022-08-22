import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> with AutomaticKeepAliveClientMixin<Dashboard> {
  int num = 0;

  String dropdownvalue = 'Model 1';

  // List of items in our dropdown menu
  var items = ['Model 1', 'Model 2', 'Model 3'];

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
            decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary, borderRadius: BorderRadius.circular(10)),
            child: DropdownButton<String>(
              dropdownColor: Theme.of(context).colorScheme.primary,
              value: dropdownvalue,
              onChanged: (String? newValue) => setState(() => dropdownvalue = newValue!),
              items: items
                  .map<DropdownMenuItem<String>>((String value) => DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(color: Theme.of(context).colorScheme.background),
                        ),
                      ))
                  .toList(),
              icon: Icon(
                Icons.arrow_drop_down,
                color: Theme.of(context).colorScheme.background,
              ),
              iconSize: 26,
              underline: const SizedBox(),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          ElevatedButton(
              onPressed: () {},
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Import CSV", style: TextStyle(color: Theme.of(context).colorScheme.background)),
              )),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
