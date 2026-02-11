import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ticket_alternative/printservice/quest_printer_dialog.dart';
import 'package:ticket_alternative/dialogues/support_terminal_dialogues.dart';
import 'package:ticket_alternative/styles/app_colors.dart';

class FAQDialog extends StatelessWidget {
  final String title;
  final String content;

  const FAQDialog({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 80),
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
                color: AppColors.primary,
                border: Border(
                  bottom: BorderSide(color: AppColors.black, width: 2),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      title.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 22,
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
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(30),
              child: Text(
                content,
                style: const TextStyle(
                  fontSize: 18,
                  color: AppColors.textDark,
                  fontWeight: FontWeight.w600,
                  height: 1.6,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CodeOfConductDialog extends StatefulWidget {
  const CodeOfConductDialog({super.key});

  @override
  State<CodeOfConductDialog> createState() => _CodeOfConductDialogState();
}

class _CodeOfConductDialogState extends State<CodeOfConductDialog> {
  Future<Map<String, dynamic>> _loadCodeOfConduct() async {
    final String response =
        await rootBundle.loadString('lib/assets/coc.json');
    return json.decode(response);
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
                color: AppColors.primary,
                border: Border(
                  bottom: BorderSide(color: AppColors.black, width: 2),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(
                    child: Text(
                      'CODE OF CONDUCT',
                      style: TextStyle(
                        fontSize: 22,
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
            ),
            // Content
            Expanded(
              child: FutureBuilder<Map<String, dynamic>>(
                future: _loadCodeOfConduct(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return const Center(
                        child: Text('Fehler beim Laden des Code of Conduct'));
                  }

                  final data = snapshot.data!;
                  final principles = data['principles'] as List;

                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(25),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${data['title']}'.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          data['type'],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textMedium,
                          ),
                        ),
                        const SizedBox(height: 25),
                        ...principles.map((principle) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: _buildPrincipleSection(principle),
                          );
                        }),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrincipleSection(Map<String, dynamic> principle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.secondary,
            border: Border.all(color: AppColors.black, width: 2),
          ),
          child: Text(
            principle['title'].toString().toUpperCase(),
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w900,
              color: AppColors.white,
              letterSpacing: 0.8,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          principle['description'],
          style: const TextStyle(
            fontSize: 15,
            color: AppColors.textDark,
            fontWeight: FontWeight.w600,
            height: 1.5,
          ),
        ),
        if (principle.containsKey('consequences')) ...[
          const SizedBox(height: 8),
          Text(
            '⚠️ ${principle['consequences']}',
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textMedium,
              fontWeight: FontWeight.w700,
              height: 1.5,
            ),
          ),
        ],
        if (principle.containsKey('measures')) ...[
          const SizedBox(height: 8),
          ...(principle['measures'] as List).map((measure) => Padding(
                padding: const EdgeInsets.only(left: 15, top: 4),
                child: Text(
                  '• $measure',
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textDark,
                    fontWeight: FontWeight.w600,
                    height: 1.4,
                  ),
                ),
              )),
        ],
        if (principle.containsKey('examples')) ...[
          const SizedBox(height: 8),
          Text(
            'Beispiele:',
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textMedium,
              fontWeight: FontWeight.w700,
            ),
          ),
          ...(principle['examples'] as List).map((example) => Padding(
                padding: const EdgeInsets.only(left: 15, top: 2),
                child: Text(
                  '• $example',
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textDark,
                    fontWeight: FontWeight.w600,
                    height: 1.4,
                  ),
                ),
              )),
        ],
        if (principle.containsKey('note')) ...[
          const SizedBox(height: 8),
          Text(
            'ℹ️ ${principle['note']}',
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textMedium,
              fontWeight: FontWeight.w600,
              fontStyle: FontStyle.italic,
              height: 1.5,
            ),
          ),
        ],
      ],
    );
  }
}

/// Dialog: Was kann der Automat noch?
class AutomatFeaturesDialog extends StatelessWidget {
  const AutomatFeaturesDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final features = [
      {
        'icon': Icons.explore,
        'title': 'Spontane Missionen',
        'description': 'Quests fuer zwischendurch ausdrucken!',
        'action': 'quest',
      },
      {
        'icon': Icons.support_agent,
        'title': 'Kundensupport',
        'description': 'Wir kuemmern uns sofort um Ihr Anliegen.',
        'action': 'support',
      },
    ];

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
                color: AppColors.primary,
                border: Border(
                  bottom: BorderSide(color: AppColors.black, width: 2),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'FUNKTIONEN DES AUTOMATEN',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: AppColors.white,
                      letterSpacing: 1.5,
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
            ),
            // Features Grid
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: features.map((feature) => _buildFeatureRow(context, feature)).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureRow(BuildContext context, Map<String, dynamic> feature) {
    final action = feature['action'] as String?;
    final hasAction = action != null;
    
    return GestureDetector(
      onTap: hasAction
          ? () {
              Navigator.of(context).pop();
              if (action == 'quest') {
                showDialog(
                  context: context,
                  builder: (context) => const QuestDialog(),
                );
              } else if (action == 'support') {
                showDialog(
                  context: context,
                  builder: (context) => const SupportTerminalDialog(),
                );
              }
            }
          : null,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: hasAction ? AppColors.primary.withOpacity(0.1) : AppColors.backgroundLight,
          border: Border.all(
            color: hasAction ? AppColors.primary : AppColors.black,
            width: hasAction ? 3 : 2,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: hasAction ? AppColors.primary : AppColors.secondary,
                border: Border.all(color: AppColors.black, width: 2),
              ),
              child: Icon(
                feature['icon'] as IconData,
                color: AppColors.white,
                size: 28,
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    feature['title'] as String,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    feature['description'] as String,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textMedium,
                    ),
                  ),
                ],
              ),
            ),
            if (hasAction)
              const Icon(
                Icons.arrow_forward_ios,
                color: AppColors.primary,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}

/// Dialog: Quest / Mission auswaehlen und drucken
class QuestDialog extends StatefulWidget {
  const QuestDialog({super.key});

  @override
  State<QuestDialog> createState() => _QuestDialogState();
}

class _QuestDialogState extends State<QuestDialog> {
  String? _selectedCategory;
  Map<String, dynamic>? _selectedQuest;
  List<Map<String, dynamic>> _quests = [];
  bool _isLoading = true;
  bool _isPrinting = false;

  @override
  void initState() {
    super.initState();
    _loadQuests();
  }

  Future<void> _loadQuests() async {
    try {
      final jsonString = await rootBundle.loadString('lib/assets/quests.json');
      final data = json.decode(jsonString) as Map<String, dynamic>;
      setState(() {
        _quests = List<Map<String, dynamic>>.from(data['quests']);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _selectRandomQuest(String category) {
    final categoryQuests = _quests.where((q) => q['kategorie'] == category).toList();
    if (categoryQuests.isNotEmpty) {
      categoryQuests.shuffle();
      setState(() {
        _selectedCategory = category;
        _selectedQuest = categoryQuests.first;
      });
    }
  }

  Future<void> _printQuest() async {
    if (_selectedQuest == null) return;
    
    Navigator.of(context).pop();
    
    // Oeffne Drucker-Dialog mit Quest-Daten
    showDialog(
      context: context,
      builder: (context) => QuestPrinterDialog(
        category: _selectedCategory!,
        questText: _selectedQuest!['aufgabe'] as String,
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'MISSIONEN FUER ZWISCHENDURCH',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: AppColors.white,
                      letterSpacing: 1.5,
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
            ),
            // Content
            if (_isLoading)
              const Padding(
                padding: EdgeInsets.all(40),
                child: CircularProgressIndicator(),
              )
            else
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'WAEHLE EINE KATEGORIE:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Expanded(
                          child: _buildCategoryButton(
                            'Schnitzeljagd',
                            Icons.search,
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: _buildCategoryButton(
                            'Interaktion',
                            Icons.people,
                          ),
                        ),
                      ],
                    ),
                    if (_selectedQuest != null) ...[
                      const SizedBox(height: 25),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.backgroundLight,
                          border: Border.all(color: AppColors.black, width: 2),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'DEINE MISSION:',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              '???????????',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textDark,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => _selectRandomQuest(_selectedCategory!),
                              icon: const Icon(Icons.refresh),
                              label: const Text('ANDERE MISSION'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.backgroundLight,
                                foregroundColor: AppColors.textDark,
                                padding: const EdgeInsets.symmetric(vertical: 15),
                                side: const BorderSide(color: AppColors.black, width: 2),
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.zero,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: _isPrinting ? null : _printQuest,
                              icon: _isPrinting
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: AppColors.white,
                                      ),
                                    )
                                  : const Icon(Icons.print),
                              label: Text(_isPrinting ? 'DRUCKT...' : 'DRUCKEN'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
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
                      ),
                    ],
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryButton(String category, IconData icon) {
    final isSelected = _selectedCategory == category;
    return GestureDetector(
      onTap: () => _selectRandomQuest(category),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.white,
          border: Border.all(
            color: AppColors.black,
            width: isSelected ? 3 : 2,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.black,
              offset: Offset(isSelected ? 2 : 4, isSelected ? 2 : 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 40,
              color: isSelected ? AppColors.white : AppColors.textDark,
            ),
            const SizedBox(height: 10),
            Text(
              category.toUpperCase(),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: isSelected ? AppColors.white : AppColors.textDark,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
