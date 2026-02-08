import 'package:flutter/material.dart';
import 'package:ticket_alternative/styles/app_colors.dart';
import 'package:ticket_alternative/printservice/printer_dialog.dart';

class PanelLeft extends StatelessWidget {
  final TextEditingController toController;

  const PanelLeft({
    super.key,
    required this.toController,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: AppColors.backgroundLight,
          border: Border(
            right: BorderSide(color: AppColors.border, width: 2),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('🚉 IHRE REISE'),
            const SizedBox(height: 10),
            _buildFixedStartStation(),
            const SizedBox(height: 12),
            _buildDestinationInput(context),
            const SizedBox(height: 20),
            _buildSectionTitle('ℹ️ FAHRTINFORMATIONEN', fontSize: 18),
            const SizedBox(height: 10),
            Expanded(
              child: _buildTripDetails(),
            ),
            const SizedBox(height: 15),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: toController.text.isEmpty
                    ? null
                    : () {
                        // Berechne Preis basierend auf Destination
                        final isLongDistance = toController.text.length > 5;
                        final price = isLongDistance ? 5.30 : 3.20;

                        showDialog(
                          context: context,
                          builder: (context) => PrinterDialog(
                            from: 'BüZe Ehrenfeld',
                            to: toController.text,
                            price: price,
                          ),
                        );
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondary,
                  foregroundColor: AppColors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  disabledBackgroundColor: AppColors.inputBorder,
                ),
                child: const Text(
                  'Mit der Buchung fortfahren',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, {double fontSize = 19}) {
    return Container(
      padding: const EdgeInsets.only(bottom: 12),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.primary, width: 3),
        ),
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w700,
          color: AppColors.textDark,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildFixedStartStation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Von (Start-Haltestelle)',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textMedium,
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          enabled: false,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: AppColors.textDark,
          ),
          decoration: InputDecoration(
            hintText: 'BüZe Ehrenfeld',
            hintStyle: const TextStyle(
              fontSize: 18,
              color: AppColors.textMedium,
            ),
            filled: true,
            fillColor: AppColors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: const BorderSide(color: AppColors.inputBorder, width: 2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: const BorderSide(color: AppColors.inputBorder, width: 2),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: const BorderSide(color: AppColors.inputBorder, width: 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
              contentPadding: const EdgeInsets.all(17),
            prefixIcon: const Icon(
              Icons.start,
              color: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDestinationInput(BuildContext context) {
    const stations = [
      'Hauptbahnhof',
      'Köln Messe',
      'Appellhofplatz',
      'Rudolfplatz',
      'Friesenplatz',
      'Mülheim Bahnhof',
      'Kalk Mülheimer Str.',
      'Kalk Kapelle',
      'Neustadt/Nord',
      'Nippes Straßenbahn',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Nach (Ziel-Haltestelle)',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textMedium,
          ),
        ),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(8),
                              topRight: Radius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Haltestelle wählen',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                        Flexible(
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: stations.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                leading: const Icon(
                                  Icons.location_on,
                                  color: AppColors.primary,
                                ),
                                title: Text(
                                  stations[index],
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.textDark,
                                  ),
                                ),
                                onTap: () {
                                  toController.text = stations[index];
                                  Navigator.pop(context);
                                },
                                hoverColor: AppColors.backgroundUltraLight,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
          child: TextField(
            controller: toController,
            enabled: false,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: AppColors.textDark,
            ),
            decoration: InputDecoration(
              hintText: 'Ziel wählen...',
              hintStyle: const TextStyle(
                fontSize: 18,
                color: AppColors.textMedium,
              ),
              filled: true,
              fillColor: AppColors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: const BorderSide(color: AppColors.inputBorder, width: 2),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: const BorderSide(color: AppColors.inputBorder, width: 2),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: const BorderSide(color: AppColors.inputBorder, width: 2),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: const BorderSide(color: AppColors.primary, width: 2),
              ),
              contentPadding: const EdgeInsets.all(17),
              prefixIcon: const Icon(
                Icons.location_on,
                color: AppColors.primary,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTripDetails() {
    if (toController.text.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: AppColors.white,
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(4),
        ),
        child: const Center(
          child: Text(
            'Bitte wählen Sie eine Zielhaltestelle aus, um Fahrtinformationen zu sehen.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textMedium,
              fontSize: 14,
            ),
          ),
        ),
      );
    }

    // Dummy logic depending on destination
    final isLongDistance = toController.text.length > 5;
    final duration = isLongDistance ? 45 : 12;
    final stops = isLongDistance ? 12 : 3;
    final price = isLongDistance ? 5.30 : 3.20;

    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: AppColors.white,
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(4),
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withValues(alpha: 0.05),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildInfoRow('⏱️ Fahrtzeit', '$duration Min'),
              const Divider(height: 20, color: AppColors.divider),
              _buildInfoRow('🚏 Zwischenstopps', '$stops Haltestellen'),
              const Divider(height: 20, color: AppColors.divider),
              _buildInfoRow('💶 Ticketpreis', '${price.toStringAsFixed(2).replaceAll('.', ',')} €', isPrice: true),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isPrice = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 17,
            color: AppColors.textMedium,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isPrice ? 22 : 18,
            fontWeight: FontWeight.w700,
            color: isPrice ? AppColors.primary : AppColors.textDark,
          ),
        ),
      ],
    );
  }
}
