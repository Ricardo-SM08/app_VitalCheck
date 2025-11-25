import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:vital_check1/main.dart'; // Para supabase

class SensorDetailScreen extends StatefulWidget {
  final String sensorName; // "Temperatura", "Ritmo Cardíaco", etc.
  const SensorDetailScreen({super.key, required this.sensorName});

  @override
  State<SensorDetailScreen> createState() => _SensorDetailScreenState();
}

class _SensorDetailScreenState extends State<SensorDetailScreen> {
  List<FlSpot> _chartData = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHistoryData();
  }

  Future<void> _loadHistoryData() async {
    try {
      final userId = supabase.auth.currentUser!.id;

      // Determinar qué columna consultar según el nombre del sensor
      String column = '';
      if (widget.sensorName == 'Temperatura') column = 'temperatura_celsius';
      if (widget.sensorName == 'Ritmo Cardíaco') column = 'frecuencia_cardiaca';
      // ... otros casos ...

      if (column.isEmpty) return;

      // Consultar historial (últimos 10 registros)
      final response = await supabase
          .from('registros_sensor')
          .select('fecha_registro, $column')
          .eq('id_usuario', userId)
          .order(
            'fecha_registro',
            ascending: false,
          ) // Del más reciente al más antiguo
          .limit(10);

      List<FlSpot> spots = [];
      // Invertir para que la gráfica vaya de izquierda (antiguo) a derecha (nuevo)
      final reversedData = List.from(response.reversed);

      for (int i = 0; i < reversedData.length; i++) {
        final val = reversedData[i][column];
        // Asegurarse de que sea double
        double yVal = (val is int) ? val.toDouble() : (val as double? ?? 0.0);
        spots.add(FlSpot(i.toDouble(), yVal));
      }

      setState(() {
        _chartData = spots;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint("Error cargando historial: $e");
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: Text(
          "Historial: ${widget.sensorName}",
          style: const TextStyle(color: Colors.white, fontSize: 20),
        ),
        backgroundColor: const Color(0xFF212121),
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                const SizedBox(height: 20),
                const Text(
                  "Últimos 10 registros",
                  style: TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 20),

                // Gráfica
                Container(
                  height: 300,
                  padding: const EdgeInsets.all(20),
                  margin: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: const Color(0xFF333333),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: _chartData.isEmpty
                      ? const Center(
                          child: Text(
                            "No hay datos históricos",
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      : LineChart(
                          LineChartData(
                            gridData: FlGridData(
                              show: true,
                              drawVerticalLine: true,
                            ),
                            titlesData: FlTitlesData(
                              show: true,
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ), // Ocultar etiquetas X por simplicidad
                              topTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              rightTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                            ),
                            borderData: FlBorderData(
                              show: true,
                              border: Border.all(color: Colors.white24),
                            ),
                            lineBarsData: [
                              LineChartBarData(
                                spots: _chartData,
                                isCurved: true,
                                color: const Color(0xFF004AAD),
                                barWidth: 4,
                                dotData: FlDotData(show: true),
                                belowBarData: BarAreaData(
                                  show: true,
                                  color: const Color(
                                    0xFF004AAD,
                                  ).withOpacity(0.3),
                                ),
                              ),
                            ],
                          ),
                        ),
                ),
              ],
            ),
    );
  }
}
