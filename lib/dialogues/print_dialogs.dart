import 'package:flutter/material.dart';
import 'package:ticket_alternative/styles/app_colors.dart';

/// Dialog während des Druckvorgangs
class PrintingDialog extends StatelessWidget {
  const PrintingDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(40),
        decoration: BoxDecoration(
          color: AppColors.white,
          border: Border.all(color: AppColors.black, width: 3),
          boxShadow: const [
            BoxShadow(
              color: AppColors.black,
              offset: Offset(8, 8),
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
              'DRUCKT...',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: AppColors.textDark,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Dialog nach erfolgreichem Druck
class TicketReceiptDialog extends StatelessWidget {
  const TicketReceiptDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          color: AppColors.white,
          border: Border.all(color: AppColors.black, width: 3),
          boxShadow: const [
            BoxShadow(
              color: AppColors.black,
              offset: Offset(8, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.check_circle_outline,
              size: 80,
              color: AppColors.success,
            ),
            const SizedBox(height: 20),
            const Text(
              'ENTNEHMEN SIE IHR TICKET',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: AppColors.textDark,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                side: const BorderSide(color: AppColors.black, width: 2),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
              ),
              child: const Text(
                'OK',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
