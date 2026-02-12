import 'package:flutter/material.dart';
import 'dart:async';
import 'package:ticket_alternative/styles/app_colors.dart';
import 'package:ticket_alternative/headers/main_header.dart';
import 'package:ticket_alternative/views/panel_left.dart';
import 'package:ticket_alternative/views/panel_right.dart';
import 'package:ticket_alternative/printservice/defect_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DefectService().init();
  runApp(const KVBTicketautomatApp());
}

class KVBTicketautomatApp extends StatelessWidget {
  const KVBTicketautomatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KVB Ticketautomat',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Arial',
        primaryColor: AppColors.primary,
      ),
      home: const DefectWrapper(child: TicketautomatScreen()),
    );
  }
}

class DefectWrapper extends StatelessWidget {
  final Widget child;
  const DefectWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: DefectService().isDefectActive,
      builder: (context, isDefect, _) {
        return Stack(
          children: [
            child,
            if (isDefect)
              Positioned.fill(
                child: Container(
                  color: AppColors.backgroundLight,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(40),
                      margin: const EdgeInsets.all(40),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        border: Border.all(color: AppColors.black, width: 4),
                        boxShadow: const [
                          BoxShadow(
                            color: AppColors.black,
                            offset: Offset(10, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.warning_amber_rounded,
                            color: AppColors.primary,
                            size: 100,
                          ),
                          const SizedBox(height: 30),
                          const Text(
                            'AUSSER BETRIEB',
                            style: TextStyle(
                              fontSize: 42,
                              fontWeight: FontWeight.w900,
                              color: AppColors.primary,
                              decoration: TextDecoration.none,
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'DEFEKT - Wir arbeiten an einer Lösung.\n\nBitte besuchen Sie uns an einem anderen Automaten.\nWir entschuldigen uns für die Unannehmlichkeiten.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textDark,
                              height: 1.5,
                              decoration: TextDecoration.none,
                            ),
                          ),
                          const SizedBox(height: 40),
                          const Text(
                            'KVB - Kölner Verkehrs-Betriebe AG',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textMedium,
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class TicketautomatScreen extends StatefulWidget {
  const TicketautomatScreen({super.key});

  @override
  State<TicketautomatScreen> createState() => _TicketautomatScreenState();
}

class _TicketautomatScreenState extends State<TicketautomatScreen> {
  final TextEditingController toController = TextEditingController();
  Timer? _resetTimer;

  @override
  void initState() {
    super.initState();
    toController.addListener(_updateTripInfo);
  }

  void _updateTripInfo() {
    setState(() {});

    _resetTimer?.cancel();
    if (toController.text.isNotEmpty) {
      _resetTimer = Timer(const Duration(seconds: 30), () {
        toController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: Column(
        children: [
          const Header(),
          Expanded(
            child: Row(
              children: [
                PanelLeft(
                  toController: toController,
                ),
                const PanelRight(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _resetTimer?.cancel();
    toController.dispose();
    super.dispose();
  }
}
