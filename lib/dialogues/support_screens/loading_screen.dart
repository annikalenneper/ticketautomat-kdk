import 'package:flutter/material.dart';
import 'package:ticket_alternative/styles/app_colors.dart';

/// Loading-Widget für Support-Terminal
class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          color: AppColors.backgroundLight,
          border: Border.all(color: AppColors.black, width: 2),
          boxShadow: const [
            BoxShadow(
              color: AppColors.black,
              offset: Offset(4, 4),
            ),
          ],
        ),
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(
              color: AppColors.primary,
              strokeWidth: 4,
            ),
            SizedBox(height: 25),
            Text(
              'Bitte warten...',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.textDark,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
