/// Gauge chart example, where the data does not cover a full revolution in the
/// chart.
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class GaugeChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;
  final double pi = 3.14;

  GaugeChart(this.seriesList, {this.animate});

  @override
  Widget build(BuildContext context) {
    return charts.PieChart(seriesList,
        animate: animate,
        defaultRenderer: charts.ArcRendererConfig(
            arcWidth: 18,
            startAngle: pi,
            arcLength: 2 * pi,
            arcRendererDecorators: [
              charts.ArcLabelDecorator(
                  labelPosition: charts.ArcLabelPosition.outside,
                  outsideLabelStyleSpec: charts.TextStyleSpec(
                      fontSize: 12,
                      color: charts.Color.fromHex(code: '#555555')))
            ]));
  }
}

/// Sample data type.
class GaugeSegment {
  final String segment;
  final double size;

  GaugeSegment(this.segment, this.size);
}
