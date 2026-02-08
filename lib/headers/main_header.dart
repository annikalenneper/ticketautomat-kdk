import 'package:flutter/material.dart';
import 'package:ticket_alternative/styles/app_colors.dart';
import '../views/hilfecenter.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 38, vertical: 22),
      decoration: const BoxDecoration(
        color: AppColors.primary,
        border: Border(
          bottom: BorderSide(color: AppColors.black, width: 2),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                height: 67,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  border: Border.all(color: AppColors.black, width: 2),
                ),
                child: Image.asset(
                  'lib/img/LOGO.jpeg',
                  fit: BoxFit.fitHeight,
                ),
              ),
              const SizedBox(width: 18),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'KDK Ticketautomat',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.3,
                    ),
                  ),
                  SizedBox(height: 3),
                  Text(
                    'Kollektiv-Verbundgebiet Köln',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HilfeCenter()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.backgroundLight,
              foregroundColor: AppColors.black,
              padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 15),
              elevation: 4,
              shadowColor: AppColors.black,
              shape: const ContinuousRectangleBorder(
                side: BorderSide(color: AppColors.black, width: 2),
              ),
            ),
            child: const Row(
              children: [
                Text('?', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(width: 10),
                Text(
                  'Hilfe-Center',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
