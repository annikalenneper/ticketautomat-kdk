import 'package:flutter/material.dart';
import 'package:ticket_alternative/styles/app_colors.dart';

/// Screen 6: Kontaktversuch (vorher Screen 5)
class KontaktversuchScreen extends StatefulWidget {
  final VoidCallback onClose;

  const KontaktversuchScreen({
    super.key,
    required this.onClose,
  });

  @override
  State<KontaktversuchScreen> createState() => _KontaktversuchScreenState();
}

class _KontaktversuchScreenState extends State<KontaktversuchScreen> {
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
          _isConnecting
              ? 'Verbindung wird hergestellt ...'
              : 'Die Verbindung konnte leider nicht hergestellt werden.',
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
          GestureDetector(
            onTap: widget.onClose,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(15),
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
      ],
    );
  }
}
