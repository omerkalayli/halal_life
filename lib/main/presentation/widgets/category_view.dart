import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:halal_life/constants.dart';

class CategoryView extends StatelessWidget {
  const CategoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 16, right: 16, bottom: 8),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(' Kategoriler', style: mainHeaderStyle),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _CategoryButton(icon: '🍽️', label: 'Restoranlar', count: 18),
                  _CategoryButton(icon: '☕', label: 'Kafeler', count: 18),
                ],
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _CategoryButton(icon: '🛒', label: 'Marketler', count: 18),
                  _CategoryButton(icon: '🥖', label: 'Fırınlar', count: 18),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CategoryButton extends StatelessWidget {
  final String icon;
  final String label;
  final int count;

  const _CategoryButton({
    required this.icon,
    required this.label,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: AspectRatio(
        aspectRatio: 1.5,
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          constraints: BoxConstraints(minWidth: 80),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(icon, style: TextStyle(fontSize: 32)),
                Gap(4),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: mint,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  "$count işletme",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: darkMint,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
