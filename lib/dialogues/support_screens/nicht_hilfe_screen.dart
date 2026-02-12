import 'package:flutter/material.dart';
import 'package:ticket_alternative/styles/app_colors.dart';

/// Screen 5: Nicht-Hilfe (vorher Screen 4)
class NichtHilfeScreen extends StatelessWidget {
  final VoidCallback onContact;

  const NichtHilfeScreen({super.key, required this.onContact});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Zu diesem Thema liegen uns aktuell keine Informationen vor.',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 25),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.backgroundLight,
            border: Border.all(color: AppColors.black, width: 2),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Bitte wenden Sie sich an unsere Zentrale.',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark,
                  height: 1.5,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Unsere Mitarbeitenden helfen Ihnen gerne weiter.',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 25),
        GestureDetector(
          onTap: onContact,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.success,
              border: Border.all(color: AppColors.black, width: 2),
              boxShadow: const [
                BoxShadow(
                  color: AppColors.black,
                  offset: Offset(4, 4),
                ),
              ],
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.phone, color: AppColors.white),
                SizedBox(width: 10),
                Text(
                  'ZENTRALE KONTAKTIEREN',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
