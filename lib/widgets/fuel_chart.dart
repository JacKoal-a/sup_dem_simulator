import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class _LineChart extends StatelessWidget {
  _LineChart(this.outcomes);
  final List<double> outcomes;
  late BuildContext context;
  @override
  Widget build(BuildContext ct) {
    context = ct;
    return LineChart(LineChartData(
        gridData: gridData,
        titlesData: titlesData1,
        borderData: borderData,
        lineBarsData: [
          lineChartBarData1_1,
        ],
        minY: 0));
  }

  FlTitlesData get titlesData1 => FlTitlesData(
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      );

  FlGridData get gridData => FlGridData(show: true);

  FlBorderData get borderData => FlBorderData(
        show: true,
        border: Border(
          bottom: BorderSide(color: Theme.of(context).colorScheme.primary, width: 4),
          left: BorderSide(color: Theme.of(context).colorScheme.primary, width: 4),
          right: const BorderSide(color: Colors.transparent),
          top: const BorderSide(color: Colors.transparent),
        ),
      );

  LineChartBarData get lineChartBarData1_1 => LineChartBarData(
      isCurved: true,
      color: const Color(0xff31e871),
      barWidth: 4,
      isStrokeCapRound: true,
      dotData: FlDotData(show: false),
      belowBarData: BarAreaData(show: false),
      spots: List.generate(outcomes.length, (index) => FlSpot((index + 1).toDouble(), outcomes[index])));
}

class FuelChart extends StatefulWidget {
  const FuelChart(this.outcomes, {Key? key}) : super(key: key);
  final List<double> outcomes;
  @override
  State<StatefulWidget> createState() => FuelChartState();
}

class FuelChartState extends State<FuelChart> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.25,
      child: Stack(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(
                height: 20,
              ),
              Text(
                'Preditcted values',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: 2, color: Theme.of(context).colorScheme.primary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 30,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 16.0, left: 16.0),
                  child: _LineChart(widget.outcomes),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
