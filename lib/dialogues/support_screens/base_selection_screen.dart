import 'package:flutter/material.dart';
import 'package:ticket_alternative/styles/app_colors.dart';

/// Datenstruktur für Auswahl-Button
class SelectionButtonData {
  final IconData icon;
  final String text;
  final String value;
  final Color? iconColor;

  const SelectionButtonData({
    required this.icon,
    required this.text,
    required this.value,
    this.iconColor,
  });
}

/// Basis-Klasse für Auswahl-Screens
abstract class BaseSelectionScreen extends StatelessWidget {
  final Function(String) onSelection;

  const BaseSelectionScreen({super.key, required this.onSelection});

  /// Überschrift des Screens
  String get title;

  /// Liste der verfügbaren Auswahlmöglichkeiten
  List<SelectionButtonData> get selectionItems;

  /// Optionale Icon-Farbe (default: AppColors.secondary)
  Color get defaultIconColor => AppColors.secondary;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 25),
        ...selectionItems.map((item) => Column(
              children: [
                _buildSelectionButton(
                  icon: item.icon,
                  text: item.text,
                  iconColor: item.iconColor ?? defaultIconColor,
                  onTap: () => onSelection(item.value),
                ),
                if (item != selectionItems.last) const SizedBox(height: 15),
              ],
            )),
      ],
    );
  }

  Widget _buildSelectionButton({
    required IconData icon,
    required String text,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: AppColors.white,
          border: Border.all(color: AppColors.black, width: 2),
          boxShadow: const [
            BoxShadow(
              color: AppColors.black,
              offset: Offset(4, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconColor,
                border: Border.all(color: AppColors.black, width: 2),
              ),
              child: Icon(
                icon,
                color: AppColors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 15),
            Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
              ),
            ),
          ],
        ),
      ),
    );
  }
}