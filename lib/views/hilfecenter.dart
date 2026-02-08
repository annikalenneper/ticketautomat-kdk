import 'package:flutter/material.dart';
import 'package:ticket_alternative/styles/app_colors.dart';
import 'package:ticket_alternative/headers/help_header.dart';

class HilfeCenter extends StatefulWidget {
  const HilfeCenter({super.key});

  @override
  State<HilfeCenter> createState() => _HilfeCenterState();
}

class _HilfeCenterState extends State<HilfeCenter> {
  int? _expandedIndex;

  final List<FAQItem> _faqItems = [
    FAQItem(
      title: 'Wo bin ich?',
      content:
          'Du befindest dich am KVB Ticketautomaten im Karneval der Kollektive. Der Automat hilft dir, schnell und einfach Fahrkarten für deine Reise zu kaufen.',
    ),
    FAQItem(
      title: 'DJ-Timetable',
      content:
          'Das DJ-Timetable für das heutige Event findest du unter folgenden Bühnen: Hauptbühne 14:00-15:30 | Nebenbühne 15:00-16:30 | Campusbühne 16:00-17:30. Nutze die Öffi um pünktlich zu deinen Lieblings-DJs zu kommen!',
    ),
    FAQItem(
      title: 'Code of Conduct',
      content:
          'Respekt, Toleranz und Sicherheit sind uns wichtig! Verhalte dich respektvoll gegenüber anderen Besucher*innen und Mitarbeiter*innen. Diskriminierung und Gewalt werden nicht toleriert. Bei Fragen oder Problemen kontaktiere jederzeit unser Team.',
    ),
    FAQItem(
      title: 'Was kann ich sonst noch tun?',
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
                  const SizedBox(height: 15),
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
            'HÄUFIG GESTELLTE FRAGEN',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AppColors.white,
              letterSpacing: 1.5,
            ),
          ),
        ),
        const SizedBox(height: 25),
        ..._faqItems.asMap().entries.map((entry) {
            int index = entry.key;
            FAQItem item = entry.value;
            bool isExpanded = _expandedIndex == index;

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildFAQItem(item, index, isExpanded),
            );
          }),
        ],
      );
  }

  Widget _buildFAQItem(FAQItem item, int index, bool isExpanded) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(
          color: AppColors.black,
          width: 2,
        ),
        boxShadow: const [
          BoxShadow(
            color: AppColors.black,
            offset: Offset(4, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                _expandedIndex = isExpanded ? null : index;
              });
            },
            child: Container(
              padding: const EdgeInsets.all(18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      item.title.toUpperCase(),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: isExpanded ? AppColors.primary : AppColors.textDark,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  Icon(
                    isExpanded ? Icons.remove : Icons.add,
                    color: AppColors.black,
                    size: 28,
                  ),
                ],
              ),
            ),
          ),
          if (isExpanded) ...[
            Container(
              height: 2,
              color: AppColors.black,
            ),
            Container(
              padding: const EdgeInsets.all(18),
              color: AppColors.backgroundUltraLight,
              child: Text(
                item.content,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textDark,
                  fontWeight: FontWeight.w600,
                  height: 1.6,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSupportSection() {
    return Container(
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
