import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:ticket_alternative/styles/app_colors.dart';
import 'package:ticket_alternative/models/button_metrics.dart';
import 'package:ticket_alternative/dialogues/faq_dialogues.dart';

class ButtonMetricsDialog extends StatefulWidget {
  const ButtonMetricsDialog({super.key});

  @override
  State<ButtonMetricsDialog> createState() => _ButtonMetricsDialogState();
}

class _ButtonMetricsDialogState extends State<ButtonMetricsDialog> {
  ButtonMetrics? _metrics;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final pushData = await ButtonMetricsService.loadPushData();
    setState(() {
      _metrics = ButtonMetrics(pushData);
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          border: Border.all(color: AppColors.black, width: 3),
          boxShadow: const [
            BoxShadow(
              color: AppColors.black,
              offset: Offset(8, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(context),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _buildContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: const BoxDecoration(
        color: AppColors.secondary,
        border: Border(
          bottom: BorderSide(color: AppColors.black, width: 2),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'BUTTON METRIKEN',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: AppColors.white,
              letterSpacing: 1.5,
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).pop();
              showDialog(
                context: context,
                builder: (context) => const AutomatFeaturesDialog(),
              );
            },
            icon: const Icon(
              Icons.close,
              color: AppColors.white,
              size: 26,
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (_metrics == null) return const SizedBox();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Linke Seite: Incident-Werte (~1/3)
          Expanded(
            flex: 1,
            child: _buildStatsColumn(),
          ),
          const SizedBox(width: 12),
          // Rechte Seite: Timeline-Charts untereinander (~2/3)
          Expanded(
            flex: 2,
            child: _buildChartsColumn(),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsColumn() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.backgroundLight,
            border: Border.all(color: AppColors.black, width: 2),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildGroupTitle('ANZAHL'),
              const SizedBox(height: 6),
              _buildStatRow('Gesamt', _metrics!.totalPushes.toString()),
              _buildStatRow('Heute', _metrics!.pushesToday.toString()),
              _buildStatRow('Letzte Std', _metrics!.pushesLastHour.toString()),
              const SizedBox(height: 10),
              _buildGroupTitle('DURCHSCHNITT'),
              const SizedBox(height: 6),
              _buildStatRow('Pro Stunde', _metrics!.averagePushesPerHour.toStringAsFixed(1)),
              const SizedBox(height: 10),
              _buildGroupTitle('ZEITRAUM'),
              const SizedBox(height: 6),
              _buildStatRow('Erster', _formatCompactDate(_metrics!.firstPush)),
              _buildStatRow('Letzter', _formatCompactDate(_metrics!.lastPush)),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 200,
          child: _buildNightShiftPieChart(),
        ),
      ],
    );
  }

  Widget _buildGroupTitle(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      color: AppColors.secondary,
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w800,
          color: AppColors.white,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textMedium,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w900,
              color: AppColors.secondary,
            ),
          ),
        ],
      ),
    );
  }

  String _formatCompactDate(DateTime? dt) {
    if (dt == null) return '-';
    return '${dt.day}.${dt.month}. ${dt.hour}:${dt.minute.toString().padLeft(2, '0')}';
  }

  Widget _buildChartsColumn() {
    return Column(
      children: [
        SizedBox(height: 180, child: _buildHourlyChart()),
        const SizedBox(height: 8),
        SizedBox(height: 180, child: _buildDailyChart()),
        const SizedBox(height: 8),
        SizedBox(height: 180, child: _buildTimeOfDayChart()),
      ],
    );
  }

  double _calcInterval(double maxY) {
    if (maxY <= 10) return 2;
    if (maxY <= 25) return 5;
    if (maxY <= 50) return 10;
    if (maxY <= 100) return 20;
    if (maxY <= 250) return 50;
    if (maxY <= 500) return 100;
    return 200;
  }

  double _calcMaxY(double dataMax, double minDefault) {
    if (dataMax < minDefault) return minDefault;
    // Runde auf nächsten sinnvollen Wert
    final interval = _calcInterval(dataMax);
    return ((dataMax / interval).ceil() * interval).toDouble() + interval;
  }

  Widget _buildHourlyChart() {
    final data = _metrics!.pushesLast12Hours;
    final dataMax = data.values.isEmpty ? 0.0 : data.values.reduce((a, b) => a > b ? a : b).toDouble();
    final maxY = _calcMaxY(dataMax, 5);
    final interval = _calcInterval(maxY);

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        border: Border.all(color: AppColors.black, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: _buildChartTitle('PUSHES PRO STUNDE (letzte 12h)'),
          ),
          const SizedBox(height: 4),
          Expanded(
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: maxY,
                barTouchData: BarTouchData(enabled: false),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final hour = 11 - value.toInt();
                        if (hour % 2 != 0 && hour != 11) return const SizedBox();
                        return Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                            hour == 0 ? 'jetzt' : '-${hour}h',
                            style: const TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textMedium,
                            ),
                          ),
                        );
                      },
                      reservedSize: 16,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 28,
                      interval: interval,
                      getTitlesWidget: (value, meta) {
                        if (value == value.roundToDouble() && value >= 0) {
                          return Text(
                            value.toInt().toString(),
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textMedium,
                            ),
                          );
                        }
                        return const SizedBox();
                      },
                    ),
                  ),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: AppColors.black.withValues(alpha: 0.1),
                    strokeWidth: 1,
                  ),
                ),
                borderData: FlBorderData(show: false),
                barGroups: List.generate(12, (index) {
                  final reversedIndex = 11 - index;
                  return BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: (data[reversedIndex] ?? 0).toDouble(),
                        color: AppColors.primary,
                        width: 8,
                        borderRadius: BorderRadius.zero,
                        borderSide: const BorderSide(color: AppColors.black, width: 1),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDailyChart() {
    final data = _metrics!.pushesLast4Days;
    final dataMax = data.values.isEmpty ? 0.0 : data.values.reduce((a, b) => a > b ? a : b).toDouble();
    final maxY = _calcMaxY(dataMax, 20);
    final interval = _calcInterval(maxY);
    final weekdays = ['Heute', 'Gestern', 'Vorges.', '-3 Tage'];

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        border: Border.all(color: AppColors.black, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: _buildChartTitle('PUSHES PRO TAG (letzte 4 Tage)'),
          ),
          const SizedBox(height: 4),
          Expanded(
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: maxY,
                barTouchData: BarTouchData(enabled: false),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                            weekdays[value.toInt()],
                            style: const TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textMedium,
                            ),
                          ),
                        );
                      },
                      reservedSize: 16,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 28,
                      interval: interval,
                      getTitlesWidget: (value, meta) {
                        if (value == value.roundToDouble() && value >= 0) {
                          return Text(
                            value.toInt().toString(),
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textMedium,
                            ),
                          );
                        }
                        return const SizedBox();
                      },
                    ),
                  ),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: AppColors.black.withValues(alpha: 0.1),
                    strokeWidth: 1,
                  ),
                ),
                borderData: FlBorderData(show: false),
                barGroups: List.generate(4, (index) {
                  return BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: (data[index] ?? 0).toDouble(),
                        color: index == 0 ? AppColors.primary : AppColors.secondary,
                        width: 16,
                        borderRadius: BorderRadius.zero,
                        borderSide: const BorderSide(color: AppColors.black, width: 1),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeOfDayChart() {
    final data = _metrics!.pushesPerHourOfDay;
    final dataMax = data.values.isEmpty ? 0.0 : data.values.reduce((a, b) => a > b ? a : b).toDouble();
    final maxY = _calcMaxY(dataMax, 10);
    final interval = _calcInterval(maxY);

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        border: Border.all(color: AppColors.black, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: _buildChartTitle('VERTEILUNG NACH UHRZEIT (0-24h)'),
          ),
          const SizedBox(height: 4),
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: AppColors.black.withValues(alpha: 0.1),
                    strokeWidth: 1,
                  ),
                ),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 16,
                      interval: 4,
                      getTitlesWidget: (value, meta) {
                        final hour = value.toInt();
                        if (hour % 4 != 0) return const SizedBox();
                        return Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                            '$hour:00',
                            style: const TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textMedium,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 28,
                      interval: interval,
                      getTitlesWidget: (value, meta) {
                        if (value == value.roundToDouble() && value >= 0) {
                          return Text(
                            value.toInt().toString(),
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textMedium,
                            ),
                          );
                        }
                        return const SizedBox();
                      },
                    ),
                  ),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: 23,
                minY: 0,
                maxY: maxY,
                lineBarsData: [
                  LineChartBarData(
                    spots: List.generate(24, (index) {
                      return FlSpot(index.toDouble(), (data[index] ?? 0).toDouble());
                    }),
                    isCurved: true,
                    color: AppColors.secondary,
                    barWidth: 2,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: AppColors.secondary.withValues(alpha: 0.2),
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

  Widget _buildChartTitle(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: const BoxDecoration(
        color: AppColors.secondary,
        border: Border(
          left: BorderSide(color: AppColors.black, width: 2),
        ),
      ),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: AppColors.white,
          letterSpacing: 0.3,
        ),
      ),
    );
  }

  Widget _buildNightShiftPieChart() {
    final data = _metrics!.pushesPerDay;
    final total = data.values.fold(0, (sum, val) => sum + val);
    
    final colors = [
      AppColors.primary,
      AppColors.secondary,
      const Color(0xFFFF9800),
      const Color(0xFF4CAF50),
    ];

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        border: Border.all(color: AppColors.black, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: _buildChartTitle('ANZAHL PRO TAG'),
          ),
          const SizedBox(height: 4),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: total == 0
                      ? const Center(
                          child: Text(
                            'Keine Daten',
                            style: TextStyle(
                              color: AppColors.textMedium,
                              fontSize: 12,
                            ),
                          ),
                        )
                      : PieChart(
                          PieChartData(
                            sectionsSpace: 2,
                            centerSpaceRadius: 20,
                            sections: data.entries.toList().asMap().entries.map((entry) {
                              final idx = entry.key;
                              final dayEntry = entry.value;
                              final value = dayEntry.value.toDouble();
                              final percent = total > 0 ? (value / total * 100) : 0;
                              return PieChartSectionData(
                                color: colors[idx % colors.length],
                                value: value,
                                title: percent > 5 ? '${percent.toStringAsFixed(0)}%' : '',
                                radius: 35,
                                titleStyle: const TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.white,
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                ),
                const SizedBox(width: 8),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: data.entries.toList().asMap().entries.map((entry) {
                    final idx = entry.key;
                    final dayEntry = entry.value;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 1),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            color: colors[idx % colors.length],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${dayEntry.key}: ${dayEntry.value}',
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textMedium,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
