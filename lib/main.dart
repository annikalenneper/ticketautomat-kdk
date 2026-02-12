import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:ticket_alternative/styles/app_colors.dart';
import 'package:ticket_alternative/headers/main_header.dart';
import 'package:ticket_alternative/views/panel_left.dart';
import 'package:ticket_alternative/views/panel_right.dart';
import 'package:ticket_alternative/printservice/defect_service.dart';
import 'package:ticket_alternative/global_navigator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Versteckt die Android Statusbar und Navigationsleiste (Vollbildmodus)
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  
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
      navigatorKey: globalNavigatorKey,
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
      builder: (context, isDefect, cachedChild) {
        return Stack(
          children: [
            cachedChild!,
            if (isDefect)
              // Defekt-Bildschirm darf nur erscheinen, wenn keine Dialoge mehr offen sind
              if (!(globalNavigatorKey.currentState?.canPop() ?? false))
                Positioned.fill(
                  child: Material(
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
                        child: const Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.warning_amber_rounded,
                              color: AppColors.primary,
                              size: 100,
                            ),
                            SizedBox(height: 30),
                            Text(
                              'AUSSER BETRIEB',
                              style: TextStyle(
                                fontSize: 42,
                                fontWeight: FontWeight.w900,
                                color: AppColors.primary,
                                decoration: TextDecoration.none,
                              ),
                            ),
                            SizedBox(height: 20),
                            Text(
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
                            SizedBox(height: 40),
                            Text(
                              'KDK - Kölner Kollektiv-Betriebe AG',
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
      child: child,
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
