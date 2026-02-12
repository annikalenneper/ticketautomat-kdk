import 'package:flutter/material.dart';
import 'package:ticket_alternative/styles/app_colors.dart';

/// Screen 4: Themenfilter (vorher Screen 3)
class ThemenfilterScreen extends StatelessWidget {
  final Function(String) onSelection;

  const ThemenfilterScreen({super.key, required this.onSelection});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Bitte spezifizieren Sie Ihr Anliegen',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 25),
        _buildThemeButton(
          icon: Icons.euro,
          text: 'Tarifinformationen',
          onTap: () => onSelection('Tarif'),
        ),
        const SizedBox(height: 15),
        _buildThemeButton(
          icon: Icons.schedule,
          text: 'Fahrplanabweichungen',
          onTap: () => onSelection('Fahrplan'),
        ),
        const SizedBox(height: 15),
        _buildThemeButton(
          icon: Icons.sentiment_satisfied_alt,
          text: 'Allgemeine Zufriedenheit',
          onTap: () => onSelection('Zufriedenheit'),
        ),
        const SizedBox(height: 15),
        _buildThemeButton(
          icon: Icons.more_horiz,
          text: 'Sonstiges',
          onTap: () => onSelection('Sonstiges'),
        ),
      ],
    );
  }

  Widget _buildThemeButton({
    required IconData icon,
    required String text,
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
                color: AppColors.secondary,
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
