import 'package:flutter/material.dart';
import 'package:ticket_alternative/styles/app_colors.dart';
import 'package:ticket_alternative/headers/help_header.dart';
import 'package:ticket_alternative/dialogues/faq_dialogues.dart';
import 'package:ticket_alternative/dialogues/support_terminal_dialog.dart';

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
    ),
    FAQItem(
      title: '<Was kann hier noch stehen???>',
      content:
          'Das DJ-Timetable für das heutige Event findest du unter folgenden Bühnen: Hauptbühne 14:00-15:30 | Nebenbühne 15:00-16:30 | Campusbühne 16:00-17:30. Nutze die Öffi um pünktlich zu deinen Lieblings-DJs zu kommen!',
    ),
    FAQItem(
      title: 'Wie habe ich mich zu verhalten?',
      content:
          'Respekt, Toleranz und Sicherheit sind uns wichtig! Verhalte dich respektvoll gegenüber anderen Besucher*innen und Mitarbeiter*innen. Diskriminierung und Gewalt werden nicht toleriert. Bei Fragen oder Problemen kontaktiere jederzeit unser Team.',
    ),
    FAQItem(
      title: 'Kann der Automat noch mehr?',
      content:
          'Neben dem Ticketkauf kannst du mit dieser Anwendung auch schnell wichtige Informationen zur Veranstaltung abrufen, die Anlage finden und dich mit anderen austauschen. Bei Fragen helfen wir dir gerne weiter!',
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
                  const SizedBox(height: 60),
                  _buildSupportSection(),
                ],
              ),
            ),
          ),
        ],
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
          children: [
            Row(
              children: [
                Expanded(child: _buildGridItem(_faqItems[0])),
                const SizedBox(width: 20),
                Expanded(child: _buildGridItem(_faqItems[1])),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(child: _buildGridItem(_faqItems[2])),
                const SizedBox(width: 20),
                Expanded(child: _buildGridItem(_faqItems[3])),
              ],
            ),
          ],
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
        } else if (item.title == 'Kann der Automat noch mehr?') {
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
        height: 120,
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
        child: Center(
          child: Text(
            item.title.toUpperCase(),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: AppColors.textDark,
              letterSpacing: 1,
            ),
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

  FAQItem({
    required this.title,
    required this.content,
  });
}
