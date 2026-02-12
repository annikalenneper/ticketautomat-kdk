import 'package:flutter/material.dart';
import 'package:ticket_alternative/styles/app_colors.dart';

/// Screen 3: Bestätigung (vorher Screen 2)
class BestaetigungScreen extends StatelessWidget {
  final VoidCallback onContinue;

  const BestaetigungScreen({super.key, required this.onContinue});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Vielen Dank für Ihr wertvolles Feedback!',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 25),
        const Text(
          'Ihr Anliegen ist uns äußerst wichtig.',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textDark,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'Wir leiten Sie nun an die zuständige Stelle weiter.',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textDark,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 30),
        GestureDetector(
          onTap: onContinue,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.primary,
              border: Border.all(color: AppColors.black, width: 2),
              boxShadow: const [
                BoxShadow(
                  color: AppColors.black,
                  offset: Offset(4, 4),
                ),
              ],
            ),
            child: const Center(
              child: Text(
                'WEITER',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
