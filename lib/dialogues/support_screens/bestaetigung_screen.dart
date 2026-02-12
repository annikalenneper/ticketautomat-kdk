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
  @override
  void initState() {
    super.initState();
    // Auto-close after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        widget.onCompleted();
      }
    });
  }

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
        const Center(
          child: CircularProgressIndicator(),
        ),
      ],
    );
  }
}
