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
        decoration: BoxDecoration(
          color: AppColors.backgroundLight,
          border: Border.all(color: AppColors.black, width: 2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('🚉 REISEPLANUNG'),
            const SizedBox(height: 10),
            _buildFixedStartStation(),
            const SizedBox(height: 12),
            _buildDestinationInput(context),
            const SizedBox(height: 20),
            _buildSectionTitle('ℹ️ FAHRTPREIS', fontSize: 18),
            const SizedBox(height: 10),
            Expanded(
              child: _buildTripDetails(),
            ),
            const SizedBox(height: 15),
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: AppColors.black,
                    offset: Offset(4, 4),
                  ),
                ],
              ),
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
                  elevation: 0,
                  side: const BorderSide(color: AppColors.black, width: 2),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                  disabledBackgroundColor: AppColors.border,
                ),
                child: const Text(
                  'BUCHUNG FORTSETZEN',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2,
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
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w800,
          color: AppColors.white,
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  Widget _buildFixedStartStation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'STANDORT (START)',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 5),
        Container(
          decoration: const BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: AppColors.black,
                offset: Offset(4, 4),
              ),
            ],
          ),
          child: TextField(
            enabled: false,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
            decoration: InputDecoration(
              hintText: 'BüZe Ehrenfeld (Unten durch West)',
              hintStyle: const TextStyle(
                fontSize: 18,
                color: AppColors.textMedium,
              ),
              filled: true,
              fillColor: AppColors.white,
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.zero,
                borderSide: BorderSide(color: AppColors.black, width: 2),
              ),
              enabledBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.zero,
                borderSide: BorderSide(color: AppColors.black, width: 2),
              ),
              disabledBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.zero,
                borderSide: BorderSide(color: AppColors.black, width: 2),
              ),
              focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.zero,
                borderSide: BorderSide(color: AppColors.black, width: 3),
              ),
              contentPadding: const EdgeInsets.all(17),
              prefixIcon: const Icon(
                Icons.home_work,
                color: AppColors.black,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDestinationInput(BuildContext context) {
    const stations = [
      'Hauptbahnhof',
      'Oben drüber',
      'Appellhofplatz',
      'Bielefeld',
      'Metropolis',
      'In die Vergangenheit',
      'Streichelzoo',
      'Neptunbad',
      'Zu mir oder zu dir',
      'Ab nach Hause',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'ZIEL-HALTESTELLE',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 5),
        GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return Dialog(
                  shape: const ContinuousRectangleBorder(
                    side: BorderSide(color: AppColors.black, width: 3),
                  ),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: AppColors.backgroundLight,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: const BoxDecoration(
                            color: AppColors.secondary,
                            border: Border(
                              bottom: BorderSide(color: AppColors.black, width: 2),
                            ),
                          ),
                          child: const Text(
                            'HALTESTELLE WÄHLEN',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              color: AppColors.white,
                              letterSpacing: 1,
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
                                  color: AppColors.black,
                                ),
                                title: Text(
                                  stations[index],
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
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
          child: Container(
            decoration: const BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: AppColors.black,
                  offset: Offset(4, 4),
                ),
              ],
            ),
            child: TextField(
              controller: toController,
              enabled: false,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
              ),
              decoration: InputDecoration(
                hintText: 'ZUR AUSWAHL TIPPEN...',
                hintStyle: const TextStyle(
                  fontSize: 18,
                  color: AppColors.textMedium,
                  fontWeight: FontWeight.w800,
                ),
                filled: true,
                fillColor: AppColors.white,
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.zero,
                  borderSide: BorderSide(color: AppColors.black, width: 2),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.zero,
                  borderSide: BorderSide(color: AppColors.black, width: 2),
                ),
                disabledBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.zero,
                  borderSide: BorderSide(color: AppColors.black, width: 2),
                ),
                contentPadding: const EdgeInsets.all(17),
                prefixIcon: const Icon(
                  Icons.search,
                  color: AppColors.black,
                ),
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
          border: Border.all(color: AppColors.black, width: 2),
          boxShadow: const [
            BoxShadow(
              color: AppColors.black,
              offset: Offset(4, 4),
            ),
          ],
        ),
        child: const Center(
          child: Text(
            'SYSTEM BEREIT.\nBITTE ZIELHALTESTELLE EINGEBEN.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textDark,
              fontSize: 14,
              fontWeight: FontWeight.w800,
              height: 1.5,
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
            border: Border.all(color: AppColors.black, width: 2),
            boxShadow: const [
              BoxShadow(
                color: AppColors.black,
                offset: Offset(4, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildInfoRow('⏱️ ZEIT', '$duration MIN'),
              const Divider(height: 20, color: AppColors.black, thickness: 1),
              _buildInfoRow('🚏 STOPPS', '$stops HTS.'),
              const Divider(height: 20, color: AppColors.black, thickness: 1),
              _buildInfoRow('💶 PREIS', '${price.toStringAsFixed(2).replaceAll('.', ',')} EUR', isPrice: true),
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
