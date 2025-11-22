import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:vital_check1/screen/indicadores_screen.dart'; 

class SensorDetailScreen extends StatefulWidget {
  final String sensorName;
  const SensorDetailScreen({super.key, required this.sensorName});

  @override
  State<SensorDetailScreen> createState() => _SensorDetailScreenState();
}

class _SensorDetailScreenState extends State<SensorDetailScreen> {
  final List<FlSpot> _chartData = const [
    FlSpot(0, 18), 
    FlSpot(1, 27), 
    FlSpot(2, 25), 
    FlSpot(3, 30), 
    FlSpot(4, 36), 
    FlSpot(5, 24), 
    FlSpot(6, 12), 
    FlSpot(7, 30), 
    FlSpot(8, 36), 
    FlSpot(9, 19), 
  ];

  final List<String> _xAxisLabels = const [
    'Oct 28',
    'Oct 29',
    'Oct 30',
    'Oct 31',
    'Nov 1',
    'Nov 2',
    'Nov 3',
    'Nov 4',
    'Nov 5',
    'Nov 6',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212), 
      appBar: AppBar(
        title: Text(
          widget.sensorName,
          style: const TextStyle(color: Colors.white, fontSize: 24),
        ),
        backgroundColor: const Color(0xFF212121), 
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
            context, 
            MaterialPageRoute(
              builder: (context) => const IndicadoresScreen(), 
            ),
          );
        },
        ),
      ),
      body: Column(
        children: <Widget>[
          Container(
            height: 250, 
            margin: const EdgeInsets.all(15),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF333333),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.only(right: 18.0, left: 12.0, top: 24, bottom: 12),
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: true,
                    horizontalInterval: 10, 
                    verticalInterval: 1, 
                    getDrawingHorizontalLine: (value) {
                      return const FlLine(
                        color: Color.fromARGB(255, 255, 255, 255), 
                        strokeWidth: 1,
                      );
                    },
                    getDrawingVerticalLine: (value) {
                      return const FlLine(
                        color: Color.fromARGB(255, 255, 255, 255), 
                        strokeWidth: 1,
                      );
                    },
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        interval: 1,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() >= 0 && value.toInt() < _xAxisLabels.length) {
                            return SideTitleWidget(
                              axisSide: meta.axisSide,
                              space: 8.0,
                              child: Text(_xAxisLabels[value.toInt()], style: const TextStyle(color: Color.fromARGB(255, 255, 255, 255), fontSize: 7)),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 10, 
                        getTitlesWidget: (value, meta) {
                          return Text('${value.toInt()}', style: const TextStyle(color: Color.fromARGB(255, 255, 255, 255), fontSize: 10));
                        },
                        reservedSize: 40,
                      ),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(color: const Color.fromARGB(255, 255, 255, 255), width: 1),
                  ),
                  minX: 0,
                  maxX: _chartData.length.toDouble() - 1, 
                  minY: 0,
                  maxY: 40, 
                  lineBarsData: [
                    LineChartBarData(
                      spots: _chartData,
                      isCurved: true, 
                      gradient: const LinearGradient( 
                        colors: [
                          Color(0xFF004AAD),
                          Color(0xFF004AAD),
                        ],
                      ),
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: const FlDotData(show: false), 
                      belowBarData: BarAreaData(show: false), 
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 20), 

          Expanded(
            child: ListView.builder(
              itemCount: 4, 
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
                  child: Container(
                    height: 80, 
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: const Color(0xFF333333), 
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row( 
                      children: [
                        const CircleAvatar( 
                          radius: 25,
                          backgroundColor: Color(0xFF004AAD),
                        ),
                        const SizedBox(width: 15), 
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container( 
                                width: double.infinity,
                                height: 10,
                                color: Colors.grey,
                                margin: EdgeInsets.only(bottom: 8),
                              ),
                              Container(
                                width: double.infinity,
                                height: 10,
                                color: Colors.grey,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}