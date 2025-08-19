import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:halal_life/main/presentation/notifiers/place_notifier.dart';
import 'package:halal_life/main/presentation/widgets/category_view.dart';
import 'package:halal_life/main/presentation/widgets/cuisine_list_view.dart';
import 'package:halal_life/main/presentation/widgets/food_suggestion_list_view.dart';
import 'package:halal_life/main/presentation/widgets/location_selection_bar.dart';
import 'package:halal_life/main/presentation/widgets/main_app_bar.dart';
import 'package:halal_life/main/presentation/widgets/main_search_bar.dart';
import 'package:halal_life/main/presentation/widgets/nearby_places_list_view.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';

class MainPage extends HookConsumerWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = useState(true);
    final placesSet = ref.watch(allPlacesProvider);
    useEffect(() {
      // Simulate a loading state
      Future.microtask(() async {
        isLoading.value = true;
        await ref.read(placeNotifierProvider.notifier).fetchAllPlaces();
        isLoading.value = false;
      });
      return null;
    }, []);

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Skeletonizer(enabled: isLoading.value, child: MainAppBar()),
            Gap(16),
            Skeletonizer(enabled: isLoading.value, child: MainSearchBar()),
            Gap(16),
            Skeletonizer(
              enabled: isLoading.value,
              child: LocationSelectionBar(),
            ),
            Gap(16),
            Skeletonizer(enabled: isLoading.value, child: CuisineListView()),
            Gap(24),
            Skeletonizer(
              enabled: isLoading.value,
              child: FoodSuggestionListView(),
            ),
            Gap(24),
            Skeletonizer(enabled: isLoading.value, child: CategoryView()),
            Gap(24),
            Skeletonizer(
              enabled: isLoading.value,
              child: NearbyPlacesListView(),
            ),
            Gap(32),
          ],
        ),
      ),
    );
  }
}
