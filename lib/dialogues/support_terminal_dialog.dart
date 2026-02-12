import 'package:flutter/material.dart';
import 'package:ticket_alternative/styles/app_colors.dart';
import 'package:ticket_alternative/dialogues/support_screens/anliegen_screen.dart';
import 'package:ticket_alternative/dialogues/support_screens/bestaetigung_screen.dart';
import 'package:ticket_alternative/dialogues/support_screens/kontaktversuch_screen.dart';
import 'package:ticket_alternative/dialogues/support_screens/loading_screen.dart';

/// Hauptdialog für das Kundensupport-Terminal
class SupportTerminalDialog extends StatefulWidget {
  const SupportTerminalDialog({super.key});

  @override
  State<SupportTerminalDialog> createState() => _SupportTerminalDialogState();
}

class _SupportTerminalDialogState extends State<SupportTerminalDialog> {
  int _currentScreen = 1;
  final bool _isLoading = false;

  void _goToScreen(int screen) {
    setState(() {
      _currentScreen = screen;
    });
  }

  Widget _buildCurrentScreen() {
    if (_isLoading) {
      return const LoadingScreen();
    }

    switch (_currentScreen) {
      case 1:
        // Schritt 1: Anliegen auswählen
        return AnliegenScreen(
          onSelection: (String choice) => _goToScreen(6),
        );
      case 6:
        // Schritt 2: Kontaktversuch (simuliert Verbindung)
        return KontaktversuchScreen(
          onClose: () => _goToScreen(3),
        );
      case 3:
        // Schritt 3: Bestätigung / Bewertung
        return BestaetigungScreen(
          onCompleted: () => Navigator.of(context).pop(),
        );
      default:
        return AnliegenScreen(
          onSelection: (String choice) => _goToScreen(6),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 60),
      child: Container(
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
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: AppColors.secondary,
                border: Border(
                  bottom: BorderSide(color: AppColors.black, width: 2),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Expanded(
                        child: Text(
                          'KUNDENSUPPORT-TERMINAL',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            color: AppColors.white,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(
                          Icons.close,
                          color: AppColors.white,
                          size: 28,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Content
            Flexible(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: _buildCurrentScreen(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
