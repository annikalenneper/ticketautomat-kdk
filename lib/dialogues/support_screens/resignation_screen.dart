import 'package:flutter/material.dart';
import 'package:ticket_alternative/styles/app_colors.dart';

/// Screen 7: Resignation (vorher Screen 6)
class ResignationScreen extends StatelessWidget {
  final Function(int) onRate;

  const ResignationScreen({super.key, required this.onRate});

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
        _buildRatingButton(
          text: '⭐⭐⭐⭐⭐ Ausgezeichnet',
          onTap: () => onRate(5),
        ),
        const SizedBox(height: 15),
        _buildRatingButton(
          text: '⭐⭐⭐⭐ Sehr gut',
          onTap: () => onRate(4),
        ),
      ],
    );
  }

  Widget _buildRatingButton({
    required String text,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.attention,
          border: Border.all(color: AppColors.black, width: 2),
          boxShadow: const [
            BoxShadow(
              color: AppColors.black,
              offset: Offset(4, 4),
            ),
          ],
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppColors.textDark,
            ),
          ),
        ),
      ),
    );
  }
}
