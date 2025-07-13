import 'package:creativolabs/core/widgets/container.dart';
import 'package:creativolabs/screens/places/widget/nearby_places_section.dart';
import 'package:flutter/material.dart';

class Places extends StatelessWidget {
  const Places({super.key});

  @override
  Widget build(BuildContext context) {
    return const MainContainer(
      child: NearbyPlacesSection(),
    );
  }
}
