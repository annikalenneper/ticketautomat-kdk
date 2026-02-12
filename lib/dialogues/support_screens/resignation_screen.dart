import 'package:flutter/material.dart';
import 'package:ticket_alternative/styles/app_colors.dart';

/// Screen 7: Resignation (vorher Screen 6)
class ResignationScreen extends StatelessWidget {
  final VoidCallback onClose;

  const ResignationScreen({super.key, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Ihr Anliegen wurde erfolgreich bearbeitet.',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.success,
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
            children: [
              Text(
                'Vielen Dank für Ihre Geduld.',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark,
                  height: 1.5,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Bitte bewerten Sie unseren Kundenservice.',
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
          onTap: onClose,
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
                'SCHLIEßEN',
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
