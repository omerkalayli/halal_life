import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:halal_life/constants.dart';
import 'package:halal_life/main/presentation/widgets/suggestion_container.dart';

class FoodSuggestionListView extends StatelessWidget {
  const FoodSuggestionListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
          child: Center(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(' Yemek Önerileri', style: mainHeaderStyle),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Color(0xFFFFE5E5),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        '🔥 Popüler',
                        style: TextStyle(
                          color: Color(0xFFDC2626),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              SuggestionContainer(
                child: Text(
                  "⚡ Hızlı Teslimat",
                  style: TextStyle(color: mint, fontWeight: FontWeight.w500),
                ),
              ),
              Gap(8),
              SuggestionContainer(
                child: Text(
                  "💰 Uygun Fiyat",
                  style: TextStyle(color: mint, fontWeight: FontWeight.w500),
                ),
              ),
              Gap(8),
              SuggestionContainer(
                child: Text(
                  "⭐ En İyi",
                  style: TextStyle(color: mint, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ),
        Gap(16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.only(left: 16, bottom: 8, right: 12),
          child: Row(
            children: [
              _FoodButton(icon: '🍰', label: 'Tatlı'),
              _FoodButton(icon: '🍕', label: 'Pizza'),
              _FoodButton(icon: '🥙', label: 'Döner'),
              _FoodButton(icon: '🍖', label: 'Kebap'),
              _FoodButton(icon: '🍛', label: 'Pilav'),
              _FoodButton(icon: '🍲', label: 'Çorba'),
              _FoodButton(icon: '🍔', label: 'Burger'),
            ],
          ),
        ),
        Gap(12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.only(left: 16, bottom: 8, right: 12),
          child: Row(
            children: [
              _FoodButton(icon: '🥗', label: 'Salata'),
              _FoodButton(icon: '☕', label: 'Kahve'),
              _FoodButton(icon: '🥤', label: 'İçecek'),
              _FoodButton(icon: '🍦', label: 'Dondurma'),
              _FoodButton(icon: '🥟', label: 'Mantı'),
              _FoodButton(icon: '🌯', label: 'Wrap'),
              _FoodButton(icon: '🍳', label: 'Kahvaltı'),
            ],
          ),
        ),
      ],
    );
  }
}

class _FoodButton extends StatelessWidget {
  final String icon;
  final String label;

  const _FoodButton({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 8),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      constraints: BoxConstraints(minWidth: 80),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        children: [
          Text(icon, style: TextStyle(fontSize: 24)),
          Gap(4),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: darkMint,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
