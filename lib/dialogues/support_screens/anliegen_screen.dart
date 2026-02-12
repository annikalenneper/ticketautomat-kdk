import 'package:flutter/material.dart';
import 'package:ticket_alternative/styles/app_colors.dart';
import 'base_selection_screen.dart';

/// Screen 1: Anliegen-Auswahl
class AnliegenScreen extends BaseSelectionScreen {
  const AnliegenScreen({super.key, required super.onSelection});

  @override
  String get title => 'Bitte wählen Sie Ihr Anliegen aus:';

  @override
  List<SelectionButtonData> get selectionItems => [
    const SelectionButtonData(
      icon: Icons.error_outline,
      text: 'Problem melden',
      value: 'PROBLEM',
      iconColor: AppColors.primary,
    ),
    const SelectionButtonData(
      icon: Icons.help_outline,
      text: 'Ich habe eine Frage',
      value: 'FRAGE',
      iconColor: AppColors.secondary,
    ),
    const SelectionButtonData(
      icon: Icons.info_outline,
      text: 'Allgemeine Information',
      value: 'INFO',
      iconColor: AppColors.success,
    ),
    const SelectionButtonData(
      icon: Icons.feedback_outlined,
      text: 'Feedback geben',
      value: 'FEEDBACK',
      iconColor: AppColors.attention,
    ),
  ];
}
