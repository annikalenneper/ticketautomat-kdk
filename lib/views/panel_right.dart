import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ticket_alternative/styles/app_colors.dart';

class PanelRight extends StatefulWidget {
  const PanelRight({super.key});

  @override
  State<PanelRight> createState() => _PanelRightState();
}

class _PanelRightState extends State<PanelRight> {
  String _selectedDay = 'Donnerstag';

  Future<Map<String, dynamic>> _loadTimetable() async {
    final String response =
        await rootBundle.loadString('lib/assets/timetable.json');
    return json.decode(response);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.backgroundLight,
          border: Border.all(color: AppColors.black, width: 2),
        ),
        child: FutureBuilder<Map<String, dynamic>>(
          future: _loadTimetable(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return const Center(
                  child: Text('Fehler beim Laden des Timetables'));
            }

            final data = snapshot.data!;
            
            String topKey = 'djSlots${_selectedDay}Oben';
            String bottomKey = 'djSlots${_selectedDay}Unten';
            
            final slotsTop = data[topKey] as List;
            final slotsBottom = data[bottomKey] as List;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDaySelector(),
                const SizedBox(height: 20),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildStageSection('$_selectedDay - OBEN DRÜBER'.toUpperCase(), slotsTop),
                        const SizedBox(height: 20),
                        _buildStageSection('$_selectedDay - UNTEN DURCH'.toUpperCase(), slotsBottom),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildDaySelector() {
    final days = ['Donnerstag', 'Freitag', 'Samstag', 'Sonntag'];
    
    return Row(
      children: days.map((day) {
        final isSelected = _selectedDay == day;
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedDay = day;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : AppColors.white,
                  border: Border.all(color: AppColors.black, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.black,
                      offset: Offset(isSelected ? 2 : 4, isSelected ? 2 : 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    day.substring(0, 2).toUpperCase(),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: isSelected ? AppColors.white : AppColors.textDark,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildStageSection(String title, List slots) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(
          top: BorderSide(color: AppColors.black, width: 2),
          left: BorderSide(color: AppColors.black, width: 2),
          right: BorderSide(color: AppColors.black, width: 2),
          bottom: BorderSide(color: AppColors.black, width: 2),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.black,
            offset: Offset(4, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            decoration: const BoxDecoration(
              color: AppColors.primary,
              border: Border(
                bottom: BorderSide(color: AppColors.black, width: 2),
              ),
            ),
            child: Text(
              title,
              style: const TextStyle(
                color: AppColors.white,
                fontSize: 18,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.2,
              ),
            ),
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: slots.length,
            separatorBuilder: (context, index) => const Divider(
              height: 1,
              thickness: 1,
              color: AppColors.black,
            ),
            itemBuilder: (context, index) {
              final slot = slots[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.black,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        slot['startTime'],
                        style: const TextStyle(
                          color: AppColors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Text(
                        slot['djName'].toString().toUpperCase(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textDark,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
