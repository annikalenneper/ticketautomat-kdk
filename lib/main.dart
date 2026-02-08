import 'package:flutter/material.dart';
import 'dart:async';
import 'package:ticket_alternative/styles/app_colors.dart';
import 'package:ticket_alternative/headers/main_header.dart';
import 'package:ticket_alternative/views/panel_left.dart';
import 'package:ticket_alternative/views/panel_right.dart';

void main() {
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
      home: const TicketautomatScreen(),
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
