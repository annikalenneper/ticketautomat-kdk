import 'package:flutter/material.dart';
import 'package:ticket_alternative/styles/app_colors.dart';

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
      return _buildLoadingScreen();
    }

    switch (_currentScreen) {
      case 1:
        return _Screen1AnliegenAuswahl(
          onSelection: (String choice) async {
            if (choice == 'FRAGE') {
              await _showLoadingAndContinue(2);
            } else {
              _goToScreen(2);
            }
          },
        );
      case 2:
        return _Screen2Bestaetigung(
          onContinue: () => _showLoadingAndContinue(3),
        );
      case 3:
        return _Screen3Themenfilter(
          onSelection: (String theme) => _goToScreen(4),
        );
      case 4:
        return _Screen4NichtHilfe(
          onContact: () => _goToScreen(5),
        );
      case 5:
        return _Screen5Kontaktversuch(
          onRetry: () {
            setState(() {
              _retryCount++;
            });
            if (_retryCount >= 3) {
              _goToScreen(6);
            } else {
              // Zurück zu Screen 5 (bleibt gleich)
              _goToScreen(5);
            }
          },
          onBack: () => _goToScreen(1),
        );
      case 6:
        return _Screen6Resignation(
          onRate: (int stars) {
            Navigator.of(context).pop();
          },
        );
      default:
        return _Screen1AnliegenAuswahl(
          onSelection: (String choice) => _goToScreen(2),
        );
    }
  }

  Widget _buildLoadingScreen() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(
            color: AppColors.primary,
            strokeWidth: 3,
          ),
          const SizedBox(height: 20),
          const Text(
            'Bitte warten...',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
            ),
          ),
        ],
      ),
    );
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

/// Screen 1: Anliegen-Auswahl
class _Screen1AnliegenAuswahl extends StatelessWidget {
  final Function(String) onSelection;

  const _Screen1AnliegenAuswahl({required this.onSelection});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Bitte wählen Sie eine der folgenden Optionen.',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textMedium,
          ),
        ),
        const SizedBox(height: 30),
        // SEHR ZUFRIEDEN - riesig
        _buildOptionButton(
          text: '🟩 SEHR ZUFRIEDEN',
          color: const Color(0xFF008000),
          height: 100,
          fontSize: 24,
          onTap: () => onSelection('SEHR_ZUFRIEDEN'),
        ),
        const SizedBox(height: 15),
        // ZUFRIEDEN - groß
        _buildOptionButton(
          text: '🟨 ZUFRIEDEN',
          color: const Color(0xFFFFD700),
          height: 80,
          fontSize: 20,
          onTap: () => onSelection('ZUFRIEDEN'),
        ),
        const SizedBox(height: 15),
        // EIGENTLICH ZUFRIEDEN - mittel
        _buildOptionButton(
          text: '⬜ EIGENTLICH ZUFRIEDEN',
          color: AppColors.backgroundLight,
          height: 60,
          fontSize: 16,
          onTap: () => onSelection('EIGENTLICH_ZUFRIEDEN'),
        ),
        const SizedBox(height: 15),
        // ICH HABE EINE FRAGE - sehr klein
        _buildOptionButton(
          text: '⬛ ICH HABE EINE FRAGE',
          color: AppColors.textDark,
          textColor: AppColors.white,
          height: 35,
          fontSize: 10,
          onTap: () => onSelection('FRAGE'),
        ),
      ],
    );
  }

  Widget _buildOptionButton({
    required String text,
    required Color color,
    Color textColor = AppColors.white,
    required double height,
    required double fontSize,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: height,
        decoration: BoxDecoration(
          color: color,
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
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w800,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}

/// Screen 2: Bestätigung
class _Screen2Bestaetigung extends StatelessWidget {
  final VoidCallback onContinue;

  const _Screen2Bestaetigung({required this.onContinue});

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
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: onContinue,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.white,
              padding: const EdgeInsets.symmetric(vertical: 15),
              side: const BorderSide(color: AppColors.black, width: 2),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
            ),
            child: const Text(
              'WEITER',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Screen 3: Themenfilter
class _Screen3Themenfilter extends StatelessWidget {
  final Function(String) onSelection;

  const _Screen3Themenfilter({required this.onSelection});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Bitte spezifizieren Sie Ihr Anliegen',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 25),
        _buildThemeButton(
          icon: Icons.euro,
          text: 'Tarifinformationen',
          onTap: () => onSelection('Tarif'),
        ),
        const SizedBox(height: 15),
        _buildThemeButton(
          icon: Icons.schedule,
          text: 'Fahrplanabweichungen',
          onTap: () => onSelection('Fahrplan'),
        ),
        const SizedBox(height: 15),
        _buildThemeButton(
          icon: Icons.sentiment_satisfied_alt,
          text: 'Allgemeine Zufriedenheit',
          onTap: () => onSelection('Zufriedenheit'),
        ),
        const SizedBox(height: 15),
        _buildThemeButton(
          icon: Icons.more_horiz,
          text: 'Sonstiges',
          onTap: () => onSelection('Sonstiges'),
        ),
      ],
    );
  }

  Widget _buildThemeButton({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: AppColors.white,
          border: Border.all(color: AppColors.black, width: 2),
          boxShadow: const [
            BoxShadow(
              color: AppColors.black,
              offset: Offset(4, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.secondary,
                border: Border.all(color: AppColors.black, width: 2),
              ),
              child: Icon(
                icon,
                color: AppColors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 15),
            Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Screen 4: Nicht-Hilfe
class _Screen4NichtHilfe extends StatelessWidget {
  final VoidCallback onContact;

  const _Screen4NichtHilfe({required this.onContact});

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
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: onContact,
            icon: const Icon(Icons.phone),
            label: const Text(
              'ZENTRALE KONTAKTIEREN',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.success,
              foregroundColor: AppColors.white,
              padding: const EdgeInsets.symmetric(vertical: 15),
              side: const BorderSide(color: AppColors.black, width: 2),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Screen 5: Kontaktversuch
class _Screen5Kontaktversuch extends StatefulWidget {
  final VoidCallback onRetry;
  final VoidCallback onBack;

  const _Screen5Kontaktversuch({
    required this.onRetry,
    required this.onBack,
  });

  @override
  State<_Screen5Kontaktversuch> createState() => _Screen5KontaktversuchState();
}

class _Screen5KontaktversuchState extends State<_Screen5Kontaktversuch> {
  bool _isConnecting = true;
  double _progress = 0.0;

  @override
  void initState() {
    super.initState();
    _startConnection();
  }

  Future<void> _startConnection() async {
    setState(() {
      _isConnecting = true;
      _progress = 0.0;
    });

    // Simuliere Fortschritt bis 87%
    for (int i = 0; i <= 87; i++) {
      if (!mounted) return;
      await Future.delayed(const Duration(milliseconds: 30));
      setState(() {
        _progress = i / 100;
      });
    }

    // Warte etwas bei 87%
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isConnecting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _isConnecting ? 'Verbindung wird hergestellt ...' : 'Die Verbindung konnte leider nicht hergestellt werden.',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 30),
        if (_isConnecting) ...[
          Container(
            width: double.infinity,
            height: 40,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.black, width: 2),
            ),
            child: Stack(
              children: [
                LinearProgressIndicator(
                  value: _progress,
                  backgroundColor: AppColors.backgroundLight,
                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.success),
                  minHeight: 40,
                ),
                Center(
                  child: Text(
                    '${(_progress * 100).toInt()}%',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textDark,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.primary,
                ),
              ),
              SizedBox(width: 10),
              Text(
                'Bitte warten',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textMedium,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ] else ...[
          const Icon(
            Icons.error_outline,
            size: 80,
            color: AppColors.primary,
          ),
          const SizedBox(height: 30),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: widget.onRetry,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    side: const BorderSide(color: AppColors.black, width: 2),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                  ),
                  child: const Text(
                    'ERNEUT VERSUCHEN',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: ElevatedButton(
                  onPressed: widget.onBack,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.cancel,
                    foregroundColor: AppColors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    side: const BorderSide(color: AppColors.black, width: 2),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                  ),
                  child: const Text(
                    'ZURÜCK ZUM START',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

/// Screen 6: Resignation
class _Screen6Resignation extends StatelessWidget {
  final Function(int) onRate;

  const _Screen6Resignation({required this.onRate});

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
          color: const Color(0xFFFFD700),
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
