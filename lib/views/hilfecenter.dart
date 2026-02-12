import 'package:flutter/material.dart';
import 'package:ticket_alternative/styles/app_colors.dart';
import 'package:ticket_alternative/headers/help_header.dart';
import 'package:ticket_alternative/dialogues/faq_dialogues.dart';
import 'package:ticket_alternative/dialogues/support_terminal_dialog.dart';
import 'package:ticket_alternative/printservice/defect_service.dart';

class HilfeCenter extends StatefulWidget {
  const HilfeCenter({super.key});

  @override
  State<HilfeCenter> createState() => _HilfeCenterState();
}

class _HilfeCenterState extends State<HilfeCenter> {
  final List<FAQItem> _faqItems = [
    FAQItem(
      title: 'Wo bin ich?',
      content:
          'Du befindest dich am KVB Ticketautomaten im Karneval der Kollektive. Der Automat hilft dir, schnell und einfach Fahrkarten für deine Reise zu kaufen.',
      icon: Icons.location_on,
    ),
    FAQItem(
      title: 'Wie habe ich mich zu verhalten?',
      content:
          'Respekt, Toleranz und Sicherheit sind uns wichtig! Verhalte dich respektvoll gegenüber anderen Besucher*innen und Mitarbeiter*innen. Diskriminierung und Gewalt werden nicht toleriert. Bei Fragen oder Problemen kontaktiere jederzeit unser Team.',
      icon: Icons.info,
    ),
    FAQItem(
      title: 'Ich brauche was zu tun',
      content:
          'Neben dem Ticketkauf kannst du mit dieser Anwendung auch schnell wichtige Informationen zur Veranstaltung abrufen, die Anlage finden und dich mit anderen austauschen. Bei Fragen helfen wir dir gerne weiter!',
      icon: Icons.extension,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Column(
        children: [
          const HelpHeader(),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: AppColors.backgroundLight,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFAQSection(),
                  Expanded(child: Container()), // Flexible Spacer
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(child: _buildSupportSection()),
                      const SizedBox(width: 20),
                      _buildAdminLock(),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdminLock() {
    return GestureDetector(
      onTap: _showPinDialog,
      child: Container(
        padding: const EdgeInsets.all(20),
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
        child: const Icon(
          Icons.lock_outline,
          color: AppColors.black,
          size: 30,
        ),
      ),
    );
  }

  void _showPinDialog() {
    final TextEditingController pinController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => Dialog(
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
              const Text(
                'ADMIN ZUGANG',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: pinController,
                obscureText: true,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'PIN eingeben',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (pinController.text == '12131215') {
                    Navigator.pop(context);
                    _showSettingsDialog();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Falscher PIN')),
                    );
                  }
                },
                child: const Text('VERIFIZIEREN'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSettingsDialog() {
    final defectService = DefectService();
    final runningController = TextEditingController(text: defectService.timeRunning.toString());
    final errorController = TextEditingController(text: defectService.timeError.toString());
    bool isActive = defectService.isEnabled;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Dialog(
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
                const Text(
                  'DEFEKT-EINSTELLUNGEN',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 25),
                SwitchListTile(
                  title: const Text('Defekt-Zyklus aktiv'),
                  value: isActive,
                  onChanged: (val) => setState(() => isActive = val),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: runningController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Laufzeit (Minuten)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: errorController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Fehlerzeit (Minuten)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('ABBRECHEN'),
                    ),
                    const SizedBox(width: 15),
                    ElevatedButton(
                      onPressed: () async {
                        final running = int.tryParse(runningController.text) ?? 30;
                        final error = int.tryParse(errorController.text) ?? 5;
                        await defectService.updateSettings(running, error, isActive);
                        if (context.mounted) Navigator.pop(context);
                      },
                      child: const Text('SPEICHERN'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFAQSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
            color: AppColors.primary,
            border: Border(
              bottom: BorderSide(color: AppColors.black, width: 2),
              right: BorderSide(color: AppColors.black, width: 2),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.black,
                offset: Offset(4, 4),
              ),
            ],
          ),
          child: const Text(
            'FAQ - FREQUENTLY ASKED QUESTIONS',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AppColors.white,
              letterSpacing: 1.5,
            ),
          ),
        ),
        const SizedBox(height: 25),
        Column(
          children: _faqItems.map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: _buildGridItem(item),
          )).toList(),
        ),
      ],
    );
  }

  Widget _buildGridItem(FAQItem item) {
    return GestureDetector(
      onTap: () {
        if (item.title == 'Wie habe ich mich zu verhalten?') {
          showDialog(
            context: context,
            builder: (context) => const CodeOfConductDialog(),
          );
        } else if (item.title == 'Ich brauche was zu tun') {
          showDialog(
            context: context,
            builder: (context) => const AutomatFeaturesDialog(),
          );
        } else {
          showDialog(
            context: context,
            builder: (context) => FAQDialog(
              title: item.title,
              content: item.content,
            ),
          );
        }
      },
      child: Container(
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: AppColors.black,
              offset: Offset(4, 4),
            ),
          ],
        ),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(17),
          decoration: BoxDecoration(
            color: AppColors.white,
            border: Border.all(color: AppColors.black, width: 2),
          ),
          child: Row(
            children: [
              Icon(
                item.icon,
                color: AppColors.black,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  item.title.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSupportSection() {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => const SupportTerminalDialog(),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
          color: AppColors.secondary,
          border: Border.all(color: AppColors.black, width: 2),
          boxShadow: const [
            BoxShadow(
              color: AppColors.black,
              offset: Offset(6, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '📞 KUNDENSUPPORT-TERMINAL',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: AppColors.white,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'ANFRAGE NICHT GEKLÄRT? KONTAKTIEREN SIE UNSERE ZENTRALE DIREKT ÜBER DIESES TERMINAL.',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.white,
                fontWeight: FontWeight.w600,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FAQItem {
  final String title;
  final String content;
  final IconData icon;

  FAQItem({
    required this.title,
    required this.content,
    required this.icon,
  });
}
