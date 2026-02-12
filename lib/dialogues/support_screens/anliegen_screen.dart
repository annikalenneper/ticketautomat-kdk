import 'package:flutter/material.dart';
import 'package:ticket_alternative/styles/app_colors.dart';

/// Screen 1: Anliegen-Auswahl
class AnliegenScreen extends StatelessWidget {
  final Function(String) onSelection;

  const AnliegenScreen({super.key, required this.onSelection});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Bitte wählen Sie Ihr Anliegen aus:',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 30),
        _buildAnliegenButton(
          icon: Icons.error_outline,
          text: 'Problem melden',
          color: AppColors.primary,
          onTap: () => onSelection('PROBLEM'),
        ),
        const SizedBox(height: 15),
        _buildAnliegenButton(
          icon: Icons.help_outline,
          text: 'Ich habe eine Frage',
          color: AppColors.secondary,
          onTap: () => onSelection('FRAGE'),
        ),
        const SizedBox(height: 15),
        _buildAnliegenButton(
          icon: Icons.info_outline,
          text: 'Allgemeine Information',
          color: AppColors.success,
          onTap: () => onSelection('INFO'),
        ),
        const SizedBox(height: 15),
        _buildAnliegenButton(
          icon: Icons.feedback_outlined,
          text: 'Feedback geben',
          color: AppColors.attention,
          textColor: AppColors.textDark,
          onTap: () => onSelection('FEEDBACK'),
        ),
      ],
    );
  }

  Widget _buildAnliegenButton({
    required IconData icon,
    required String text,
    required Color color,
    Color textColor = AppColors.white,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color,
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
            Icon(
              icon,
              color: textColor,
              size: 32,
            ),
            const SizedBox(width: 15),
            Text(
              text,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
