import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
