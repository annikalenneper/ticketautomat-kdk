import 'package:flutter/material.dart';
import 'package:ticket_alternative/styles/app_colors.dart';

/// Screen 3: Bestätigung (vorher Screen 2)
class BestaetigungScreen extends StatefulWidget {
  final VoidCallback onCompleted;

  const BestaetigungScreen({super.key, required this.onCompleted});

  @override
  State<BestaetigungScreen> createState() => _BestaetigungScreenState();
}

class _BestaetigungScreenState extends State<BestaetigungScreen> {
  int? _selectedRating;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Wir bedanken uns für Ihre Anfrage!',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 25),
        const Text(
          'Bitte bewerten Sie unseren Service:',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 20),
        _buildRatingOption(4, '⭐⭐⭐⭐ Sehr gut'),
        const SizedBox(height: 12),
        _buildRatingOption(5, '⭐⭐⭐⭐⭐ Ausgezeichnet'),
        const SizedBox(height: 30),
        GestureDetector(
          onTap: _selectedRating == null ? null : widget.onCompleted,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: _selectedRating == null ? AppColors.border : AppColors.primary,
              border: Border.all(color: AppColors.black, width: 2),
              boxShadow: _selectedRating == null
                  ? null
                  : const [
                      BoxShadow(
                        color: AppColors.black,
                        offset: Offset(4, 4),
                      ),
                    ],
            ),
            child: const Center(
              child: Text(
                'FEEDBACK SENDEN',
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

  Widget _buildRatingOption(int stars, String text) {
    final isSelected = _selectedRating == stars;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedRating = stars;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.secondary.withValues(alpha: 0.1) : AppColors.white,
          border: Border.all(
            color: isSelected ? AppColors.secondary : AppColors.black,
            width: isSelected ? 3 : 2,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: isSelected ? AppColors.secondary : AppColors.textLight,
            ),
            const SizedBox(width: 15),
            Text(
              text,
              style: TextStyle(
                fontSize: 18,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                color: AppColors.textDark,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
