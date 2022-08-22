import 'package:flutter/material.dart';

class Models extends StatefulWidget {
  const Models({Key? key}) : super(key: key);

  @override
  State<Models> createState() => _ModelsState();
}

class _ModelsState extends State<Models> with AutomaticKeepAliveClientMixin<Models> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GridView(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        crossAxisSpacing: 5.0,
        mainAxisSpacing: 5.0,
      ),
      children: [
        Card(
          child: Container(
            child: Text("Model 1"),
            width: 300,
            height: 300,
          ),
        ),
        Card(
          child: Container(
            child: Text("Model 1"),
            width: 300,
            height: 300,
          ),
        ),
        Card(
          child: Container(
            child: Text("Model 1"),
            width: 300,
            height: 300,
          ),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
