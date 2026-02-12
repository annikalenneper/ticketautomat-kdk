import 'package:flutter/material.dart';
import 'base_selection_screen.dart';

/// Screen 4: Themenfilter (vorher Screen 3)
class ThemenfilterScreen extends BaseSelectionScreen {
  const ThemenfilterScreen({super.key, required super.onSelection});

  @override
  String get title => 'Bitte spezifizieren Sie Ihr Anliegen';

  @override
  List<SelectionButtonData> get selectionItems => [
    const SelectionButtonData(
      icon: Icons.euro,
      text: 'Tarifinformationen',
      value: 'Tarif',
    ),
    const SelectionButtonData(
      icon: Icons.schedule,
      text: 'Fahrplanabweichungen',
      value: 'Fahrplan',
    ),
    const SelectionButtonData(
      icon: Icons.sentiment_satisfied_alt,
      text: 'Allgemeine Zufriedenheit',
      value: 'Zufriedenheit',
    ),
    const SelectionButtonData(
      icon: Icons.more_horiz,
      text: 'Sonstiges',
      value: 'Sonstiges',
    ),
  ];
}
