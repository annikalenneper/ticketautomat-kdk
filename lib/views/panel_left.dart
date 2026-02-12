import 'package:flutter/material.dart';
import 'package:ticket_alternative/styles/app_colors.dart';
import 'package:ticket_alternative/models/haltestelle.dart';
import 'package:ticket_alternative/printservice/print_service.dart';
import 'package:ticket_alternative/printservice/ticket_template.dart';
import 'package:ticket_alternative/dialogues/print_dialogs.dart';

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
                    : () async {
                        // Hole Daten aus JSON
                        final haltestelle = HaltestellenService.findByName(toController.text);
                        final preisString = haltestelle?.preis ?? '0';
                        final fahrzeitString = haltestelle?.fahrzeit ?? 'Unbekannt';
                        final zwischenstoppsString = haltestelle?.zwischenstopps ?? 'Unbekannt';
                        final dialogHint = haltestelle?.dialog;

                        // Zeige Hinweis-Dialog wenn vorhanden
                        if (dialogHint != null && context.mounted) {
                          final shouldContinue = await showDialog<bool>(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) => HintDialog(hint: dialogHint),
                          );
                          if (shouldContinue != true || !context.mounted) return;
                        }

                        // Zeige Zusammenfassungs-Dialog (immer)
                        if (!context.mounted) return;
                        final shouldPrint = await showDialog<bool>(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) => TicketSummaryDialog(
                            from: 'BüZe Ehrenfeld - Unten durch (West)',
                            to: toController.text,
                            preis: preisString,
                            fahrzeit: fahrzeitString,
                            zwischenstopps: zwischenstoppsString,
                          ),
                        );
                        if (shouldPrint != true || !context.mounted) return;

                        // Zeige "Druckt..."-Dialog und warte auf dessen Schließen
                        await showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) => FutureBuilder(
                            future: () async {
                              try {
                                final ticketData = TicketData(
                                  from: 'BüZe Ehrenfeld - Unten durch (West)',
                                  to: toController.text,
                                  dateTime: DateTime.now(),
                                  preis: preisString,
                                  fahrzeit: fahrzeitString,
                                  ticketType: 'Einzelticket',
                                );
                                await PrintService().printTicket(ticketData);
                                await Future.delayed(const Duration(seconds: 2));
                              } catch (e) {}
                            }(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.done) {
                                // Schließe Dialog automatisch
                                Future.microtask(() => Navigator.of(context).pop());
                              }
                              return const PrintingDialog();
                            },
                          ),
                        );

                        if (!context.mounted) return;
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) => const TicketReceiptDialog(),
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
              hintText: 'BüZe Ehrenfeld - Unten durch (West)',
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
          onTap: () async {
            final haltestellen = await HaltestellenService.loadHaltestellen();
            if (!context.mounted) return;
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return Dialog(
                  backgroundColor: Colors.transparent,
                  insetPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.backgroundLight,
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
                                'HALTESTELLE WÄHLEN',
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
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: GridView.builder(
                              itemCount: haltestellen.length,
                              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 250,
                                crossAxisSpacing: 15,
                                mainAxisSpacing: 15,
                                childAspectRatio: 2.2,
                              ),
                              itemBuilder: (context, index) {
                                final station = haltestellen[index];
                                return GestureDetector(
                                  onTap: () {
                                    toController.text = station.name;
                                    Navigator.pop(context);
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
                                      decoration: BoxDecoration(
                                        color: AppColors.white,
                                        border: Border.all(color: AppColors.black, width: 2),
                                      ),
                                      alignment: Alignment.center,
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                      child: Text(
                                        station.name.toUpperCase(),
                                        textAlign: TextAlign.center,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w800,
                                          color: AppColors.textDark,
                                          height: 1.1,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
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

    // Hole Daten aus der JSON
    final haltestelle = HaltestellenService.findByName(toController.text);
    final fahrzeit = haltestelle?.fahrzeit ?? 'Unbekannt';
    final stops = haltestelle?.zwischenstopps ?? 'Unbekannt';
    final preis = haltestelle?.preis ?? 'Unbekannt';

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
              _buildInfoRow('⏱️ ZEIT', fahrzeit),
              const Divider(height: 20, color: AppColors.black, thickness: 1),
              _buildInfoRow('🚏 STOPPS', stops),
              const Divider(height: 20, color: AppColors.black, thickness: 1),
              _buildInfoRow('💶 PREIS', preis, isPrice: true),
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
