import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:halal_life/constants.dart';
import 'package:halal_life/main/presentation/widgets/category_view.dart';
import 'package:halal_life/main/presentation/widgets/cuisine_list_view.dart';
import 'package:halal_life/main/presentation/widgets/food_suggestion_list_view.dart';
import 'package:halal_life/main/presentation/widgets/location_selection_bar.dart';
import 'package:halal_life/main/presentation/widgets/main_app_bar.dart';
import 'package:halal_life/main/presentation/widgets/main_search_bar.dart';
import 'package:halal_life/main/presentation/widgets/nearby_places_list_view.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: Column(
          children: [
            MainAppBar(),
            Gap(16),
            MainSearchBar(),
            Gap(16),
            LocationSelectionBar(),
            Gap(16),
            CuisineListView(),
            Gap(24),
            FoodSuggestionListView(),
            Gap(24),
            CategoryView(),
            Gap(24),
            NearbyPlacesListView(),
            Gap(32),
          ],
        ),
      ),
    );
  }
}
