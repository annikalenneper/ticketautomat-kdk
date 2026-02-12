import 'package:flutter/material.dart';
import 'package:ticket_alternative/styles/app_colors.dart';
import 'package:ticket_alternative/dialogues/support_screens/anliegen_screen.dart';
import 'package:ticket_alternative/dialogues/support_screens/bestaetigung_screen.dart';
import 'package:ticket_alternative/dialogues/support_screens/themenfilter_screen.dart';
import 'package:ticket_alternative/dialogues/support_screens/nicht_hilfe_screen.dart';
import 'package:ticket_alternative/dialogues/support_screens/kontaktversuch_screen.dart';
import 'package:ticket_alternative/dialogues/support_screens/resignation_screen.dart';
import 'package:ticket_alternative/dialogues/support_screens/loading_screen.dart';

/// Hauptdialog für das Kundensupport-Terminal
class SupportTerminalDialog extends StatefulWidget {
  const SupportTerminalDialog({super.key});

  @override
  State<SupportTerminalDialog> createState() => _SupportTerminalDialogState();
}

class _SupportTerminalDialogState extends State<SupportTerminalDialog> {
  int _currentScreen = 1;
  int _retryCount = 0;
  bool _isLoading = false;

  void _goToScreen(int screen) {
    setState(() {
      _currentScreen = screen;
    });
  }

  Future<void> _showLoadingAndContinue(int nextScreen) async {
    setState(() {
      _isLoading = true;
    });
    await Future.delayed(const Duration(seconds: 3));
    if (mounted) {
      setState(() {
        _isLoading = false;
        _currentScreen = nextScreen;
      });
    }
  }

  Widget _buildCurrentScreen() {
    if (_isLoading) {
      return const LoadingScreen();
    }

    switch (_currentScreen) {
      case 1:
        // Screen 1: Anliegen auswählen
        return AnliegenScreen(
          onSelection: (String choice) async {
            if (choice == 'FRAGE') {
              await _showLoadingAndContinue(4);
            } else {
              _goToScreen(4);
            }
          },
        );
      case 3:
        // Screen 3: Bestätigung
        return BestaetigungScreen(
          onContinue: () => _showLoadingAndContinue(5),
        );
      case 4:
        // Screen 4: Themenfilter
        return ThemenfilterScreen(
          onSelection: (String theme) => _goToScreen(3),
        );
      case 5:
        // Screen 5: Nicht-Hilfe
        return NichtHilfeScreen(
          onContact: () => _goToScreen(6),
        );
      case 6:
        // Screen 6: Kontaktversuch
        return KontaktversuchScreen(
          onRetry: () {
            setState(() {
              _retryCount++;
            });
            if (_retryCount >= 3) {
              _goToScreen(7);
            } else {
              // Zurück zu Screen 6 (bleibt gleich, Animation startet neu)
              _goToScreen(6);
            }
          },
          onBack: () => _goToScreen(1),
        );
      case 7:
        // Screen 7: Resignation
        return ResignationScreen(
          onRate: (int stars) {
            Navigator.of(context).pop();
          },
        );
      default:
        return AnliegenScreen(
          onSelection: (String choice) => _goToScreen(4),
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
                  const SizedBox(height: 8),
                  const Text(
                    '„Wir kümmern uns sofort um Ihr Anliegen."',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.backgroundLight,
                      fontStyle: FontStyle.italic,
                    ),
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
